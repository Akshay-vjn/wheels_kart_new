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
          "Vehicle Documents",
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AppSpacer(heightPortion: .01),
                        AppMargin(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.DEFAULT_ORANGE,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                AppRoutes.createRoute(
                                  UploadDocScreen(
                                    inspectionId: widget.inspectionId,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Upload New Document",
                                    style: AppStyle.style(
                                      context: context,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  AppSpacer(widthPortion: .03),
                                  Icon(Icons.add, color: AppColors.white),
                                ],
                              ),
                            ),
                          ),
                        ),
                        AppSpacer(heightPortion: .01),

                        AppMargin(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Uploaded Documets",
                              style: AppStyle.style(
                                context: context,
                                color: AppColors.DARK_PRIMARY,
                                fontWeight: FontWeight.bold,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        AppSpacer(heightPortion: .01),
                        SizedBox(
                          height: h(context) * .6,
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
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                          color: AppColors.white,
                                          border: Border.all(),
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            _buildPdfView(snapshot.data),
                                            Positioned(
                                              bottom: 10,
                                              left: 10,
                                              right: 10,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 5,
                                                ),
                                                width: w(context),
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColors.DEFAULT_ORANGE,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      document.documentType,
                                                      style: AppStyle.poppins(
                                                        size: 20,
                                                        context: context,
                                                        color: AppColors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${currentPage + 1}/${state.documets.length}",
                                                      style: AppStyle.style(
                                                        context: context,
                                                        size: 20,
                                                        color: AppColors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              right: 15,
                                              top: 10,
                                              child: InkWell(
                                                onTap: () {
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
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.FILL_COLOR,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          50,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    "Remove",
                                                    style: AppStyle.style(
                                                      color: AppColors.kRed,
                                                      context: context,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                        AppSpacer(heightPortion: .01),
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
