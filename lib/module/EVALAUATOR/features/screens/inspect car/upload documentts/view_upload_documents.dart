import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_custom_widgets.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_loading_indicator.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';

import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/upload%20documentts/upload_doc_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch%20documents/fetch_documents_cubit.dart';

class ViewUploadDocumentsScreen extends StatefulWidget {
  final String inspectionId;

  const ViewUploadDocumentsScreen({super.key, required this.inspectionId});

  @override
  State<ViewUploadDocumentsScreen> createState() =>
      _ViewUploadDocumentsScreenState();
}

class _ViewUploadDocumentsScreenState extends State<ViewUploadDocumentsScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fabAnimationController;
  late AnimationController _slideAnimationController;
  late Animation<double> _fabScaleAnimation;
  late Animation<Offset> _slideAnimation;
  
  int currentPage = 0;
  bool isZoomed = false;
  double pdfZoom = 1.0;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _fabScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.elasticOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutCubic,
    ));
    
    context.read<FetchDocumentsCubit>().onFetchDocumets(
      context,
      widget.inspectionId,
    );
    
    _fabAnimationController.forward();
    _slideAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabAnimationController.dispose();
    _slideAnimationController.dispose();
    super.dispose();
  }

  void _showDeleteConfirmation(String documentId) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, 
                   color: Colors.orange, size: 28),
              const SizedBox(width: 12),
              const Text('Confirm Delete'),
            ],
          ),
          content: const Text(
            'Are you sure you want to remove this document? This action cannot be undone.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () async{
              
              await  context.read<FetchDocumentsCubit>().deleteDocument(
                  context,
                  widget.inspectionId,
                  documentId,
                );
                  Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: EvAppColors.kRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: EvAppColors.DARK_PRIMARY,
        leading: evCustomBackButton(context),
        title: Text(
          "Vehicle Documents",
          style: EvAppStyle.style(
            context: context,
            color: EvAppColors.white,
            size: AppDimensions.fontSize18(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () => _showInfoDialog(),
          ),
        ],
      ),
      body: BlocBuilder<FetchDocumentsCubit, FetchDocumentsState>(
        builder: (context, state) {
          switch (state) {
            case FetchDocumentsLoadingState():
              return _buildLoadingState();
            case FetchDocumentsSuccessState():
              return state.documets.isEmpty
                  ? _buildEmptyState()
                  : _buildDocumentsList(state);
            case FetchDocumentsErrorState():
              return _buildErrorState(state.error);
            default:
              return const SizedBox();
          }
        },
      ),
      floatingActionButton: BlocBuilder<FetchDocumentsCubit, FetchDocumentsState>(
        builder: (context, state) {
          if (state is FetchDocumentsSuccessState && state.documets.isNotEmpty) {
            return ScaleTransition(
              scale: _fabScaleAnimation,
              child: FloatingActionButton.extended(
                onPressed: _navigateToUpload,
                backgroundColor: EvAppColors.DEFAULT_ORANGE,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Add Document',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
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
            'Loading documents...',
            style: EvAppStyle.style(
              context: context,
              color: Colors.grey[600],
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SlideTransition(
      position: _slideAnimation,
      child: Center(
        child: AppMargin(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.description_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "No Documents Found",
                style: EvAppStyle.style(
                  context: context,
                  color: EvAppColors.DARK_PRIMARY,
                  fontWeight: FontWeight.bold,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Upload your vehicle documents to get started",
                textAlign: TextAlign.center,
                style: EvAppStyle.style(
                  context: context,
                  color: Colors.grey[600],
                  size: 16,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _navigateToUpload,
                icon: const Icon(Icons.cloud_upload_outlined),
                label: const Text('Upload Documents'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: EvAppColors.DEFAULT_ORANGE,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: EvAppStyle.style(
              context: context,
              color: EvAppColors.DARK_PRIMARY,
              fontWeight: FontWeight.bold,
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            error,
            textAlign: TextAlign.center,
            style: EvAppStyle.style(
              context: context,
              color: Colors.grey[600],
              size: 14,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<FetchDocumentsCubit>().onFetchDocumets(
                context,
                widget.inspectionId,
              );
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsList(FetchDocumentsSuccessState state) {
    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        children: [
          // Header with document count and upload button
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Documents",
                      style: EvAppStyle.style(
                        context: context,
                        color: EvAppColors.DARK_PRIMARY,
                        fontWeight: FontWeight.bold,
                        size: 20,
                      ),
                    ),
                    Text(
                      "${state.documets.length} document${state.documets.length > 1 ? 's' : ''} uploaded",
                      style: EvAppStyle.style(
                        context: context,
                        color: Colors.grey[600],
                        size: 14,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: EvAppColors.DEFAULT_ORANGE.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${currentPage + 1}/${state.documets.length}",
                    style: EvAppStyle.style(
                      context: context,
                      color: EvAppColors.DEFAULT_ORANGE,
                      fontWeight: FontWeight.bold,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Document viewer
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                  HapticFeedback.selectionClick();
                },
                itemCount: state.documets.length,
                itemBuilder: (context, index) {
                  final document = state.documets[index];
                  return _buildDocumentCard(document, index);
                },
              ),
            ),
          ),
          
          // Page indicators
          if (state.documets.length > 1)
            Container(
              margin: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  state.documets.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: currentPage == index
                          ? EvAppColors.DEFAULT_ORANGE
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            AppSpacer(heightPortion: .09,)
        ],
      ),
    );
  }

  Widget _buildDocumentCard(dynamic document, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16,right: 10,),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Document content
            FutureBuilder<String>(
              future: document.document.contains('.pdf') 
                  ? downloadPdf(document.document)
                  : Future.value(document.document),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: double.infinity,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              EvAppColors.DEFAULT_ORANGE,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Loading document...',
                            style: EvAppStyle.style(
                              context: context,
                              color: Colors.grey[600],
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                
                return document.document.contains('.pdf')
                    ? _buildPdfViewer(snapshot.data!)
                    : _buildImageViewer(document.document);
              },
            ),
            
            // Document header
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: EvAppColors.DEFAULT_ORANGE,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            document.document.contains('.pdf') 
                                ? Icons.picture_as_pdf 
                                : Icons.image,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            document.documentType,
                            style: EvAppStyle.style(
                              context: context,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => _showDeleteConfirmation(
                        document.inspectionDocumentId,
                      ),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                          size: 18,
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
    );
  }

  Widget _buildPdfViewer(String filePath) {
    return Container(
      child: PDFView(
        backgroundColor: Colors.white,
        fitPolicy: FitPolicy.BOTH,
        filePath: filePath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageSnap: true,
        onError: (error) {
          log('PDF Error: $error');
        },
        onPageError: (page, error) {
          log('PDF Page Error: $error');
        },
        fitEachPage: true,
      ),
    );
  }

  Widget _buildImageViewer(String imageUrl) {
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4.0,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain,
          placeholder: (context, url) => Container(
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  EvAppColors.DEFAULT_ORANGE,
                ),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.broken_image_outlined,
                  size: 60,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 12),
                Text(
                  'Failed to load image',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> downloadPdf(String url) async {
    try {
      final dir = await getTemporaryDirectory();
      final fileName = url.split('/').last;
      final filePath = '${dir.path}/$fileName';
      
      // Check if file already exists
      if (await File(filePath).exists()) {
        return filePath;
      }
      
      final response = await Dio().download(
        url, 
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            log('Download progress: ${(received / total * 100).toStringAsFixed(0)}%');
          }
        },
      );
      
      log('PDF downloaded successfully: ${response.statusCode}');
      return filePath;
    } catch (e) {
      log('Download error: $e');
      rethrow;
    }
  }

  void _navigateToUpload() {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      AppRoutes.createRoute(
        UploadDocScreen(inspectionId: widget.inspectionId),
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.info_outline, color: EvAppColors.DEFAULT_ORANGE),
              const SizedBox(width: 12),
              const Text('Document Tips'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTipItem('Swipe horizontally to view different documents'),
              _buildTipItem('Pinch to zoom on images'),
              _buildTipItem('Tap the delete button to remove documents'),
              _buildTipItem('Use the + button to add new documents'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Got it',
                style: TextStyle(color: EvAppColors.DEFAULT_ORANGE),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 8),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: EvAppColors.DEFAULT_ORANGE,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}