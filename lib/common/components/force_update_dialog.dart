import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wheels_kart/common/services/force_update_service.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';

/// A dialog that forces users to update the app
class ForceUpdateDialog extends StatelessWidget {
  const ForceUpdateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent back button from closing dialog
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          children: [
            Icon(
              Icons.system_update,
              color: EvAppColors.DEFAULT_BLUE_DARK,
              size: 30,
            ),
            const SizedBox(width: 10),
            const Text(
              'Update Required',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'A new version of Wheels Kart is available and required to continue.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Please update to the latest version to enjoy new features and improvements.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'The app cannot be used until updated',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _openStore(),
              style: ElevatedButton.styleFrom(
                backgroundColor: EvAppColors.DEFAULT_BLUE_DARK,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Platform.isAndroid
                        ? Icons.shop
                        : Icons.apple,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Update Now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
      ),
    );
  }

  /// Open the app store based on platform
  Future<void> _openStore() async {
    try {
      String storeUrl = ForceUpdateService().getStoreUrl();
      final Uri url = Uri.parse(storeUrl);

      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        print('Could not launch $storeUrl');
      }
    } catch (e) {
      print('Error opening store: $e');
    }
  }
}

/// Helper function to show force update dialog
Future<void> showForceUpdateDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissing by tapping outside
    builder: (BuildContext context) {
      return const ForceUpdateDialog();
    },
  );
}
