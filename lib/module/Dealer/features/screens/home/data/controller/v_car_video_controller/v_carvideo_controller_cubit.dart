import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:video_player/video_player.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_detail_model.dart';

part 'v_carvideo_controller_state.dart';

// class VCarvideoControllerCubit extends Cubit<VCarvideoControllerState> {
//   late VideoPlayerController controller;

//   VCarvideoControllerCubit() : super(VCarvideoControllerInitialState());

//   Future<void> onSelectVideo(CarVideos carVideo, int index) async {
//     try {
//       final currentState = state;

//       // If already initialized, toggle play/pause
//       if (currentState is VCarVideoControllerVideoSuccessState) {
//         if (index == currentState.currentIndex) {
//           if (controller.value.isPlaying) {
//             controller.pause();
//             emit(
//               VCarVideoControllerVideoSuccessState(
//                 isPlaying: false,
//                 currentIndex: index,
//               ),
//             );
//           } else {
//             controller.play();
//             emit(
//               VCarVideoControllerVideoSuccessState(
//                 isPlaying: true,
//                 currentIndex: index,
//               ),
//             );
//           }
//           return;
//         } else {
//           controller.pause();
//           emit(
//             VCarVideoControllerVideoSuccessState(
//               isPlaying: false,
//               currentIndex: index,
//             ),
//           );
//         }
//       }

//       // Load new video
//       emit(VCarVideoControllerVideoLoadingState());
//       log("Initializing video...");

//       controller = VideoPlayerController.networkUrl(Uri.parse(carVideo.url));
//       await controller.initialize(); // ✅ Wait for async initialization

//       // Add listener after init
//       controller.addListener(() {
//         if (controller.value.position == controller.value.duration) {
//           // video completed
//           controller.pause();
//           emit(
//             VCarVideoControllerVideoSuccessState(
//               isPlaying: false,
//               currentIndex: index,
//             ),
//           );
//         }
//       });

//       controller.play();
//       emit(
//         VCarVideoControllerVideoSuccessState(
//           isPlaying: true,
//           currentIndex: index,
//         ),
//       );
//     } catch (e) {
//       log("Video load error: $e");
//       emit(VCarVideoControllerVideoErrorState(error: e.toString()));
//     }
//   }

//   @override
//   Future<void> close() {
//     controller.dispose();
//     return super.close();
//   }

//   void stopVideoPlayer(int index, BuildContext context) {
//     final currentState = state;
//     if (currentState is VCarvideoControllerInitialState) {
//       Navigator.of(context).pop();
//       return;
//     } else {
//       if (controller.value.isInitialized) {
//         controller.pause();
//         emit(
//           VCarVideoControllerVideoSuccessState(
//             isPlaying: true,
//             currentIndex: index,
//           ),
//         );
//         Navigator.of(context).pop();
//       }
//     }
//   }
// }


class VCarvideoControllerCubit extends Cubit<VCarvideoControllerState> {
  VideoPlayerController? controller;

  VCarvideoControllerCubit() : super(VCarvideoControllerInitialState());

  /// Initialize a new video
  Future<void> initializePlayer(CarVideos carVideo, int index) async {
    try {
      emit(VCarVideoControllerVideoLoadingState());

      // Dispose old controller if exists
      await controller?.dispose();

      controller = VideoPlayerController.networkUrl(Uri.parse(carVideo.url));
      await controller!.initialize();

      controller!.addListener(() {
        if (controller != null &&
            controller!.value.isInitialized &&
            controller!.value.position >= controller!.value.duration) {
          pause();
        }
      });

      emit(
        VCarVideoControllerVideoSuccessState(
          isPlaying: false,
          currentIndex: index,
        ),
      );
    } catch (e, s) {
      log("Video init error: $e", stackTrace: s);
      emit(VCarVideoControllerVideoErrorState(error: e.toString()));
    }
  }

  /// Play video
  Future<void> play() async {
    if (controller != null && controller!.value.isInitialized) {
      await controller!.play();
      emit(
        VCarVideoControllerVideoSuccessState(
          isPlaying: true,
          currentIndex: (state is VCarVideoControllerVideoSuccessState)
              ? (state as VCarVideoControllerVideoSuccessState).currentIndex
              : -1,
        ),
      );
    }
  }

  /// Pause video
  Future<void> pause() async {
    if (controller != null && controller!.value.isInitialized) {
      await controller!.pause();
      emit(
        VCarVideoControllerVideoSuccessState(
          isPlaying: false,
          currentIndex: (state is VCarVideoControllerVideoSuccessState)
              ? (state as VCarVideoControllerVideoSuccessState).currentIndex
              : -1,
        ),
      );
    }
  }

  /// Toggle play/pause
  Future<void> togglePlayPause() async {
    if (controller != null && controller!.value.isInitialized) {
      controller!.value.isPlaying ? await pause() : await play();
    }
  }

  /// Stop & close screen
  void stopAndClose(BuildContext context) {
    pause();
    Navigator.of(context).pop();
  }

  @override
  Future<void> close() async {
    await controller?.dispose();
    return super.close();
  }
}
