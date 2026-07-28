import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:wheels_kart/module/Dealer/features/widgets/v_custom_backbutton.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_loading_indicator.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String file;
  const VideoPlayerScreen({super.key, required this.file});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool isPlaying = false;
  String _statusMessage = 'Preparing video...';
  double _downloadProgress = 0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _prepareAndPlay();
  }

  Future<void> _prepareAndPlay() async {
    try {
      final source = widget.file.trim();
      log('VideoPlayer source: $source');

      final VideoPlayerController controller;
      if (_isNetworkSource(source)) {
        setState(() {
          _statusMessage = 'Downloading video...';
          _downloadProgress = 0;
        });
        final cachedFile = await _cacheRemoteVideo(source);
        controller = VideoPlayerController.file(
          cachedFile,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        );
      } else {
        final localPath = _localFilePath(source);
        controller = VideoPlayerController.file(
          File(localPath),
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        );
      }

      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }

      controller.addListener(_onPlaybackUpdate);

      setState(() {
        _controller = controller;
        _statusMessage = '';
        _errorMessage = null;
      });
    } catch (error, stackTrace) {
      log('Video preview failed: $error', stackTrace: stackTrace);
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Unable to load video preview.';
        _statusMessage = '';
      });
    }
  }

  Future<File> _cacheRemoteVideo(String url) async {
    final uri = Uri.parse(url);
    final cacheDir = await getTemporaryDirectory();
    final cacheFile = File(
      '${cacheDir.path}/preview_${uri.hashCode.abs()}.mp4',
    );

    if (await cacheFile.exists()) {
      final size = await cacheFile.length();
      if (size > 0) {
        log('Using cached preview video (${size} bytes)');
        return cacheFile;
      }
    }

    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(minutes: 2),
        responseType: ResponseType.bytes,
      ),
    );

    await dio.download(
      url,
      cacheFile.path,
      deleteOnError: true,
      onReceiveProgress: (received, total) {
        if (!mounted || total <= 0) return;
        setState(() {
          _downloadProgress = received / total;
          _statusMessage =
              'Downloading video... ${(received / total * 100).round()}%';
        });
      },
    );

    return cacheFile;
  }

  bool _isNetworkSource(String source) {
    final uri = Uri.tryParse(source);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }

  String _localFilePath(String source) {
    if (source.startsWith('file://')) {
      return source.replaceFirst('file://', '');
    }
    return source;
  }

  void _onPlaybackUpdate() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (controller.value.isCompleted) {
      controller.pause();
      if (mounted && isPlaying) {
        setState(() => isPlaying = false);
      }
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onPlaybackUpdate);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return Scaffold(
      backgroundColor: EvAppColors.black,
      body: SafeArea(
        child: Stack(
          children: [
            if (controller != null && controller.value.isInitialized)
              Center(
                child: AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                ),
              )
            else if (_errorMessage != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.white70,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _errorMessage = null;
                            _statusMessage = 'Preparing video...';
                          });
                          _prepareAndPlay();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            else
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    EVAppLoadingIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      _statusMessage,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    if (_downloadProgress > 0) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: 200,
                        child: LinearProgressIndicator(
                          value: _downloadProgress,
                          backgroundColor: Colors.white24,
                          color: EvAppColors.DEFAULT_ORANGE,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            VCustomBackbutton(
              onTap: () {
                _controller?.pause();
                Navigator.of(context).pop();
              },
              blendColor: EvAppColors.black.withAlpha(150),
            ),
          ],
        ),
      ),
      bottomNavigationBar: controller != null && controller.value.isInitialized
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: InkWell(
                overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                onTap: () {
                  setState(() {
                    if (controller.value.isPlaying) {
                      controller.pause();
                      isPlaying = false;
                    } else {
                      controller.play();
                      isPlaying = true;
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: EvAppColors.white),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: EvAppColors.white,
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
