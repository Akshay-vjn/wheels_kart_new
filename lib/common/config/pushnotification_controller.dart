import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/auth/data/repo/v_set_push_token_repo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart'
    show consolidateHttpClientResponseBytes;

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Handling a background message: ${message.messageId}");
  // Do NOT show a notification manually here; Firebase handles it automatically
}

@pragma('vm:entry-point')
Future<void> onBackgroundNotificationResponse(
  NotificationResponse response,
) async {
  log("Background Notification Clicked: ${response.payload}");
  if (response.payload != null) {
    PushNotificationConfig.handleNotificationClick(response.payload!);
  }
}

class PushNotificationConfig {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? _notiToken;
  String? apiToken;

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
        // sound: RawResourceAndroidNotificationSound('notification_sound')
      );

  Future<void> initNotification(BuildContext context) async {
    log('Requesting push notification permissions...');

    if (Platform.isAndroid || Platform.isIOS) {
      // _firebaseMessaging.subscribeToTopic("all-devices");
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    await _initLocalNotification();
    await _getExistingToken(context);

    FirebaseMessaging.onMessage.listen((message) {
      log('Foreground Notification Received...');
      _showNotificationFromMessage(message);
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleNotificationClick(jsonEncode(event.data));
    });

    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) async {
      if (message != null) {
        await Future.delayed(Duration(seconds: 3));
        handleNotificationClick(jsonEncode(message.data));
      }
    });
  }

  Future<void> _getExistingToken(BuildContext context) async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        _notiToken = token;
        _updateTokenInDatabase(token, context);
      }

      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _notiToken = newToken;
        _updateTokenInDatabase(newToken, context);
      });

      log('FCM Token: ${_notiToken!}');

      if (Platform.isIOS) {
        String? apnsToken = await _firebaseMessaging.getAPNSToken();
        log("APNs Token: $apnsToken");
      }
    } catch (e) {
      log('Error getting FCM token: $e');
    }
  }

  void _updateTokenInDatabase(String newToken, BuildContext context) async {
    final getUserPref = await AppAuthController().getUserData;
    if (getUserPref.userType == "VENDOR") {
      await VSetPushTokenRepo.onSetVendorPushToken(context, newToken);
    } else {}
  }

  Future<void> _initLocalNotification() async {
    const AndroidInitializationSettings androidInitialization =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitialization =
        DarwinInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: androidInitialization,
          iOS: iosInitialization,
        );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) async {
        log('Notification Clicked: ${response.payload}');

        handleNotificationClick(response.payload);
      },
      onDidReceiveBackgroundNotificationResponse:
          onBackgroundNotificationResponse,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);
  }

  void _showNotificationFromMessage(RemoteMessage message) async {
    final notification = message.notification;

    // Try to get image URL (data key 'image' is common)
    String? imageUrl =
        message.data['image'] ??
        message.notification?.apple?.imageUrl; // if you send it this way

    String? localImagePath;
    if (imageUrl != null && imageUrl.isNotEmpty && Platform.isIOS) {
      localImagePath = await _downloadToFile(imageUrl, 'push_image.jpg');
    }
    if (notification != null) {
      _showNotification(
        id: notification.hashCode,

        title: notification.title,
        body: notification.body,
        payload: jsonEncode(message.data),
        iosImagePath: localImagePath,
        androidImageUrl: imageUrl,
      );
    }
  }

  Future<void> _showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    String? iosImagePath,
    String? androidImageUrl,
  }) async {
    _localNotificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
        iOS: DarwinNotificationDetails(
          attachments:
              (iosImagePath != null)
                  ? [DarwinNotificationAttachment(iosImagePath)]
                  : null,
          // sound: 'notification_sound.wav'
        ),
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          icon: '@mipmap/ic_launcher',
          importance: Importance.max,
          priority: Priority.high,
          styleInformation:
              (androidImageUrl != null && androidImageUrl.isNotEmpty)
                  ? BigPictureStyleInformation(
                    FilePathAndroidBitmap(
                      androidImageUrl,
                    ), // if you prefer download first, use a file path
                    contentTitle: title,
                    summaryText: body,
                  )
                  : null,
          // sound: RawResourceAndroidNotificationSound('notification_sound')
        ),
      ),
      payload: payload,
    );
  }

  Future<String?> _downloadToFile(String url, String filename) async {
    try {
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(Uri.parse(url));
      final response = await request.close();
      if (response.statusCode == 200) {
        final bytes = await consolidateHttpClientResponseBytes(response);
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/$filename');
        await file.writeAsBytes(bytes);
        return file.path;
      }
    } catch (_) {}
    return null;
  }

  static void handleNotificationClick(String? payload) {
    if (payload == null || payload.isEmpty) return;

    final data = jsonDecode(payload);
    _navigateToScreen(data);
  }

  static void _navigateToScreen(Map<String, dynamic> data) async {
    try {
      // rootNavigatorKey.currentContext?.push(notificationScreen);
    } catch (e) {
      log('Navigation failed: $e');
    }
  }

  Future<void> deleteToken() async {
    await _firebaseMessaging.deleteToken();
  }
}


// UPDATE TOKEN
// NAVIAGTIO FUNCTION