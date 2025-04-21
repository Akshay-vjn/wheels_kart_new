import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
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
import 'package:wheels_kart/core/utils/routes.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/upload%20documentts/upload_doc_screen.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/upload%20vehilce%20photo/view_uploaded_vihilce_photos.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_custom_button.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20documents/fetch_documents_cubit.dart';

class ViewUploadDocumentsScreen extends StatefulWidget {
  final String inspectionId;

  const ViewUploadDocumentsScreen({super.key, required this.inspectionId});

  @override
  State<ViewUploadDocumentsScreen> createState() =>
      _ViewUploadDocumentsScreenState();
}

class _ViewUploadDocumentsScreenState extends State<ViewUploadDocumentsScreen> {
  @override
  void initState() {
    context.read<FetchDocumentsCubit>().onFetchDocumets(
      context,
      widget.inspectionId,
    );

    super.initState();
  }

  int currentPage = 0;
  // String? dowloadd;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: customBackButton(context),
        title: Text(
          "Upload Documents",
          style: AppStyle.style(
            context: context,
            color: AppColors.white,
            size: AppDimensions.fontSize18(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocBuilder<FetchDocumentsCubit, FetchDocumentsState>(
        builder: (context, state) {
          switch (state) {
            case FetchDocumentsLoadingState():
              {
                return AppLoadingIndicator();
              }
            case FetchDocumentsSuccessState():
              {
                return state.documets.isEmpty
                    ? _buildNoDocumentsUi()
                    : Column(
                      children: [
                        AppSpacer(heightPortion: .01),

                        Expanded(
                          child: AppMargin(
                            child: PageView.builder(
                              onPageChanged: (value) {
                                currentPage = value;
                              },
                              scrollDirection: Axis.horizontal,

                              itemCount: state.documets.length,
                              itemBuilder: (context, index) {
                                final document = state.documets[index];

                                return FutureBuilder(
                                  future: downloadPdf(document.document),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return AppLoadingIndicator();
                                    }
                                    return document.document.contains('.pdf')
                                        ? Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.white,
                                            border: Border.all(
                                              width: 2,
                                              color: AppColors.BORDER_COLOR,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      document.documentType,
                                                      style: AppStyle.poppins(
                                                        size: 30,
                                                        context: context,
                                                        color: AppColors.black2,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${currentPage + 1}/${state.documets.length}",
                                                      style: AppStyle.poppins(
                                                        context: context,
                                                        size: 20,
                                                        color: AppColors.black2,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: _buildPdfView(
                                                  snapshot.data,
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    15,
                                                  ),
                                                  child: ElevatedButton(
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              AppColors.kRed,
                                                        ),
                                                    onPressed: () async {
                                                      context
                                                          .read<
                                                            FetchDocumentsCubit
                                                          >()
                                                          .deleteDocument(
                                                            context,
                                                            widget.inspectionId,
                                                            document
                                                                .inspectionDocumentId,
                                                          );

                                                      // context
                                                      //     .read<
                                                      //       FetchDocumentsCubit
                                                      //     >()
                                                      //     .onFetchDocumets(
                                                      //       context,
                                                      //       widget.inspectionId,
                                                      //     );
                                                    },
                                                    child: Text(
                                                      "Delete",
                                                      style: AppStyle.style(
                                                        context: context,
                                                        color: AppColors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                        : CachedNetworkImage(
                                          imageUrl: document.document,
                                        );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        AppSpacer(heightPortion: .01),
                        AppMargin(
                          child: InkWell(
                            onTap: () async {
                              Navigator.of(context).push(
                                AppRoutes.createRoute(
                                  UploadDocScreen(
                                    inspectionId: widget.inspectionId,
                                  ),
                                ),
                              );
                            },
                            child: CustomPaint(
                              foregroundPainter: DashedBorderPainter(),
                              child: SizedBox(
                                height: 150,
                                width: w(context),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: AppColors.grey,
                                      size: 100,
                                    ),
                                    Text(
                                      "Upload new one",
                                      style: AppStyle.style(
                                        context: context,
                                        color: AppColors.grey,
                                        size: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        AppSpacer(heightPortion: .02),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 1,
                                spreadRadius: 1,
                                color: AppColors.DARK_PRIMARY.withAlpha(50),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              AppSpacer(heightPortion: .02),
                              AppMargin(
                                child: EvAppCustomButton(
                                  isSquare: false,
                                  bgColor:
                                      state.documets.isNotEmpty
                                          ? null
                                          : Color(0xFFC2C3C5),
                                  onTap: () {
                                    if (state.documets.isNotEmpty) {}
                                    Navigator.of(context).push(
                                      AppRoutes.createRoute(
                                        ViewUploadedVihilcePhotosScreen(
                                          inspectionId: widget.inspectionId,
                                        ),
                                      ),
                                    );
                                  },

                                  child: Column(
                                    children: [
                                      Text(
                                        'Upload Vehicle Photos',
                                        style: AppStyle.style(
                                          context: context,
                                          color: AppColors.white,
                                          fontWeight: FontWeight.bold,
                                          size: 16,
                                        ),
                                      ),
                                      Text(
                                        '(Upload photos from different angles)',
                                        style: AppStyle.style(
                                          context: context,
                                          color: AppColors.white.withOpacity(
                                            0.9,
                                          ),
                                          size: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              AppSpacer(heightPortion: .02),
                            ],
                          ),
                        ),
                      ],
                    );
              }
            case FetchDocumentsErrorState():
              {
                return AppEmptyText(text: state.error);
              }
            default:
              {
                return SizedBox();
              }
          }
        },
      ),
    );
  }

  Widget _buildNoDocumentsUi() => Center(
    child: AppMargin(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                AppRoutes.createRoute(
                  UploadDocScreen(inspectionId: widget.inspectionId),
                ),
              );
            },
            child: CustomPaint(
              foregroundPainter: DashedBorderPainter(),
              child: SizedBox(
                width: w(context) * .5,

                height: w(context) * .5,
                child: Icon(Icons.add, color: AppColors.grey, size: 100),
              ),
            ),
          ),
          AppSpacer(heightPortion: .06),
          Text(
            textAlign: TextAlign.center,
            "You haven't uploaded any documents yet!",
            style: AppStyle.style(
              context: context,
              color: AppColors.black2,
              fontWeight: FontWeight.w400,
              size: 20,
            ),
          ),
          Text(
            textAlign: TextAlign.center,
            "Please upload your vehicle documents.",
            style: AppStyle.style(
              context: context,
              color: AppColors.black2,
              fontWeight: FontWeight.w400,
              size: 15,
            ),
          ),
        ],
      ),
    ),
  );

  Future<String> downloadPdf(url) async {
    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/downloaded.pdf';
    final respose = await Dio().download(url, filePath);
    log(respose.extra.toString());
    return filePath;
  }

  Widget _buildPdfView(file) => SizedBox(
    child: SizedBox(
      height: h(context),
      width: w(context),
      child: PDFView(
        backgroundColor: AppColors.white,
        fitPolicy: FitPolicy.WIDTH,
        filePath: file,
        enableSwipe: false,
        swipeHorizontal: false,
        autoSpacing: false,
        pageSnap: false,
        onError: (error) {
          log(error.toString());
        },

        fitEachPage: true,
      ),
    ),
  );
}
