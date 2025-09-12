// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:video_player/video_player.dart';
// import 'package:wheels_kart/common/components/app_empty_text.dart';
// import 'package:wheels_kart/common/components/app_spacer.dart';
// import 'package:wheels_kart/common/utils/responsive_helper.dart';
// import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
// import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
// import 'package:wheels_kart/module/Dealer/core/v_style.dart';
// import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v_car_video_controller/v_carvideo_controller_cubit.dart';
// import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_detail_model.dart';
// import 'package:wheels_kart/module/Dealer/features/widgets/v_custom_backbutton.dart';

// class CarVideoScreen extends StatefulWidget {
//   final List<CarVideos> carVideos;
//   const CarVideoScreen({super.key, required this.carVideos});

//   @override
//   State<CarVideoScreen> createState() => _CarVideoScreenState();
// }

// class _CarVideoScreenState extends State<CarVideoScreen> {
//   bool isPlaying = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   backgroundColor: VColors.WHITE,
//       //   leading: VCustomBackbutton(
//       //     onTap: () {
//       //       context.read<VCarvideoControllerCubit>().stopVideoPlayer(
//       //         0,
//       //         context,
//       //       );
//       //     },
//       //   ),
//       // ),
//       body: Column(
//         children: [
//           Container(
//             height: 120,
//             width: w(context),
//             decoration: BoxDecoration(
//               boxShadow: [
//                 BoxShadow(
//                   color: VColors.BLACK.withAlpha(40),
//                   blurRadius: 12,
//                   offset: Offset(2, 2),
//                 ),
//               ],
//               color: VColors.WHITE,
//             ),
//             child: SafeArea(
//               child: Row(
//                 children: [
//                   VCustomBackbutton(
//                     blendColor: VColors.GREY,
//                     onTap: () {
//                       context.read<VCarvideoControllerCubit>().stopVideoPlayer(
//                         0,
//                         context,
//                       );
//                     },
//                   ),
//                   AppSpacer(widthPortion: .03),
//                   Text(
//                     "Car Videos",
//                     style: VStyle.style(
//                       size: 15,
//                       context: context,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Expanded(
//           //   child: Center(
//           //     child: BlocBuilder<
//           //       VCarvideoControllerCubit,
//           //       VCarvideoControllerState
//           //     >(
//           //       builder: (context, state) {
//           //         switch (state) {
//           //           case VCarVideoControllerVideoErrorState():
//           //             {
//           //               return AppEmptyText(text: state.error);
//           //             }
//           //           case VCarVideoControllerVideoLoadingState():
//           //             {
//           //               return VLoadingIndicator();
//           //             }
//           //           case VCarVideoControllerVideoSuccessState():
//           //             {
//           //               return SingleChildScrollView(
//           //                 child: AspectRatio(
//           //                   aspectRatio:
//           //                       context
//           //                           .read<VCarvideoControllerCubit>()
//           //                           .controller
//           //                           .value
//           //                           .aspectRatio,
//           //                   child: VideoPlayer(
//           //                     context
//           //                         .read<VCarvideoControllerCubit>()
//           //                         .controller,
//           //                   ),
//           //                 ),
//           //               );
//           //             }
//           //           default:
//           //             {
//           //               return AppEmptyText(text: "Play Video");
//           //             }
//           //         }
//           //       },
//           //     ),
//           //   ),
//           // ),
//           Expanded(
//             child: Center(
//               child: BlocBuilder<
//                 VCarvideoControllerCubit,
//                 VCarvideoControllerState
//               >(
//                 builder: (context, state) {
//                   switch (state) {
//                     case VCarVideoControllerVideoErrorState():
//                       return AppEmptyText(text: state.error);

//                     case VCarVideoControllerVideoLoadingState():
//                       return VLoadingIndicator();

//                     case VCarVideoControllerVideoSuccessState():
//                       final ctrl =
//                           context.read<VCarvideoControllerCubit>().controller;
//                       if (ctrl != null && ctrl.value.isInitialized) {
//                         return AspectRatio(
//                           aspectRatio: ctrl.value.aspectRatio,
//                           child: VideoPlayer(ctrl),
//                         );
//                       } else {
//                         return AppEmptyText(text: "Video not ready");
//                       }

