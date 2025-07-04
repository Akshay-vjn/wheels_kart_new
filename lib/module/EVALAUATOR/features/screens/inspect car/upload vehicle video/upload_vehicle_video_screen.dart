import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/upload%20vehicle%20video/upload_vehicle_video_cubit.dart';
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

    context.read<UploadVehicleVideoCubit>().onFetcUploadVideos();

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
                return _buildSuccessState();
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

  Widget _buildSuccessState() {
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
                  duration: "(max 1 min)",
                  icon: CupertinoIcons.car,
                  existingVideoFile: "",
                  hintText: "Full Walkaround Video.",
                  onTap: () {
                    context
                        .read<UploadVehicleVideoCubit>()
                        .onClickFullWalkaroundVideo(false, "1");
                  },
                  isUploading: false,
                ),
                AppSpacer(heightPortion: .02),
                _buildVideoButton(
                  duration: "(max 1 min)",
                  icon: CupertinoIcons.wrench,
                  existingVideoFile: null,
                  hintText: "Engine Side Video after starting vehicle.",
                  onTap: () {
                    context
                        .read<UploadVehicleVideoCubit>()
                        .onClickFullEngineVideo(false, "2");
                  },
                  isUploading: false,
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
    required String duration,
    required IconData icon,
    required String hintText,
    required void Function() onTap,
    required String? existingVideoFile,
    required bool isUploading,
  }) {
    return Column(
      children: [
        Container(
          width: w(context),
          height: h(context) * .3,
          decoration: BoxDecoration(
            border: Border.all(width: .5),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSize15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40),
              AppSpacer(heightPortion: .02),
              Text(
                hintText,
                style: EvAppStyle.poppins(context: context, size: 14),
              ),
              AppSpacer(heightPortion: .01),
              Text(
                duration,
                style: EvAppStyle.poppins(
                  context: context,
                  color: EvAppColors.black2,
                ),
              ),
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
                              ? "Capture Video"
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
            "Loading uploaed Files...",
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
}
