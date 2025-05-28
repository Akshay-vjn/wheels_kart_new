import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/core/components/app_custom_widgets.dart';
import 'package:wheels_kart/core/components/app_empty_text.dart';
import 'package:wheels_kart/core/components/app_loading_indicator.dart';
import 'package:wheels_kart/core/components/app_margin.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20picture%20angles/fetch_picture_angles_cubit.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch_vehilce_photo/fetch_uploaded_vehilce_photos_cubit.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/upload%20vehilce%20photo/uplaod_vehilce_photo_cubit.dart';

class UploadVehiclePhotos extends StatefulWidget {
  final String inspectionId;
  const UploadVehiclePhotos({super.key, required this.inspectionId});

  @override
  State<UploadVehiclePhotos> createState() => _UploadVehiclePhotosState();
}

class _UploadVehiclePhotosState extends State<UploadVehiclePhotos> {
  @override
  void initState() {
    context.read<UplaodVehilcePhotoCubit>().onClearAll();
    context.read<FetchPictureAnglesCubit>().onFetchPictureAngles(context);
    context.read<FetchUploadedVehilcePhotosCubit>().onFetchUploadVehiclePhotos(
      context,
      widget.inspectionId,
    );
    super.initState();
  }

  final descriptionController = TextEditingController();
  final _fromKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: customBackButton(context),
        centerTitle: false,
        title: Text(
          "Upload Car Photos",
          style: AppStyle.style(
            context: context,
            color: AppColors.white,
            size: AppDimensions.fontSize18(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: AppMargin(
        child: BlocBuilder<FetchPictureAnglesCubit, FetchPictureAnglesState>(
          builder: (context, angleState) {
            switch (angleState) {
              case FetchPictureAnglesLoadingState():
                {
                  return AppLoadingIndicator();
                }
              case FetchPictureAnglesSuccessState():
                {
                  return BlocBuilder<
                    FetchUploadedVehilcePhotosCubit,
                    FetchUploadedVehilcePhotosState
                  >(
                    builder: (context, fetchUploadsState) {
                      if (fetchUploadsState
                          is FetchUploadedVehilcePhotosErrorState) {
                        return AppEmptyText(
                          text: fetchUploadsState.errorMessage,
                        );
                      } else if (fetchUploadsState
                          is FetchUploadedVehilcePhotosLoadingState) {
                        return AppLoadingIndicator();
                      } else if (fetchUploadsState
                          is FetchUploadedVehilcePhotosSuccessSate) {
                        return BlocBuilder<
                          UplaodVehilcePhotoCubit,
                          UplaodVehilcePhotoState
                        >(
                          builder: (context, uploadState) {
                            return Form(
                              key: _fromKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppSpacer(heightPortion: .01),
                                  Wrap(
                                    alignment: WrapAlignment.start,
                                    runSpacing: 15,
                                    spacing: 20,
                                    children:
                                        angleState.pictureAngles
                                            .asMap()
                                            .entries
                                            .map(
                                              (e) => Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      context
                                                          .read<
                                                            UplaodVehilcePhotoCubit
                                                          >()
                                                          .onSelectAngle(
                                                            e.value.angleId,
                                                          );
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.all(
                                                        10,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            fetchUploadsState
                                                                    .vehiclePhtotos
                                                                    .any(
                                                                      (
                                                                        element,
                                                                      ) =>
                                                                          element
                                                                              .angleId ==
                                                                          e.value.angleId,
                                                                    )
                                                                ? AppColors
                                                                    .kWarningColor
                                                                : uploadState
                                                                            .selectedAngleId !=
                                                                        null &&
                                                                    uploadState
                                                                            .selectedAngleId ==
                                                                        e
                                                                            .value
                                                                            .angleId
                                                                ? AppColors
                                                                    .DEFAULT_ORANGE
                                                                : AppColors
                                                                    .DEFAULT_BLUE_DARK,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              AppDimensions
                                                                  .radiusSize50,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        e.value.angleName,
                                                        style: AppStyle.poppins(
                                                          context: context,
                                                          color:
                                                              AppColors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  Positioned(
                                                    right: -5,
                                                    top: -5,
                                                    child:
                                                        fetchUploadsState
                                                                .vehiclePhtotos
                                                                .any(
                                                                  (element) =>
                                                                      element
                                                                          .angleId ==
                                                                      e
                                                                          .value
                                                                          .angleId,
                                                                )
                                                            ? InkWell(
                                                              onTap: () {
                                                                context
                                                                    .read<
                                                                      FetchUploadedVehilcePhotosCubit
                                                                    >()
                                                                    .deleteImage(
                                                                      context,
                                                                      widget
                                                                          .inspectionId,
                                                                      fetchUploadsState
                                                                          .vehiclePhtotos
                                                                          .where(
                                                                            (
                                                                              element,
                                                                            ) =>
                                                                                element.angleId ==
                                                                                e.value.angleId,
                                                                          )
                                                                          .toList()
                                                                          .first
                                                                          .pictureId,
                                                                    );
                                                              },
                                                              child: Icon(
                                                                CupertinoIcons
                                                                    .clear_circled,
                                                                color:
                                                                    AppColors
                                                                        .kRed,
                                                                size: 18,
                                                              ),
                                                            )
                                                            : SizedBox(),
                                                  ),
                                                ],
                                              ),
                                            )
                                            .toList(),
                                  ),
                                  AppSpacer(heightPortion: .05),
                                  Container(
                                    alignment: Alignment.center,
                                    width: w(context),
                                    height: h(context) * .25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: AppColors.BORDER_COLOR,
                                      ),
                                    ),
                                    child:
                                        uploadState.selectedAngleId == null
                                            ? Text(
                                              "Select the angle",
                                              style: AppStyle.style(
                                                context: context,
                                                color: AppColors.BORDER_COLOR,
                                              ),
                                            )
                                            : uploadState.selectedImageFile !=
                                                null
                                            ? Image.file(
                                              uploadState.selectedImageFile!,
                                            )
                                            : CachedNetworkImage(
                                              imageUrl:
                                                  fetchUploadsState
                                                          .vehiclePhtotos
                                                          .any(
                                                            (element) =>
                                                                element
                                                                    .angleId ==
                                                                uploadState
                                                                    .selectedAngleId,
                                                          )
                                                      ? fetchUploadsState
                                                          .vehiclePhtotos
                                                          .where(
                                                            (element) =>
                                                                element
                                                                    .angleId ==
                                                                uploadState
                                                                    .selectedAngleId,
                                                          )
                                                          .toList()
                                                          .first
                                                          .picture
                                                      : angleState.pictureAngles
                                                          .where(
                                                            (element) =>
                                                                element
                                                                    .angleId ==
                                                                uploadState
                                                                    .selectedAngleId,
                                                          )
                                                          .toList()
                                                          .first
                                                          .samplePicture,
                                            ),
                                  ),
                                  AppSpacer(heightPortion: .02),
                                  fetchUploadsState.vehiclePhtotos.any(
                                        (element) =>
                                            element.angleId ==
                                            uploadState.selectedAngleId,
                                      )
                                      ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Description",
                                            style: AppStyle.style(
                                              context: context,
                                              fontWeight: FontWeight.bold,
                                              size: AppDimensions.fontSize15(
                                                context,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            fetchUploadsState.vehiclePhtotos
                                                .where(
                                                  (element) =>
                                                      element.angleId ==
                                                      uploadState
                                                          .selectedAngleId,
                                                )
                                                .toList()
                                                .first
                                                .description,
                                            style: AppStyle.style(
                                              context: context,
                                              fontWeight: FontWeight.w300,
                                              size: AppDimensions.fontSize12(
                                                context,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                      : Center(
                                        child: Text(
                                          "Sample Photo",
                                          style: AppStyle.style(
                                            context: context,
                                            color: AppColors.BORDER_COLOR,
                                          ),
                                        ),
                                      ),
                                  AppSpacer(heightPortion: .02),

                                  //--------C O M M E N T-----
                                  uploadState.selectedImageFile != null
                                      ? TextFormField(
                                        decoration: InputDecoration(
                                          hintText: "Description",
                                          hintStyle: AppStyle.style(
                                            context: context,
                                            color: AppColors.BORDER_COLOR,
                                            size: AppDimensions.fontSize16(
                                              context,
                                            ),
                                          ),
                                        ),
                                        controller: descriptionController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Description is required";
                                          } else {
                                            return null;
                                          }
                                        },
                                      )
                                      : SizedBox(),

                                  //----------
                                  AppSpacer(heightPortion: .02),
                                  uploadState.selectedAngleId == null
                                      ? SizedBox()
                                      : Center(
                                        child: ElevatedButton.icon(
                                          onPressed: () async {
                                            if (uploadState.selectedImageFile ==
                                                null) {
                                              context
                                                  .read<
                                                    UplaodVehilcePhotoCubit
                                                  >()
                                                  .onSelectImage();
                                            } else {
                                              if (_fromKey.currentState!
                                                  .validate()) {
                                                final convertedImage =
                                                    await convertFile(
                                                      uploadState
                                                          .selectedImageFile,
                                                    );
                                                Map<String, dynamic> json = {
                                                  "pictureType": "FINAL",
                                                  "pictureName":
                                                      '${angleState.pictureAngles.where((element) => element.angleId == uploadState.selectedAngleId).toList().first.angleName}-${widget.inspectionId}.jpg',
                                                  'angleId':
                                                      uploadState
                                                          .selectedAngleId,
                                                  'description':
                                                      descriptionController.text
                                                          .trim(),
                                                  'picture': convertedImage,
                                                };
                                                await context
                                                    .read<
                                                      UplaodVehilcePhotoCubit
                                                    >()
                                                    .onUploadVehilcePhoto(
                                                      context,
                                                      widget.inspectionId,
                                                      json,
                                                    );

                                                descriptionController.clear();
                                              }
                                            }
                                          },
                                          icon: Icon(
                                            uploadState.selectedImageFile ==
                                                    null
                                                ? CupertinoIcons.camera
                                                : CupertinoIcons
                                                    .cloud_upload_fill,
                                          ),
                                          label: Text(
                                            uploadState.selectedImageFile ==
                                                    null
                                                ? "Take Picture"
                                                : 'Upload Photo',
                                          ),
                                        ),
                                      ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  );
                }
              case FetchPictureAnglesErrorState():
                {
                  return AppEmptyText(text: angleState.error);
                }
              default:
                {
                  return AppLoadingIndicator();
                }
            }
          },
        ),
      ),
    );
  }

  Future<String> convertFile(File? file) async {
    if (file == null) return '';

    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }
}