//                     default:
//                       return AppEmptyText(text: "Play Video");
//                   }
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: Container(
// alignment: Alignment.center,
// height: 120,
// width: w(context),
// decoration: BoxDecoration(
//   boxShadow: [
//     BoxShadow(
//       color: VColors.BLACK.withAlpha(40),
//       blurRadius: 12,
//       offset: Offset(2, 2),
//     ),
//   ],
//   color: VColors.WHITE,
// ),
//         // child: Padding(
//         //   padding: EdgeInsetsGeometry.only(bottom: 20, left: 20, right: 20),
//         //   child: Row(
//         //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         //     children:
//         //         widget.carVideos
//         //             .asMap()
//         //             .entries
//         //             .map(
//         //               (e) => BlocBuilder<
//         //                 VCarvideoControllerCubit,
//         //                 VCarvideoControllerState
//         //               >(
//         //                 builder: (context, state) {
//         //                   bool isSelected =
//         //                       state is VCarVideoControllerVideoSuccessState &&
//         //                       state.currentIndex == e.key;
//         //                   bool playing =
//         //                       state is VCarVideoControllerVideoSuccessState &&
//         //                       state.isPlaying;
//         //                   bool isLoading =
//         //                       state is VCarVideoControllerVideoLoadingState;
//         //                   return InkWell(
//         //                     onTap: () {
//         //                       context
//         //                           .read<VCarvideoControllerCubit>()
//         //                           .onSelectVideo(e.value, e.key);
//         //                     },
//         //                     child: Container(
//         //                       margin: EdgeInsets.symmetric(vertical: 20),
//         //                       alignment: Alignment.center,
//         //                       width: w(context) * .43,

//         //                       padding: EdgeInsets.symmetric(
//         //                         horizontal: 20,
//         //                         vertical: 5,
//         //                       ),
//         //                       decoration: BoxDecoration(
//         //                         borderRadius: BorderRadius.circular(15),
//         //                         color:
//         //                             isSelected
//         //                                 ? VColors.GREENHARD.withAlpha(100)
//         //                                 : null,
//         //                         border:
//         //                             isSelected
//         //                                 ? null
//         //                                 : Border.all(
//         //                                   width: 0,
//         //                                   color: VColors.GREY,
//         //                                 ),
//         //                       ),
//         //                       child:
//         //                           isLoading
//         //                               ? VLoadingIndicator()
//         //                               : Row(
//         //                                 mainAxisAlignment:
//         //                                     MainAxisAlignment.center,
//         //                                 children: [
//         //                                   isSelected
//         //                                       ? Icon(
//         //                                         size: 35,
//         //                                         color:
//         //                                             isSelected
//         //                                                 ? VColors.WHITE
//         //                                                 : VColors.GREY,
//         //                                         isSelected && playing
//         //                                             ? Icons.pause
//         //                                             : Icons.play_arrow,
//         //                                       )
//         //                                       : Row(
//         //                                         children: [
//         //                                           Icon(
//         //                                             color:
//         //                                                 isSelected
//         //                                                     ? VColors.SECONDARY
//         //                                                     : VColors.GREY,
//         //                                             e.value.type == "Walkaround"
//         //                                                 ? CupertinoIcons.car
//         //                                                 : CupertinoIcons.wrench,
//         //                                           ),
//         //                                           AppSpacer(widthPortion: .03),
//         //                                           Text(
//         //                                             e.value.type,
//         //                                             style: VStyle.style(
//         //                                               context: context,
//         //                                               fontWeight:
//         //                                                   FontWeight.bold,
//         //                                               size: 15,
//         //                                               color:
//         //                                                   isSelected
//         //                                                       ? VColors
//         //                                                           .SECONDARY
//         //                                                       : VColors.GREY,
//         //                                             ),
//         //                                           ),
//         //                                         ],
//         //                                       ),
//         //                                 ],
//         //                               ),
//         //                     ),
//         //                   );
//         //                 },
//         //               ),
//         //             )
//         //             .toList(),
//         //   ),
//         // ),
//         child: Padding(
//           padding: EdgeInsets.only(bottom: 20, left: 20, right: 20), // ✅ fixed
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children:
//                 widget.carVideos.asMap().entries.map((e) {
//                   return BlocBuilder<
//                     VCarvideoControllerCubit,
//                     VCarvideoControllerState
//                   >(
//                     builder: (context, state) {
//                       bool isSelected =
//                           state is VCarVideoControllerVideoSuccessState &&
//                           state.currentIndex == e.key;
//                       bool playing =
//                           state is VCarVideoControllerVideoSuccessState &&
//                           state.isPlaying;
//                       bool isLoading =
//                           state is VCarVideoControllerVideoLoadingState;

//                       return InkWell(
//                         onTap: () {
//                           context
//                               .read<VCarvideoControllerCubit>()
//                               .onSelectVideo(e.value, e.key);
//                         },
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(vertical: 20),
//                           alignment: Alignment.center,
//                           width: w(context) * .43,
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 20,
//                             vertical: 5,
//                           ),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15),
//                             color:
//                                 isSelected
//                                     ? VColors.GREENHARD.withAlpha(100)
//                                     : null,
//                             border:
//                                 isSelected
//                                     ? null
//                                     : Border.all(width: 0, color: VColors.GREY),
//                           ),
//                           child:
//                               isLoading
//                                   ? VLoadingIndicator()
//                                   : Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       isSelected
//                                           ? Icon(
//                                             size: 35,
//                                             color:
//                                                 isSelected
//                                                     ? VColors.WHITE
//                                                     : VColors.GREY,
//                                             isSelected && playing
//                                                 ? Icons.pause
//                                                 : Icons.play_arrow,
//                                           )
//                                           : Row(
//                                             children: [
//                                               Icon(
//                                                 color:
//                                                     isSelected
//                                                         ? VColors.SECONDARY
//                                                         : VColors.GREY,
//                                                 e.value.type == "Walkaround"
//                                                     ? CupertinoIcons.car
//                                                     : CupertinoIcons.wrench,
//                                               ),
//                                               AppSpacer(widthPortion: .03),
//                                               Text(
//                                                 e.value.type,
//                                                 style: VStyle.style(
//                                                   context: context,
//                                                   fontWeight: FontWeight.bold,
//                                                   size: 15,
//                                                   color:
//                                                       isSelected
//                                                           ? VColors.SECONDARY
//                                                           : VColors.GREY,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                     ],
//                                   ),
//                         ),
//                       );
//                     },
//                   );
//                 }).toList(),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v_car_video_controller/v_carvideo_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_detail_model.dart';
import 'package:wheels_kart/module/Dealer/features/widgets/v_custom_backbutton.dart';

class CarVideoScreen extends StatelessWidget {
  final List<CarVideos> carVideos;
  const CarVideoScreen({super.key, required this.carVideos});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VCarvideoControllerCubit, VCarvideoControllerState>(
      builder: (context, state) {
        final cubit = context.read<VCarvideoControllerCubit>();
        final controller = cubit.controller;

        return SafeArea(
          top: false,
          bottom: Platform.isAndroid,
          child: Scaffold(
            // appBar: AppBar(
            //   title: const Text("Car Videos"),
            //   actions: [
            //     IconButton(
            //       icon: const Icon(Icons.close),
            //       onPressed: () => cubit.stopAndClose(context),
            //     ),
            //   ],
            // ),
            body: Column(
              children: [
                Container(
                  height: 120,
                  width: w(context),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: VColors.BLACK.withAlpha(40),
                        blurRadius: 12,
                        offset: Offset(2, 2),
                      ),
                    ],
                    color: VColors.WHITE,
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        VCustomBackbutton(
                          blendColor: VColors.GREY,
                          onTap: () {
                            cubit.stopAndClose(context);
                          },
                        ),
                        AppSpacer(widthPortion: .03),
                        Text(
                          "Car Videos",
                          style: VStyle.style(
                            size: 15,
                            context: context,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child:
                        (controller != null && controller.value.isInitialized)
                            ? AspectRatio(
                              aspectRatio: controller.value.aspectRatio,
                              child: VideoPlayer(controller),
                            )
                            : const VLoadingIndicator(),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              alignment: Alignment.center,
              height: 120,
              width: w(context),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: VColors.BLACK.withAlpha(40),
                    blurRadius: 12,
                    offset: Offset(2, 2),
                  ),
                ],
                color: VColors.WHITE,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              // height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: carVideos.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final video = carVideos[index];
                  final isSelected =
                      state is VCarVideoControllerVideoSuccessState &&
                      state.currentIndex == index;
                  final isPlaying =
                      state is VCarVideoControllerVideoSuccessState &&
                      state.isPlaying &&
                      state.currentIndex == index;

                  return GestureDetector(
                    onTap: () async {
                      if (isSelected) {
                        await cubit.togglePlayPause();
                      } else {
                        await cubit.initializePlayer(video, index);
                        await cubit.play();
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      width: isSelected ? 160 : 120,
                      height: isSelected ? 80 : 80,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.teal : Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 4),
                            ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              video.type,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 8),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder:
                                  (child, anim) => ScaleTransition(
                                    scale: anim,
                                    child: child,
                                  ),
                              child: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                key: ValueKey(isPlaying),
                                size: 28,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
