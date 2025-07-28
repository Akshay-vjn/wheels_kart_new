import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_loading_indicator.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String file;
  const VideoPlayerScreen({super.key, required this.file});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    log(widget.file);
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.file))
      ..initialize().then((_) {
        setState(() {}); // refresh when video initializes
      });

    _controller.addListener(() {
      if (_controller.value.isCompleted) {
        _controller.pause();
        isPlaying = false;
        setState(() {});
      }
    });
  }

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: EvAppColors.white),
      body:
          _controller.value.isInitialized
              ? SingleChildScrollView(
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    AppSpacer(heightPortion: .03),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                            isPlaying = false;
                          } else {
                            _controller.play();
                            isPlaying = true;
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(width: 2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                      ),
                    ),
                    AppSpacer(heightPortion: .03),
                  ],
                ),
              )
              : EVAppLoadingIndicator(),
    );
  }
}
