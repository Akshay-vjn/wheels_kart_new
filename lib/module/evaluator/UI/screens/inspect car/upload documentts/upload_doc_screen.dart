import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/core/components/app_custom_widgets.dart';
import 'package:wheels_kart/core/components/app_empty_text.dart';
import 'package:wheels_kart/core/components/app_loading_indicator.dart';
import 'package:wheels_kart/core/components/app_margin.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/paint/dash_border.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20document%20types/fetch_document_type_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/submit%20document/submit_document_cubit.dart';

class UploadDocScreen extends StatefulWidget {
  String inspectionId;
  UploadDocScreen({super.key, required this.inspectionId});

  @override
  State<UploadDocScreen> createState() => _UploadDocScreenState();
}

class _UploadDocScreenState extends State<UploadDocScreen> {
  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() {
    context.read<SubmitDocumentCubit>().init();
    context.read<FetchDocumentTypeBloc>().add(
      OnFetchDocumentTypeEvent(context: context),
    );
  }

  String? selectedDoumentId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FetchDocumentTypeBloc, FetchDocumentTypeState>(
        builder: (context, state) {
          switch (state) {
            case FetchDocumentTypeLoadingState():
              {
                return AppLoadingIndicator();
              }
            case FetchDocumentTypeSuccessState():
              {
                return BlocBuilder<SubmitDocumentCubit, SubmitDocumentState>(
                  builder: (context, submissionState) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: h(context) * .65,
                              width: w(context),
                              decoration: BoxDecoration(
                                color: AppColors.DEFAULT_BLUE_DARK,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [customBackButton(context)],
                                  ),

                                  Expanded(
                                    child: AppMargin(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          AppSpacer(heightPortion: .05),
                                          DropdownButtonFormField(
                                            decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: AppColors.white,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(0),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: AppColors.white,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(0),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: AppColors.white,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(0),
                                              ),
                                            ),
                                            hint: Text(
                                              "Select the document type",
                                              style: AppStyle.poppins(
                                                context: context,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.white,
                                              ),
                                            ),
                                            dropdownColor:
                                                AppColors.DEFAULT_BLUE_GREY,
                                            style: AppStyle.poppins(
                                              context: context,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.white,
                                            ),
                                            items:
                                                state.documentTypes
                                                    .map(
                                                      (e) => DropdownMenuItem(
                                                        value: e.documentTypeId,
                                                        child: Text(
                                                          e.documentTypeName,
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                            onChanged: (value) {
                                              selectedDoumentId = value;
                                              setState(() {});
                                            },
                                          ),
                                          AppSpacer(heightPortion: .08),
                                          CustomPaint(
                                            painter: DashedBorderPainter(
                                              color: AppColors.white,
                                            ),

                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              color: AppColors.kSelectionColor,
                                              width: w(context),
                                              height:
                                                  // _captureFile != null
                                                  //     ? null
                                                  //     :
                                                  h(context) * .25,
                                              child:
                                                  _captureFile != null
                                                      ? _buildPdfView()
                                                      : _memoryFile != null
                                                      ? Image.memory(
                                                        _memoryFile!,
                                                      )
                                                      : Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            size: 70,
                                                            CupertinoIcons
                                                                .arrow_up_doc_fill,
                                                            color:
                                                                AppColors.grey,
                                                          ),
                                                          AppSpacer(
                                                            heightPortion: .02,
                                                          ),
                                                          Text(
                                                            "Once you select the document, it will appear here.",
                                                            textAlign:
                                                                TextAlign
                                                                    .center,
                                                            style: AppStyle.poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              size:
                                                                  AppDimensions.fontSize15(
                                                                    context,
                                                                  ),
                                                              context: context,
                                                              color:
                                                                  AppColors
                                                                      .grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                            ),
                                          ),
                                          AppSpacer(heightPortion: .01),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.DARK_SECONDARY,
                                                disabledBackgroundColor:
                                                    AppColors.black2,
                                              ),
                                              onPressed:
                                                  _captureFile == null ||
                                                          _memoryFile != null ||
                                                          submissionState
                                                              is SubmitDocumentSuccessState
                                                      ? null
                                                      : () async {
                                                        String base64 = '';
                                                        String fileName = '';
                                                        if (_captureFile !=
                                                            null) {
                                                          final file = File(
                                                            _captureFile!,
                                                          );
                                                          final bytes =
                                                              await file
                                                                  .readAsBytes();
                                                          base64 = base64Encode(
                                                            bytes,
                                                          );
                                                          fileName =
                                                              "${DateTime.now().toIso8601String()}.pdf";
                                                        }
                                                        if (_memoryFile !=
                                                            null) {
                                                          base64 = base64Encode(
                                                            _memoryFile!,
                                                          );
                                                          fileName =
                                                              "${DateTime.now().toIso8601String()}.jpg";
                                                        }
                                                        final json = {
                                                          'documentId':
                                                              selectedDoumentId,
                                                          'fileName': fileName,
                                                          'file': base64,
                                                        };
                                                        log(json.toString());
                                                        await context
                                                            .read<
                                                              SubmitDocumentCubit
                                                            >()
                                                            .onSubmitDocument(
                                                              context,
                                                              widget
                                                                  .inspectionId,
                                                              json,
                                                            );
                                                        // Navigator.of(context)
                                                      },
                                              icon: Icon(
                                                SolarIconsOutline.upload,
                                                color:
                                                    _captureFile == null ||
                                                            _memoryFile !=
                                                                null ||
                                                            submissionState
                                                                is SubmitDocumentSuccessState
                                                        ? AppColors.grey
                                                        : AppColors.white,
                                              ),
                                              label: Text(
                                                "Save",
                                                style: AppStyle.style(
                                                  context: context,
                                                  color:
                                                      _captureFile == null ||
                                                              _memoryFile !=
                                                                  null ||
                                                              submissionState
                                                                  is SubmitDocumentSuccessState
                                                          ? AppColors.grey
                                                          : AppColors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: w(context),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                ),
                                child: AppMargin(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Divider(
                                              endIndent: 10,
                                              indent: 100,
                                              color: AppColors.BORDER_COLOR,
                                            ),
                                          ),
                                          Text(
                                            "or",
                                            style: AppStyle.style(
                                              context: context,
                                              color: AppColors.BORDER_COLOR,
                                            ),
                                          ),
                                          Flexible(
                                            child: Divider(
                                              indent: 10,
                                              endIndent: 100,
                                              color: AppColors.BORDER_COLOR,
                                            ),
                                          ),
                                        ],
                                      ),
                                      AppSpacer(heightPortion: .03),
                                      InkWell(
                                        onTap: () => _onSelectDocument(false),
                                        child: Container(
                                          margin:
                                              EdgeInsetsDirectional.symmetric(
                                                horizontal: 20,
                                              ),
                                          padding:
                                              EdgeInsetsDirectional.symmetric(
                                                horizontal: 10,
                                                vertical: 15,
                                              ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                SolarIconsOutline.gallery,
                                                color:
                                                    selectedDoumentId != null
                                                        ? AppColors
                                                            .DEFAULT_BLUE_GREY
                                                        : AppColors
                                                            .kSelectionColor,
                                                size: 50,
                                              ),
                                              AppSpacer(widthPortion: .02),
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Select the documents from Gallery",
                                                      style: AppStyle.style(
                                                        context: context,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            selectedDoumentId !=
                                                                    null
                                                                ? AppColors
                                                                    .DEFAULT_BLUE_GREY
                                                                : AppColors
                                                                    .kSelectionColor,
                                                        size:
                                                            AppDimensions.fontSize18(
                                                              context,
                                                            ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "PNG or JPEG",
                                                      style: AppStyle.style(
                                                        context: context,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color:
                                                            selectedDoumentId !=
                                                                    null
                                                                ? AppColors
                                                                    .DEFAULT_BLUE_GREY
                                                                : AppColors
                                                                    .kSelectionColor,
                                                        size:
                                                            AppDimensions.fontSize12(
                                                              context,
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: h(context) * .275,
                          child: InkWell(
                            onTap: () => _onSelectDocument(true),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              width: w(context) * .5,
                              decoration: BoxDecoration(
                                boxShadow:
                                    selectedDoumentId != null
                                        ? [
                                          BoxShadow(
                                            offset: Offset(0, 1),
                                            color: AppColors.black.withAlpha(
                                              60,
                                            ),
                                            blurRadius: 4,
                                            spreadRadius: 2,
                                          ),
                                        ]
                                        : [],
                                borderRadius: BorderRadius.circular(50),
                                color:
                                    selectedDoumentId != null
                                        ? AppColors.DEFAULT_ORANGE
                                        : AppColors.kSelectionColor,
                              ),

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    SolarIconsOutline.camera,
                                    color:
                                        selectedDoumentId != null
                                            ? AppColors.white
                                            : AppColors.grey,
                                    size: 35,
                                  ),
                                  AppSpacer(widthPortion: .02),
                                  Text(
                                    "Use Camera",
                                    style: AppStyle.style(
                                      context: context,
                                      size: AppDimensions.fontSize18(context),
                                      fontWeight: FontWeight.w600,
                                      color:
                                          selectedDoumentId != null
                                              ? AppColors.white
                                              : AppColors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        submissionState is SubmitDocumentSuccessState
                            ? AppLoadingIndicator()
                            : SizedBox(),
                      ],
                    );
                  },
                );
              }
            case FetchDocumentTypeErrorState():
              {
                return AppEmptyText(text: state.error);
              }
            default:
              {
                return AppLoadingIndicator();
              }
          }
        },
      ),
    );
  }

  final _imagePicker = ImagePicker();
  Uint8List? _memoryFile;
  String? _captureFile;

  void _onSelectDocument(bool itsCamera) async {
    try {
      if (selectedDoumentId != null) {
        if (itsCamera) {
          final scannedDocResult = await FlutterDocScanner().getScanDocuments(
            page: 1,
          );
          if (scannedDocResult != null) {
            _memoryFile = null;
            log(scannedDocResult.toString());

            final pdfUri = scannedDocResult['pdfUri'];
            if (pdfUri != null) {
              _captureFile = Uri.parse(pdfUri).toFilePath();
              log(_captureFile.toString());
            }

            setState(() {});
          } else {
            // Handle cancellation or error
            print("Document scanning was cancelled or failed.");
          }
        } else {
          final xFile = await _imagePicker.pickImage(
            source: ImageSource.gallery,
          );
          _captureFile = null;
          if (xFile == null) return;

          _memoryFile = await _convertFileInToUint8List(xFile);
          setState(() {});
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Uint8List> _convertFileInToUint8List(XFile files) async {
    final file = File(files.path);
    return await file.readAsBytes();
  }

  Widget _buildPdfView() => PDFView(
    fitPolicy: FitPolicy.BOTH,
    filePath: _captureFile,
    enableSwipe: false,
    swipeHorizontal: false,
    autoSpacing: true,
    pageSnap: true,
    fitEachPage: true,
  );
}
