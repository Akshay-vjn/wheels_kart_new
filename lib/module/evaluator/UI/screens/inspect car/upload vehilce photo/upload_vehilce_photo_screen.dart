import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/core/components/app_loading_indicator.dart';
import 'package:wheels_kart/core/components/app_margin.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';
import 'package:wheels_kart/core/utils/validator.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_custom_textfield.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/upload%20vehilce%20photo/uplaod_vehilce_photo_cubit.dart';

class UploadVehilcePhotoScreen extends StatefulWidget {
  final String inspectionId;
  UploadVehilcePhotoScreen({super.key, required this.inspectionId});

  @override
  State<UploadVehilcePhotoScreen> createState() =>
      _UploadVehilcePhotoScreenState();
}

class _UploadVehilcePhotoScreenState extends State<UploadVehilcePhotoScreen> {
  List<Map<String, dynamic>> vehicleAngles = [
    {'title': "Bonnet", 'picture': 'assets/dynamic/bonnet.jpg'},
    {'title': "Front", 'picture': 'assets/dynamic/front.jpg'},
    {'title': "Tyre1", 'picture': 'assets/dynamic/tyre1.jpg'},
    {'title': "Tyre2", 'picture': 'assets/dynamic/tyre2.jpg'},
  ];

  Map<String, dynamic>? selectedAngle;
  File? selectedFile;
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UplaodVehilcePhotoCubit, UplaodVehilcePhotoState>(
        builder: (context, state) {
          return Stack(
            children: [
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: h(context) * .7,
                        child: AppMargin(
                          child: Column(
                            children: [
                              AppSpacer(heightPortion: .01),
                              DropdownButtonFormField(
                                hint: Text("Select the angle"),

                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(),
                                ),
                                value: selectedAngle,

                                items:
                                    vehicleAngles
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e['title']),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (value) {
                                  selectedAngle = value;
                                  setState(() {});
                                },
                              ),
                              AppSpacer(heightPortion: .01),
                              selectedAngle != null
                                  ? Column(
                                    children: [
                                      SizedBox(
                                        width: w(context),
                                        height: w(context),
                                        child:
                                            selectedFile != null
                                                ? Image.file(selectedFile!)
                                                : Image.asset(
                                                  selectedAngle!['picture'],
                                                  // fit: BoxFit.fill,
                                                ),
                                      ),
                                      Text(
                                        "(Sample photo)",
                                        style: AppStyle.style(
                                          context: context,
                                          color: AppColors.BORDER_COLOR,
                                        ),
                                      ),
                                      AppSpacer(heightPortion: .05),
                                      InkWell(
                                        onTap:
                                            state is UplaodVehilcePhotoLoadingState
                                                ? null
                                                : takePicture,
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 20,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 2),
                                            borderRadius: BorderRadius.circular(
                                              40,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(SolarIconsBold.cameraAdd),
                                              AppSpacer(widthPortion: .02),
                                              Text(
                                                "Take photo",
                                                style: AppStyle.style(
                                                  context: context,
                                                  size: 18,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        height: h(context) * .3,
                        padding: EdgeInsets.all(10),
                        width: w(context),
                        decoration: BoxDecoration(
                          color: AppColors.DEFAULT_BLUE_DARK,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.grey.withAlpha(100),
                              blurRadius: 1,
                              spreadRadius: 1,
                              offset: Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            AppSpacer(heightPortion: .01),
                            EvAppCustomTextfield(
                              controller: descriptionController,
                              validator: Validator.validateRequired,
                              lebelStyle: AppStyle.style(
                                context: context,
                                size: AppDimensions.fontSize15(context),
                                color: AppColors.white,
                              ),
                              labeltext: "Description",

                              fillColor: AppColors.FILL_COLOR,
                              hintText: "Describe about the part",
                            ),
                            AppSpacer(heightPortion: .01),
                            InkWell(
                              onTap:
                                  state is UplaodVehilcePhotoLoadingState
                                      ? null
                                      : saveData,
                              child: Container(
                                alignment: Alignment.center,
                                width: w(context) * .7,

                                padding: EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 15,
                                ),
                                decoration: BoxDecoration(
                                  boxShadow:
                                      selectedFile == null
                                          ? []
                                          : [
                                            BoxShadow(
                                              color: AppColors.white.withAlpha(
                                                50,
                                              ),
                                              blurRadius: 1,
                                              spreadRadius: 1,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                  borderRadius: BorderRadius.circular(70),

                                  color:
                                      selectedFile == null
                                          ? AppColors.BORDER_COLOR
                                          : AppColors.DEFAULT_ORANGE,
                                ),
                                child: Text(
                                  "Save",
                                  style: AppStyle.style(
                                    context: context,
                                    color:
                                        selectedFile == null
                                            ? const Color.fromARGB(
                                              255,
                                              216,
                                              215,
                                              215,
                                            )
                                            : AppColors.white,
                                    fontWeight: FontWeight.w800,
                                    size: AppDimensions.fontSize24(context),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              state is UplaodVehilcePhotoLoadingState
                  ? AppLoadingIndicator()
                  : SizedBox(),
            ],
          );
        },
      ),
    );
  }

  void takePicture() async {
    final controller = ImagePicker();
    final xFile = await controller.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (xFile == null) return;
    selectedFile = File(xFile.path);
    setState(() {});
  }

  void saveData() async {
    if (selectedAngle != null) {
      if (_formKey.currentState!.validate()) {
        final image = await convertFile();
        Map<String, dynamic> json = {
          "pictureType": "FINAL",
          "pictureName":
              '${selectedAngle!['title']}-${widget.inspectionId}.jpg',
          'description': descriptionController.text,
          'picture': image,
        };
        await context.read<UplaodVehilcePhotoCubit>().onUploadVehilcePhoto(
          context,
          widget.inspectionId,
          json,
        );
        selectedAngle = null;
        selectedFile = null;
        descriptionController.clear();
      }
    }
  }

  Future<String> convertFile() async {
    if (selectedFile == null) return '';

    final bytes = await selectedFile!.readAsBytes();
    return base64Encode(bytes);
  }
}
