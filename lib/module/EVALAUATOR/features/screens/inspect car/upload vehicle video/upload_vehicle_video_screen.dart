import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/upload%20vehicle%20video/upload_vehicle_video_cubit.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/video_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/upload%20vehicle%20video/video_player_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_custom_button.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_loading_indicator.dart';

class UploadVehicleVideoScreen extends StatefulWidget {
  final String inspectionId;
  const UploadVehicleVideoScreen({super.key, required this.inspectionId});

  @override
  State<UploadVehicleVideoScreen> createState() =>
      _UploadVehicleVideoScreenState();
}

class _UploadVehicleVideoScreenState extends State<UploadVehicleVideoScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    // Bloc initialization

    context.read<UploadVehicleVideoCubit>().onFetcUploadVideos(
      context,
      widget.inspectionId,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    // descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocBuilder<UploadVehicleVideoCubit, UploadVehicleVideoState>(
        builder: (context, state) {
          switch (state) {
            case UploadVehicleVideoErrorState():
              {
                return _buildErrorState(state.error);
              }
            case UploadVehicleVideoSuccessState():
              {
                return _buildSuccessState(state);
              }
            default:
              {
                return _buildLoadingState();
              }
          }
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      centerTitle: true,
      title: Text(
        "Vehicle Videos",
        style: EvAppStyle.style(
          context: context,
          color: Colors.black87,
          size: AppDimensions.fontSize18(context),
          fontWeight: FontWeight.w700,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.grey[300]!,
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessState(UploadVehicleVideoSuccessState state) {
    VideoModel? engineSideVideo;
    VideoModel? walkaroundVideo;
    if (state.isAvailableEngineVideo) {
      engineSideVideo = state.videos.firstWhere(
        (element) => element.videoType == UploadVehicleVideoCubit.ENGINESIDE,
      );
    }

    if (state.isAvailabeWalkaroundVideo) {
      walkaroundVideo = state.videos.firstWhere(
        (element) => element.videoType == UploadVehicleVideoCubit.WLAKAROUND,
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          child: AppMargin(
            child: Column(
              children: [
                AppSpacer(heightPortion: .02),
                _buildVideoButton(
                  buttonTitle: "Walkaround Video",
                  state: state,
                  videoId:
                      state.isAvailabeWalkaroundVideo
                          ? walkaroundVideo!.videoId
                          : "",
                  videoType: UploadVehicleVideoCubit.WLAKAROUND,
                  duration: "(max 1 min)",
                  icon: CupertinoIcons.car,
                  existingVideoFile:
                      state.isAvailabeWalkaroundVideo
                          ? walkaroundVideo!.video
                          : null,
                  hintText: "Full Walkaround Video.",
                  onTap: () {
                    showGallaryOrCameraSheet(
                      "Walkaroud",

                      state.isAvailabeWalkaroundVideo
                          ? walkaroundVideo!.videoId
                          : null,
                    );
                  },
                  isUploading: state.isWalkAroundUploading,
                ),
                AppSpacer(heightPortion: .02),
                _buildVideoButton(
                  buttonTitle: "Engine Side Video",
                  state: state,

                  videoId:
                      state.isAvailableEngineVideo
                          ? engineSideVideo!.videoId
                          : '',
                  videoType: UploadVehicleVideoCubit.ENGINESIDE,
                  duration: "(max 1 min)",
                  icon: CupertinoIcons.wrench,
                  existingVideoFile:
                      state.isAvailableEngineVideo
                          ? engineSideVideo!.video
                          : null,
                  hintText: "Engine Side Video after starting vehicle.",
                  onTap: () {
                    showGallaryOrCameraSheet(
                      "Engine Side",

                      state.isAvailableEngineVideo
                          ? engineSideVideo!.videoId
                          : null,
                    );
                  },
                  isUploading: state.isEngineUploading,
                ),
                AppSpacer(heightPortion: .02),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoButton({
    required UploadVehicleVideoSuccessState state,
    required String duration,
    required IconData icon,
    required String hintText,
    required void Function() onTap,
    required String? existingVideoFile,
    required bool isUploading,
    required String videoType,
    required String videoId,
    required String buttonTitle,
  }) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: w(context),
          height: h(context) * .3,
          decoration: BoxDecoration(
            border: Border.all(width: .5),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSize15),
          ),
          child: Stack(
            children: [
              existingVideoFile != null
                  ? _videoPlayButton(icon, hintText, existingVideoFile)
                  : _buildCardHead(duration, icon, hintText),
              existingVideoFile != null
                  ? Positioned(
                    right: 10,
                    top: 10,
                    child: Theme(
                      data: ThemeData(
                        colorScheme: ColorScheme(
                          brightness: Brightness.light,
                          primary: EvAppColors.kRed.withAlpha(150),
                          onPrimary: EvAppColors.DARK_SECONDARY,
                          secondary: EvAppColors.DARK_SECONDARY,
                          onSecondary: EvAppColors.DARK_SECONDARY,
                          error: EvAppColors.DARK_SECONDARY,
                          onError: EvAppColors.DARK_SECONDARY,
                          surface: EvAppColors.DARK_SECONDARY,
                          onSurface: EvAppColors.DARK_SECONDARY,
                        ),
                      ),
                      child: IconButton.filled(
                        color: EvAppColors.white,

                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: Text(
                                    "Delete Video ?",
                                    style: EvAppStyle.style(
                                      size: 16,
                                      fontWeight: FontWeight.w600,
                                      context: context,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: EvAppStyle.style(
                                          size: 13,
                                          context: context,
                                        ),
                                      ),
                                    ),
                                    state.isWalkAroundUploading ||
                                            state.isEngineUploading
                                        ? EVAppLoadingIndicator()
                                        : TextButton(
                                          onPressed: () async {
                                            await context
                                                .read<UploadVehicleVideoCubit>()
                                                .deleteVideo(
                                                  context,
                                                  videoType,
                                                  widget.inspectionId,
                                                  videoId,
                                                );
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Delete",
                                            style: EvAppStyle.style(
                                              size: 13,
                                              context: context,
                                              color: EvAppColors.kRed,
                                            ),
                                          ),
                                        ),
                                  ],
                                ),
                          );
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ),
                  )
                  : SizedBox.shrink(),
            ],
          ),
        ),
        AppSpacer(heightPortion: .01),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: isUploading ? null : () => onTap(),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  existingVideoFile == null
                      ? EvAppColors.DEFAULT_ORANGE.withAlpha(200)
                      : EvAppColors.kRed,

              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              disabledBackgroundColor: Colors.grey[300],
            ),
            child:
                isUploading
                    ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator.adaptive(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          existingVideoFile == null
                              ? CupertinoIcons.video_camera_solid
                              : CupertinoIcons.delete,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          existingVideoFile == null
                              ? buttonTitle
                              : "Delete & Update Video",
                          style: EvAppStyle.style(
                            context: context,
                            color: Colors.white,
                            size: AppDimensions.fontSize16(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red[200]!),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.red[400], size: 48),
            const SizedBox(height: 16),
            Text(
              "Something went wrong",
              style: EvAppStyle.style(
                context: context,
                color: Colors.red[700],
                size: AppDimensions.fontSize16(context),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: EvAppStyle.style(
                context: context,
                color: Colors.red[600],
                size: AppDimensions.fontSize15(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EVAppLoadingIndicator(),
          const SizedBox(height: 16),
          Text(
            "Loading uploaded Files...",
            style: EvAppStyle.style(
              context: context,
              color: Colors.grey[600],
              size: AppDimensions.fontSize15(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _videoPlayButton(IconData icon, String hintText, String file) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppSpacer(heightPortion: .04),
        IconButton(
          onPressed: () {
            Navigator.of(
              context,
            ).push(AppRoutes.createRoute(VideoPlayerScreen(file: file)));
          },
          icon: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(width: 2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.play_arrow),
          ),
        ),

        AppSpacer(heightPortion: .04),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: EvAppColors.grey),
            AppSpacer(widthPortion: .01),
            Text(
              hintText,
              style: EvAppStyle.poppins(
                context: context,
                size: 14,
                color: EvAppColors.grey,
              ),
            ),
          ],
        ),
        AppSpacer(heightPortion: .01),
      ],
    );
  }

  Widget _buildCardHead(String duration, IconData icon, String hintText) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 40),
        AppSpacer(heightPortion: .02),
        Text(hintText, style: EvAppStyle.poppins(context: context, size: 14)),
        AppSpacer(heightPortion: .01),
        Text(
          duration,
          style: EvAppStyle.poppins(
            context: context,
            color: EvAppColors.black2,
          ),
        ),
      ],
    );
  }

  void showGallaryOrCameraSheet(String type, String? videoId) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          Colors.transparent, // Optional: adds rounded corner effect
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: EvAppColors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Upload $type Video",
                  style: EvAppStyle.style(
                    context: context,
                    fontWeight: FontWeight.bold,
                    size: 18,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Gallery Option
                    _buildOptionCard(
                      context,
                      icon: Icons.collections,
                      label: "Gallery",
                      onTap: () {
                        if (type == "Engine Side") {
                          context
                              .read<UploadVehicleVideoCubit>()
                              .onClickFullEngineVideo(
                                videoId,
                                widget.inspectionId,
                                true,
                                context,
                              );
                        } else {
                          context
                              .read<UploadVehicleVideoCubit>()
                              .onClickFullWalkaroundVideo(
                                videoId,
                                widget.inspectionId,
                                true,
                                context,
                              );
                        }
                        // Your gallery logic here
                      },
                    ),
                    // Camera Option
                    _buildOptionCard(
                      context,
                      icon: Icons.camera_alt,
                      label: "Camera",
                      onTap: () {
                        if (type == "Engine Side") {
                          context
                              .read<UploadVehicleVideoCubit>()
                              .onClickFullEngineVideo(
                                videoId,
                                widget.inspectionId,
                                false,
                                context,
                              );
                        } else {
                          context
                              .read<UploadVehicleVideoCubit>()
                              .onClickFullWalkaroundVideo(
                                videoId,
                                widget.inspectionId,
                                false,
                                context,
                              );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Material(
        color: EvAppColors.white,
        borderRadius: BorderRadius.circular(20),
        elevation: 5,
        child: Container(
          width: w(context) * 0.4,
          height: h(context) * 0.17,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.black87),
              const SizedBox(height: 12),
              Text(
                label,
                style: EvAppStyle.style(
                  context: context,
                  fontWeight: FontWeight.bold,
                  size: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
