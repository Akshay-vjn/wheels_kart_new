import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v_car_video_controller/v_carvideo_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_detail_model.dart';
import 'package:wheels_kart/module/Dealer/features/widgets/v_custom_backbutton.dart';

class CarVideoScreen extends StatefulWidget {
  final List<CarVideos> carVideos;
  const CarVideoScreen({super.key, required this.carVideos});

  @override
  State<CarVideoScreen> createState() => _CarVideoScreenState();
}

class _CarVideoScreenState extends State<CarVideoScreen> {
  bool isPlaying = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: VColors.WHITE,
      //   leading: VCustomBackbutton(
      //     onTap: () {
      //       context.read<VCarvideoControllerCubit>().stopVideoPlayer(
      //         0,
      //         context,
      //       );
      //     },
      //   ),
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
                      context.read<VCarvideoControllerCubit>().stopVideoPlayer(
                        0,
                        context,
                      );
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
              child: BlocBuilder<
                VCarvideoControllerCubit,
                VCarvideoControllerState
              >(
                builder: (context, state) {
                  switch (state) {
                    case VCarVideoControllerVideoErrorState():
                      {
                        return AppEmptyText(text: state.error);
                      }
                    case VCarVideoControllerVideoLoadingState():
                      {
                        return VLoadingIndicator();
                      }
                    case VCarVideoControllerVideoSuccessState():
                      {
                        return SingleChildScrollView(
                          child: AspectRatio(
                            aspectRatio:
                                context
                                    .read<VCarvideoControllerCubit>()
                                    .controller
                                    .value
                                    .aspectRatio,
                            child: VideoPlayer(
                              context
                                  .read<VCarvideoControllerCubit>()
                                  .controller,
                            ),
                          ),
                        );
                      }
                    default:
                      {
                        return AppEmptyText(text: "Play Video");
                      }
                  }
                },
              ),
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
        child: Padding(
          padding: EdgeInsetsGeometry.only(bottom: 20, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
                widget.carVideos
                    .asMap()
                    .entries
                    .map(
                      (e) => BlocBuilder<
                        VCarvideoControllerCubit,
                        VCarvideoControllerState
                      >(
                        builder: (context, state) {
                          bool isSelected =
                              state is VCarVideoControllerVideoSuccessState &&
                              state.currentIndex == e.key;
                          bool playing =
                              state is VCarVideoControllerVideoSuccessState &&
                              state.isPlaying;
                          bool isLoading =
                              state is VCarVideoControllerVideoLoadingState;
                          return InkWell(
                            onTap: () {
                              context
                                  .read<VCarvideoControllerCubit>()
                                  .onSelectVideo(e.value, e.key);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 20),
                              alignment: Alignment.center,
                              width: w(context) * .43,

                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color:
                                    isSelected
                                        ? VColors.GREENHARD.withAlpha(100)
                                        : null,
                                border:
                                    isSelected
                                        ? null
                                        : Border.all(
                                          width: 0,
                                          color: VColors.GREY,
                                        ),
                              ),
                              child:
                                  isLoading
                                      ? VLoadingIndicator()
                                      : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          isSelected
                                              ? Icon(
                                                size: 35,
                                                color:
                                                    isSelected
                                                        ? VColors.WHITE
                                                        : VColors.GREY,
                                                isSelected && playing
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                              )
                                              : Row(
                                                children: [
                                                  Icon(
                                                    color:
                                                        isSelected
                                                            ? VColors.SECONDARY
                                                            : VColors.GREY,
                                                    e.value.type == "Walkaround"
                                                        ? CupertinoIcons.car
                                                        : CupertinoIcons.wrench,
                                                  ),
                                                  AppSpacer(widthPortion: .03),
                                                  Text(
                                                    e.value.type,
                                                    style: VStyle.style(
                                                      context: context,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      size: 15,
                                                      color:
                                                          isSelected
                                                              ? VColors
                                                                  .SECONDARY
                                                              : VColors.GREY,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        ],
                                      ),
                            ),
                          );
                        },
                      ),
                    )
                    .toList(),
          ),
        ),
      ),
    );
  }
}
