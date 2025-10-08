import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch%20picture%20angles/fetch_picture_angles_cubit.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch_vehilce_photo/fetch_uploaded_vehilce_photos_cubit.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/upload%20vehilce%20photo/uplaod_vehilce_photo_cubit.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/vehicle_photo_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_loading_indicator.dart';

class UploadVehiclePhotos extends StatefulWidget {
  final String inspectionId;
  // final UplaodVehilcePhotoCubit uploadCubit;
  // final FetchPictureAnglesCubit anglesCubit;
  // final FetchUploadedVehilcePhotosCubit uploadedCubit;

  const UploadVehiclePhotos({
    super.key,
    required this.inspectionId,
    // required this.uploadCubit,
    // required this.anglesCubit,
    // required this.uploadedCubit,
  });

  @override
  State<UploadVehiclePhotos> createState() => _UploadVehiclePhotosState();
}

class _UploadVehiclePhotosState extends State<UploadVehiclePhotos>
    with TickerProviderStateMixin {
  late AnimationController _slideAnimController;
  late PageController _leftController;
  late PageController _rightController;

  StreamSubscription? _anglesSub;
  StreamSubscription? _uploadCubitSub;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    // ... your existing orientation & UI setup ...

    final initialPage =
        (context.read<UplaodVehilcePhotoCubit>().state.currentPageIndex ?? 0);

    _slideAnimController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _leftController = PageController(initialPage: initialPage);
    _rightController = PageController(initialPage: initialPage);

    final uploadCubit = context.read<UplaodVehilcePhotoCubit>();
    final anglesCubit = context.read<FetchPictureAnglesCubit>();
    final uploadedCubit = context.read<FetchUploadedVehilcePhotosCubit>();

    uploadCubit.onClearAll();
    anglesCubit.onFetchPictureAngles(context);
    uploadedCubit.onFetchUploadVehiclePhotos(context, widget.inspectionId);

    _anglesSub = anglesCubit.stream.listen((state) {
      if (state is FetchPictureAnglesSuccessState) {
        if (state.flattenedAngles!.isNotEmpty) {
          uploadCubit.onSelectAngle(
            state.flattenedAngles!.first.angleId,
            state.flattenedAngles!.first.angleName,
            0,
          );
        }
      }
    });
  }

  void _animateBothTo(int index) {
    _leftController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
    _rightController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _goToNextAngle() {
    final uploadCubit = context.read<UplaodVehilcePhotoCubit>();
    final anglesCubit = context.read<FetchPictureAnglesCubit>();
    final current = uploadCubit.state.currentPageIndex ?? 0;
    final maxIndex = anglesCubit.state.flattenedAngles!.length - 1;
    if (current < maxIndex) _animateBothTo(current + 1);
  }

  void _goToPreviousAngle() {
    final current =
        context.read<UplaodVehilcePhotoCubit>().state.currentPageIndex ?? 0;
    if (current > 0) _animateBothTo(current - 1);
  }

  // void _jumpToAngle(int index) {
  //   final anglesLen =
  //       context.read<FetchPictureAnglesCubit>().state.flattenedAngles!.length;
  //   if (index >= 0 && index < anglesLen) {
  //     _leftController.jumpToPage(index);
  //     _rightController.jumpToPage(index);
  //   }
  // }

  @override
  void dispose() {
    _anglesSub?.cancel();
    _uploadCubitSub?.cancel();
    _slideAnimController.dispose();
    _leftController.dispose();
    _rightController.dispose();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("Screeen restated");
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: BlocBuilder<FetchPictureAnglesCubit, FetchPictureAnglesState>(
        builder: (context, angleState) {
          if (angleState is FetchPictureAnglesLoadingState) {
            return _buildLoadingState();
          }
          if (angleState is FetchPictureAnglesErrorState) {
            return _buildErrorState(angleState.error);
          }
          if (angleState is FetchPictureAnglesSuccessState) {
            // if (angleState.flattenedAngles!.isEmpty)
            //   _buildFlattenedAngles(angleState);
            return _buildMainContent(angleState);
          }
          return _buildLoadingState();
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
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
        "Upload Vehicle Photos",
        style: EvAppStyle.style(
          context: context,
          color: Colors.black87,
          size: AppDimensions.fontSize18(context),
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        BlocBuilder<FetchPictureAnglesCubit, FetchPictureAnglesState>(
          builder: (context, angleState) {
            if (angleState is FetchPictureAnglesSuccessState) {
              return _buildProgressBar(angleState);
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EVAppLoadingIndicator(),
          const SizedBox(height: 12),
          Text(
            "Loading photo angles...",
            style: EvAppStyle.poppins(
              context: context,
              size: AppDimensions.fontSize13(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Text(
        error,
        style: EvAppStyle.style(
          context: context,
          color: Colors.red,
          size: AppDimensions.fontSize15(context),
        ),
      ),
    );
  }

  Widget _buildMainContent(FetchPictureAnglesSuccessState angleState) {
    return BlocBuilder<UplaodVehilcePhotoCubit, UplaodVehilcePhotoState>(
      builder: (context, state) {
        return Column(
          children: [
            _buildUploadQueueIndicator(),
            Expanded(
              child: Row(
                children: [
                  // Left - Sample Preview
                  Expanded(
                    flex: 5,
                    child: _buildSwipeableContent(angleState, isLeftSide: true),
                  ),
                  Expanded(
                    flex: 5,
                    child: _buildSwipeableContent(
                      angleState,
                      isLeftSide: false,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUploadQueueIndicator() {
    return BlocBuilder<UplaodVehilcePhotoCubit, UplaodVehilcePhotoState>(
      builder: (context, uploadState) {
        final uploadCubit = context.read<UplaodVehilcePhotoCubit>();
        final items = uploadCubit.uploadItems;

        final queued =
            items.values.where((i) => i.status == UploadStatus.queued).length;
        final uploading =
            items.values
                .where((i) => i.status == UploadStatus.uploading)
                .length;
        final errors =
            items.values.where((i) => i.status == UploadStatus.error).length;

        if (queued == 0 && uploading == 0 && errors == 0) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              if (uploading > 0) ...[
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(
                      EvAppColors.DEFAULT_ORANGE,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Uploading $uploading photo${uploading > 1 ? 's' : ''}...",
                  style: EvAppStyle.poppins(
                    context: context,
                    size: AppDimensions.fontSize13(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              if (queued > 0 && uploading == 0) ...[
                Icon(Icons.schedule, color: Colors.orange, size: 20),
                const SizedBox(width: 12),
                Text(
                  "$queued photo${queued > 1 ? 's' : ''} in queue",
                  style: EvAppStyle.poppins(
                    context: context,
                    size: AppDimensions.fontSize13(context),
                  ),
                ),
              ],
              const Spacer(),
              if (errors > 0)
                GestureDetector(
                  onTap: () => _showErrorDialog(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          "$errors failed",
                          style: EvAppStyle.poppins(
                            context: context,
                            color: Colors.red,
                            size: AppDimensions.fontSize12(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressBar(FetchPictureAnglesSuccessState angleState) {
    final uploadedState =
        context.watch<FetchUploadedVehilcePhotosCubit>().state;
    List<VehiclePhotoModel> uploaded = [];
    if (uploadedState is FetchUploadedVehilcePhotosSuccessSate) {
      uploaded = uploadedState.vehiclePhtotos;
    }

    final totalAngles = angleState.flattenedAngles!.length;
    final completedCount = uploaded.length;
    final progress = totalAngles > 0 ? completedCount / totalAngles : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(
                  progress >= 1.0
                      ? Colors.green
                      : EvAppColors.DEFAULT_BLUE_DARK,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            "$completedCount / $totalAngles",
            style: EvAppStyle.style(
              context: context,
              color: Colors.black87,
              size: AppDimensions.fontSize15(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeableContent(
    FetchPictureAnglesSuccessState angleState, {
    required bool isLeftSide,
  }) {
    if (angleState.flattenedAngles!.isEmpty) return const SizedBox.shrink();

    final uploadedState =
        context.watch<FetchUploadedVehilcePhotosCubit>().state;
    List<VehiclePhotoModel> uploaded = [];
    if (uploadedState is FetchUploadedVehilcePhotosSuccessSate) {
      uploaded = uploadedState.vehiclePhtotos;
    }

    return PageView.builder(
      controller: isLeftSide ? _leftController : _rightController,
      physics:
          const NeverScrollableScrollPhysics(), // you drive it programmatically
      itemCount: angleState.flattenedAngles!.length,
      onPageChanged:
          isLeftSide
              ? (index) {
                // Update business state exactly once
                context.read<UplaodVehilcePhotoCubit>().onSelectAngle(
                  angleState.flattenedAngles![index].angleId,
                  angleState.flattenedAngles![index].angleName,
                  index,
                );
                // Mirror to the right without triggering another onPageChanged
                if (_rightController.hasClients &&
                    _rightController.page?.round() != index) {
                  _rightController.jumpToPage(index);
                }
              }
              : null, // avoid double-calls / loops
      itemBuilder: (context, index) {
        final angle = angleState.flattenedAngles![index];
        return isLeftSide
            ? _buildSamplePreviewCard(angle)
            : _buildAngleCard(angle, uploaded);
      },
    );
  }

  Widget _buildSamplePreviewCard(AngleItem angle) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: EvAppColors.DEFAULT_ORANGE.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    angle.category,
                    style: EvAppStyle.poppins(
                      context: context,
                      color: EvAppColors.DEFAULT_ORANGE,
                      size: AppDimensions.fontSize12(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  angle.angleName,
                  style: EvAppStyle.style(
                    context: context,
                    color: Colors.black87,
                    size: AppDimensions.fontSize18(context),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: _buildSampleImage(angle),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAngleCard(AngleItem angle, List<VehiclePhotoModel> uploaded) {
    return BlocBuilder<UplaodVehilcePhotoCubit, UplaodVehilcePhotoState>(
      builder: (context, uploadState) {
        final uploadCubit = context.read<UplaodVehilcePhotoCubit>();
        final uiItem = uploadCubit.uploadItems[angle.angleId];
        VehiclePhotoModel? serverPhoto = uploaded.firstWhere(
          (p) => p.angleId == angle.angleId,
          orElse:
              () => VehiclePhotoModel(
                angleId: "",
                createdAt: null,
                description: "",
                inspectionId: "",
                modifiedAt: null,
                picture: '',
                pictureId: "",
                pictureName: "",
                pictureType: "",
                status: "s",
              ),
        );

        final bool hasServerPhoto =
            serverPhoto != null && (serverPhoto.picture?.isNotEmpty ?? false);
        final bool hasLocalPhoto = uiItem?.file != null;
        final isUploading = uiItem?.status == UploadStatus.uploading;
        final isError = uiItem?.status == UploadStatus.error;

        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildImageContent(
                        angle,
                        hasServerPhoto,
                        serverPhoto,
                        hasLocalPhoto,
                        uiItem,
                      ),
                      if (hasServerPhoto || isUploading)
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isUploading ? Colors.orange : Colors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isUploading
                                      ? Icons.cloud_upload
                                      : Icons.cloud_done,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  isUploading ? "Uploading..." : "Uploaded",
                                  style: EvAppStyle.poppins(
                                    context: context,
                                    color: Colors.white,
                                    size: AppDimensions.fontSize12(context),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (isError)
                        Positioned(
                          top: 16,
                          right: 16,
                          child: GestureDetector(
                            onTap: () {
                              uploadCubit.retryUpload(
                                context,
                                widget.inspectionId,
                                angle.angleId,
                                (context
                                        .read<UplaodVehilcePhotoCubit>()
                                        .state
                                        .currentPageIndex ??
                                    0),
                                angle.angleName,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Tap to retry",
                                    style: EvAppStyle.poppins(
                                      context: context,
                                      color: Colors.white,
                                      size: AppDimensions.fontSize12(context),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // if (hasServerPhoto)
                    //   _buildDeleteButton(angle, serverPhoto)
                    // else
                    _buildUploadButton(angle, isUploading),
                    const SizedBox(height: 16),
                    _buildNavigationButtons(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageContent(
    AngleItem angle,
    bool hasServerPhoto,
    VehiclePhotoModel serverPhoto,
    bool hasLocalPhoto,
    UploadItem? uiItem,
  ) {
    if (hasLocalPhoto && uiItem?.file != null) {
      return Image.file(uiItem!.file!, fit: BoxFit.contain);
    } else if (hasServerPhoto) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CachedNetworkImage(
            cacheKey:
                serverPhoto.createdAt != null
                    ? serverPhoto.createdAt!.date.toIso8601String()
                    : DateTime.now().toIso8601String(),
            imageUrl: serverPhoto.picture,
            fit: BoxFit.contain,
            placeholder:
                (c, u) => const Center(child: CircularProgressIndicator()),
            errorWidget: (c, u, e) => _buildPlaceholder(),
          ),

          _buildDeleteButton(angle, serverPhoto),
        ],
      );
    } else {
      return _buildPlaceholder();
    }
  }

  Widget _buildSampleImage(AngleItem angle) {
    if (angle.samplePicture.isNotEmpty) {
      return Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: angle.samplePicture,
            fit: BoxFit.contain,
            placeholder:
                (c, u) => const Center(child: CircularProgressIndicator()),
            errorWidget:
                (c, u, e) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 64),
                  ),
                ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.photo_camera_outlined,
                    size: 20,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Sample Reference",
                    style: EvAppStyle.poppins(
                      context: context,
                      color: Colors.white,
                      size: AppDimensions.fontSize13(context),
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
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              "No sample available",
              style: EvAppStyle.poppins(
                context: context,
                color: Colors.grey[600]!,
                size: AppDimensions.fontSize15(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              "No photo captured yet",
              style: EvAppStyle.poppins(
                context: context,
                color: Colors.grey[600]!,
                size: AppDimensions.fontSize15(context),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            // Text(
            //   "Tap 'Take Photo' below",
            //   style: EvAppStyle.poppins(
            //     context: context,
            //     color: Colors.grey[500]!,
            //     size: AppDimensions.fontSize13(context),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final angleState = context.watch<FetchPictureAnglesCubit>().state;
    if (angleState is! FetchPictureAnglesSuccessState) {
      return const SizedBox();
    }

    final currentIndex =
        context.watch<UplaodVehilcePhotoCubit>().state.currentPageIndex ?? 0;
    final hasPrevious = currentIndex > 0;
    final hasNext = currentIndex < angleState.flattenedAngles!.length - 1;

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: hasPrevious ? _goToPreviousAngle : null,
            icon: const Icon(Icons.arrow_back, size: 20),
            label: Text(
              "Previous",
              style: EvAppStyle.style(
                context: context,
                color: hasPrevious ? Colors.black87 : Colors.grey[400]!,
                size: AppDimensions.fontSize15(context),
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              disabledBackgroundColor: Colors.grey[200],
              disabledForegroundColor: Colors.grey[400],
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: hasPrevious ? Colors.grey[300]! : Colors.grey[200]!,
                ),
              ),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: hasNext ? _goToNextAngle : null,
            icon: const Icon(Icons.arrow_forward, size: 20),
            label: Text(
              "Next",
              style: EvAppStyle.style(
                context: context,
                color: Colors.white,
                size: AppDimensions.fontSize15(context),
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  hasNext ? EvAppColors.DEFAULT_BLUE_DARK : Colors.grey[300],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: hasNext ? 2 : 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadButton(AngleItem angle, bool isUploading) {
    return ElevatedButton.icon(
      onPressed:
          isUploading
              ? null
              : () async {
                await context.read<UplaodVehilcePhotoCubit>().onSelectImage(
                  context,
                  widget.inspectionId,
                  (context
                          .read<UplaodVehilcePhotoCubit>()
                          .state
                          .currentPageIndex ??
                      0),
                  angle.angleName,
                );
                // _goToNextAngle();
              },
      icon: Icon(
        isUploading ? Icons.hourglass_empty : Icons.camera_alt,
        color: EvAppColors.white,
      ),
      label: Text(
        isUploading ? "Uploading..." : "Take Photo",
        style: EvAppStyle.style(
          context: context,
          color: Colors.white,
          size: AppDimensions.fontSize16(context),
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isUploading ? Colors.grey : EvAppColors.DEFAULT_ORANGE,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildDeleteButton(AngleItem angle, VehiclePhotoModel serverPhoto) {
    return Positioned(
      left: 20,
      top: 13,
      child: ElevatedButton(
        onPressed: () => _showDeleteConfirmation(angle, serverPhoto),
        // label: Text(
        //   "Delete & Retake",
        //   style: EvAppStyle.style(
        //     context: context,
        //     color: Colors.white,
        //     size: AppDimensions.fontSize16(context),
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          // padding: const EdgeInsets.symmetric(vertical: ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Icon(Icons.delete_outline, color: EvAppColors.white),
      ),
    );
  }

  // Widget _buildBottomNavigation(FetchPictureAnglesSuccessState angleState) {
  //   final entries = angleState.pictureAnglesByCategory.entries.toList();
  //   final uploadedState =
  //       context.watch<FetchUploadedVehilcePhotosCubit>().state;
  //   List<VehiclePhotoModel> uploaded = [];
  //   if (uploadedState is FetchUploadedVehilcePhotosSuccessSate) {
  //     uploaded = uploadedState.vehiclePhtotos;
  //   }

  //   return SafeArea(
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black.withOpacity(0.05),
  //             blurRadius: 10,
  //             offset: const Offset(0, -2),
  //           ),
  //         ],
  //       ),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           // Category Tabs
  //           Container(
  //             height: 50,
  //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //             child: ListView.builder(
  //               scrollDirection: Axis.horizontal,
  //               itemCount: entries.length,
  //               itemBuilder: (context, idx) {
  //                 final category = entries[idx].key;
  //                 final angles = entries[idx].value;
  //                 final isSelected =
  //                     (context
  //                                 .read<UplaodVehilcePhotoCubit>()
  //                                 .state
  //                                 .currentPageIndex ??
  //                             0) <
  //                         angleState.flattenedAngles!.length &&
  //                     angleState
  //                             .flattenedAngles![(context
  //                                     .read<UplaodVehilcePhotoCubit>()
  //                                     .state
  //                                     .currentPageIndex ??
  //                                 0)]
  //                             .categoryIndex ==
  //                         idx;

  //                 return GestureDetector(
  //                   onTap: () {
  //                     final firstAngleIndex = angleState.flattenedAngles!
  //                         .indexWhere((a) => a.categoryIndex == idx);
  //                     if (firstAngleIndex >= 0) {
  //                       _jumpToAngle(firstAngleIndex);
  //                     }
  //                   },
  //                   child: Container(
  //                     margin: const EdgeInsets.only(right: 8),
  //                     padding: const EdgeInsets.symmetric(
  //                       horizontal: 16,
  //                       vertical: 8,
  //                     ),
  //                     decoration: BoxDecoration(
  //                       color:
  //                           isSelected
  //                               ? EvAppColors.DEFAULT_ORANGE
  //                               : Colors.grey[100],
  //                       borderRadius: BorderRadius.circular(20),
  //                     ),
  //                     child: Text(
  //                       category,
  //                       style: EvAppStyle.poppins(
  //                         context: context,
  //                         color: isSelected ? Colors.white : Colors.black87,
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),

  //           // Angle Selector
  //           if ((context
  //                       .read<UplaodVehilcePhotoCubit>()
  //                       .state
  //                       .currentPageIndex ??
  //                   0) <
  //               angleState.flattenedAngles!.length)
  //             Container(
  //               padding: const EdgeInsets.all(16),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.stretch,
  //                 children: [
  //                   Text(
  //                     "Skip to angle:",
  //                     style: EvAppStyle.poppins(
  //                       context: context,
  //                       color: Colors.grey[600]!,
  //                       size: AppDimensions.fontSize12(context),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 8),
  //                   Wrap(
  //                     spacing: 8,
  //                     runSpacing: 8,
  //                     children:
  //                         entries[angleState
  //                                 .flattenedAngles![(context
  //                                         .read<UplaodVehilcePhotoCubit>()
  //                                         .state
  //                                         .currentPageIndex ??
  //                                     0)]
  //                                 .categoryIndex]
  //                             .value
  //                             .map((angle) {
  //                               final angleIndex = angleState.flattenedAngles!
  //                                   .indexWhere(
  //                                     (a) => a.angleId == angle.angleId,
  //                                   );
  //                               final isUploaded = uploaded.any(
  //                                 (p) => p.angleId == angle.angleId,
  //                               );
  //                               final isCurrent =
  //                                   angleIndex ==
  //                                   (context
  //                                           .read<UplaodVehilcePhotoCubit>()
  //                                           .state
  //                                           .currentPageIndex ??
  //                                       0);

  //                               return GestureDetector(
  //                                 onTap: () => _jumpToAngle(angleIndex),
  //                                 child: Container(
  //                                   padding: const EdgeInsets.symmetric(
  //                                     horizontal: 12,
  //                                     vertical: 8,
  //                                   ),
  //                                   decoration: BoxDecoration(
  //                                     color:
  //                                         isCurrent
  //                                             ? EvAppColors.DEFAULT_BLUE_DARK
  //                                             : isUploaded
  //                                             ? Colors.green.withOpacity(0.1)
  //                                             : Colors.grey[100],
  //                                     borderRadius: BorderRadius.circular(12),
  //                                     border: Border.all(
  //                                       color:
  //                                           isCurrent
  //                                               ? EvAppColors.DEFAULT_BLUE_DARK
  //                                               : isUploaded
  //                                               ? Colors.green
  //                                               : Colors.grey[300]!,
  //                                     ),
  //                                   ),
  //                                   child: Row(
  //                                     mainAxisSize: MainAxisSize.min,
  //                                     children: [
  //                                       if (isUploaded) ...[
  //                                         Icon(
  //                                           Icons.check_circle,
  //                                           color: Colors.green,
  //                                           size: 14,
  //                                         ),
  //                                         const SizedBox(width: 4),
  //                                       ],
  //                                       Text(
  //                                         angle.angleName,
  //                                         style: EvAppStyle.poppins(
  //                                           context: context,
  //                                           color:
  //                                               isCurrent
  //                                                   ? Colors.white
  //                                                   : isUploaded
  //                                                   ? Colors.green[700]!
  //                                                   : Colors.black87,
  //                                           size: AppDimensions.fontSize12(
  //                                             context,
  //                                           ),
  //                                           fontWeight: FontWeight.w600,
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                               );
  //                             })
  //                             .toList(),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  void _showDeleteConfirmation(AngleItem angle, VehiclePhotoModel serverPhoto) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(
              "Delete Photo?",
              style: EvAppStyle.style(
                context: context,
                color: Colors.black87,
                size: AppDimensions.fontSize18(context),
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              "Are you sure you want to delete this photo and take a new one?",
              style: EvAppStyle.poppins(
                context: context,
                size: AppDimensions.fontSize15(context),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: EvAppStyle.poppins(
                    context: context,
                    color: Colors.grey[600]!,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);

                  context.read<FetchUploadedVehilcePhotosCubit>().deleteImage(
                    context,
                    widget.inspectionId,
                    serverPhoto.pictureId,
                  );
                  // For now, immediately open camera for retake
                  // await context.read<UplaodVehilcePhotoCubit>().onSelectImage(
                  //   context,
                  //   widget.inspectionId,
                  //   (context
                  //           .read<UplaodVehilcePhotoCubit>()
                  //           .state
                  //           .currentPageIndex ??
                  //       0),
                  //   angle.angleName,
                  // );
                  // _goToNextAngle();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(
                  "Delete & Retake",
                  style: EvAppStyle.poppins(
                    context: context,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _showErrorDialog() {
    final uploadCubit = context.read<UplaodVehilcePhotoCubit>();
    final errorItems =
        uploadCubit.uploadItems.values
            .where((i) => i.status == UploadStatus.error)
            .toList();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              "Upload Errors",
              style: EvAppStyle.style(
                context: context,
                color: Colors.black87,
                size: AppDimensions.fontSize18(context),
                fontWeight: FontWeight.w700,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: errorItems.length,
                itemBuilder: (context, index) {
                  final item = errorItems[index];
                  final angle = context
                      .read<FetchPictureAnglesCubit>()
                      .state
                      .flattenedAngles!
                      .firstWhere(
                        (a) => a.angleId == item.angleId,
                        orElse:
                            () => AngleItem(
                              angleId: item.angleId,
                              angleName: "Unknown",
                              samplePicture: "",
                              category: "",
                              categoryIndex: 0,
                            ),
                      );

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                      ),
                      title: Text(
                        angle.angleName,
                        style: EvAppStyle.poppins(
                          context: context,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        item.error ?? "Upload failed",
                        style: EvAppStyle.poppins(
                          context: context,
                          color: Colors.grey[600]!,
                          size: AppDimensions.fontSize12(context),
                        ),
                      ),
                      trailing: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          uploadCubit.retryUpload(
                            context,
                            widget.inspectionId,
                            item.angleId,
                            (context
                                    .read<UplaodVehilcePhotoCubit>()
                                    .state
                                    .currentPageIndex ??
                                0),
                            angle.angleName,
                          );
                        },
                        child: Text(
                          "Retry",
                          style: EvAppStyle.poppins(
                            context: context,
                            color: EvAppColors.DEFAULT_ORANGE,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Close",
                  style: EvAppStyle.poppins(context: context),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  for (var item in errorItems) {
                    uploadCubit.retryUpload(
                      context,
                      widget.inspectionId,
                      item.angleId,
                      (context
                              .read<UplaodVehilcePhotoCubit>()
                              .state
                              .currentPageIndex ??
                          0),
                      item.angleName,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: EvAppColors.DEFAULT_ORANGE,
                ),
                child: Text(
                  "Retry All",
                  style: EvAppStyle.poppins(
                    context: context,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}

// class AngleItem {
//   final String angleId;
//   final String angleName;
//   final String samplePicture;
//   final String category;
//   final int categoryIndex;

//   AngleItem({
//     required this.angleId,
//     required this.angleName,
//     required this.samplePicture,
//     required this.category,
//     required this.categoryIndex,
//   });
// }
