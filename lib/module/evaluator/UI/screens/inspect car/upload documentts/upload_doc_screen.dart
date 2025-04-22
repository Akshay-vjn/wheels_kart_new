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
  String? selectedDocument;
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
                                                        value: e,
                                                        child: Text(
                                                          e.documentTypeName,
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                            onChanged: (value) {
                                              selectedDoumentId =
                                                  value?.documentTypeId;
                                              selectedDocument =
                                                  value?.documentTypeName;
                                              setState(() {});
                                              log(selectedDoumentId ?? "Null");
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
                                      AppSpacer(heightPortion: .03),
                                      InkWell(
                                        onTap: () => _onSelectDocument(),
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

                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                SolarIconsOutline.document1,
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
                                                      "Scan your documets or take a photo",
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
                                                      "PNG,JPEG or PDF",
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
                            onTap:
                                _captureFile == null ||
                                        submissionState
                                            is SubmitDocumentSuccessState
                                    ? null
                                    : () async {
                                      if (submissionState
                                          is! SubmitDocumentLoadingState) {
                                        String base64 = '';
                                        String fileName = '';
                                        if (_captureFile != null) {
                                          final file = File(_captureFile!);
                                          final bytes =
                                              await file.readAsBytes();
                                          base64 = base64Encode(bytes);
                                          fileName =
                                              "$selectedDocument-${widget.inspectionId}.pdf";
                                        }

                                        final json = {
                                          'documentId': selectedDoumentId,
                                          'fileName': fileName,
                                          'file': base64,
                                        };
                                        log(json.toString());
                                        await context
                                            .read<SubmitDocumentCubit>()
                                            .onSubmitDocument(
                                              context,
                                              widget.inspectionId,
                                              json,
                                            );
                                      }

                                      // Navigator.of(context)
                                    },
                            child: Container(
                              height: h(context) * .06,
                              width: w(context) * .6,
                              decoration: BoxDecoration(
                                boxShadow:
                                    _captureFile == null ||
                                            submissionState
                                                is SubmitDocumentSuccessState
                                        ? []
                                        : [
                                          BoxShadow(
                                            offset: Offset(0, 1),
                                            color: AppColors.black.withAlpha(
                                              60,
                                            ),
                                            blurRadius: 4,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                color:
                                    _captureFile == null ||
                                            submissionState
                                                is SubmitDocumentSuccessState
                                        ? AppColors.kSelectionColor
                                        : AppColors.DEFAULT_ORANGE,
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Save",
                                    style: AppStyle.style(
                                      context: context,
                                      color:
                                          _captureFile == null ||
                                                  submissionState
                                                      is SubmitDocumentSuccessState
                                              ? AppColors.grey
                                              : AppColors.white,
                                      fontWeight: FontWeight.bold,
                                      size: 20,
                                    ),
                                  ),
                                  AppSpacer(widthPortion: .04),
                                  Icon(
                                    SolarIconsOutline.upload,
                                    color:
                                        _captureFile == null ||
                                                submissionState
                                                    is SubmitDocumentSuccessState
                                            ? AppColors.grey
                                            : AppColors.white,
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

  String? _captureFile;

  void _onSelectDocument() async {
    try {
      if (selectedDoumentId != null) {
        final scannedDocResult = await FlutterDocScanner().getScanDocuments(
          page: 1,
        );
        if (scannedDocResult != null) {
          log(scannedDocResult.toString());

          final pdfUri = scannedDocResult['pdfUri'];
          if (pdfUri != null) {
            _captureFile = Uri.parse(pdfUri).toFilePath();
          }

          setState(() {});
        } else {
          print("Document scanning was cancelled or failed.");
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // Future<Uint8List> _convertFileInToUint8List(XFile files) async {
  //   final file = File(files.path);
  //   return await file.readAsBytes();
  // }

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
