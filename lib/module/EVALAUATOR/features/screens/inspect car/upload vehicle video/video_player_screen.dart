import 'package:flutter/material.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String file;
  const VideoPlayerScreen({super.key, required this.file});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  // late VideoPlayerController _controller;

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = VideoPlayerController.network(
  //       'https://www.example.com/video.mp4',
  //     )
  //     ..initialize().then((_) {
  //       setState(() {}); // refresh when video initializes
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
