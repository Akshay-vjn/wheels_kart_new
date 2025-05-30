import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:wheels_kart/core/components/app_custom_widgets.dart';
import 'package:wheels_kart/core/components/app_loading_indicator.dart';

import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20document%20types/fetch_document_type_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/submit%20document/submit_document_cubit.dart';

class UploadDocScreen extends StatefulWidget {
  final String inspectionId;
  
  const UploadDocScreen({super.key, required this.inspectionId});

  @override
  State<UploadDocScreen> createState() => _UploadDocScreenState();
}

class _UploadDocScreenState extends State<UploadDocScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _progressController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _progressAnimation;

  String? selectedDocumentId;
  String? selectedDocumentName;
  String? _capturedFilePath;
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initData();
  }

  void _initAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _slideController.forward();
    _scaleController.forward();
  }

  void _initData() {
    context.read<SubmitDocumentCubit>().init();
    context.read<FetchDocumentTypeBloc>().add(
      OnFetchDocumentTypeEvent(context: context),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocBuilder<FetchDocumentTypeBloc, FetchDocumentTypeState>(
        builder: (context, state) {
          switch (state) {
            case FetchDocumentTypeLoadingState():
              return _buildLoadingState();
            case FetchDocumentTypeSuccessState():
              return _buildMainContent(state);
            case FetchDocumentTypeErrorState():
              return _buildErrorState(state.error);
            default:
              return _buildLoadingState();
          }
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.DEFAULT_ORANGE),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading document types...',
            style: AppStyle.style(
              context: context,
              color: Colors.grey[600],
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Failed to load document types',
            style: AppStyle.style(
              context: context,
              color: AppColors.DARK_PRIMARY,
              fontWeight: FontWeight.bold,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: AppStyle.style(
              context: context,
              color: Colors.grey[600],
              size: 14,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _initData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(FetchDocumentTypeSuccessState state) {
    return BlocListener<SubmitDocumentCubit, SubmitDocumentState>(
      listener: (context, submissionState) {
        if (submissionState is SubmitDocumentLoadingState) {
          setState(() {
            _isUploading = true;
          });
          _progressController.forward();
        } else if (submissionState is SubmitDocumentSuccessState) {
          setState(() {
            _isUploading = false;
          });
          _showSuccessDialog();
        } else if (submissionState is SubmitDocumentErrorState) {
          setState(() {
            _isUploading = false;
          });
          _showErrorSnackBar(submissionState.error);
        }
      },
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      children: [
                        _buildHeaderSection(),
                        _buildDocumentTypeSelector(state),
                        _buildDocumentPreview(),
                        _buildUploadActions(),
                        const SizedBox(height: 100), // Space for FAB
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_isUploading) _buildUploadOverlay(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.DARK_PRIMARY,
      leading: customBackButton(context),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Upload Document',
          style: AppStyle.style(
            context: context,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            size: 20,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.DARK_PRIMARY,
                AppColors.DARK_PRIMARY.withOpacity(0.8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.DEFAULT_ORANGE.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.description_outlined,
                  color: AppColors.DEFAULT_ORANGE,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Document Upload',
                    style: AppStyle.style(
                      context: context,
                      color: AppColors.DARK_PRIMARY,
                      fontWeight: FontWeight.bold,
                      size: 18,
                    ),
                  ),
                  Text(
                    'Step 1 of 2',
                    style: AppStyle.style(
                      context: context,
                      color: Colors.grey[600],
                      size: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: _capturedFilePath != null ? 1.0 : 0.5,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.DEFAULT_ORANGE),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentTypeSelector(FetchDocumentTypeSuccessState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Document Type',
            style: AppStyle.style(
              context: context,
              color: AppColors.DARK_PRIMARY,
              fontWeight: FontWeight.bold,
              size: 16,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: InputBorder.none,
                hintText: 'Choose document type',
                hintStyle: TextStyle(color: Colors.grey[500]),
              ),
              dropdownColor: Colors.white,
              icon: Icon(Icons.arrow_drop_down, color: AppColors.DEFAULT_ORANGE),
              items: state.documentTypes
                  .map(
                    (docType) => DropdownMenuItem(
                      value: docType,
                      child: Row(
                        children: [
                          Icon(
                            Icons.description,
                            color: AppColors.DEFAULT_ORANGE,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            docType.documentTypeName,
                            style: AppStyle.style(
                              context: context,
                              color: AppColors.DARK_PRIMARY,
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                HapticFeedback.selectionClick();
                setState(() {
                  selectedDocumentId = value?.documentTypeId;
                  selectedDocumentName = value?.documentTypeName;
                });
              },
            ),
          ),
          if (selectedDocumentName != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.DEFAULT_ORANGE.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppColors.DEFAULT_ORANGE,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Selected: $selectedDocumentName',
                    style: TextStyle(
                      color: AppColors.DEFAULT_ORANGE,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDocumentPreview() {
    return Container(
      width: w(context),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: _capturedFilePath != null
            ? _buildDocumentViewer()
            : _buildEmptyPreview(),
      ),
    );
  }

  Widget _buildEmptyPreview() {
    return Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.description_outlined,
              size: 40,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Document Preview',
            style: AppStyle.style(
              context: context,
              color: AppColors.DARK_PRIMARY,
              fontWeight: FontWeight.bold,
              size: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your scanned document will appear here',
            textAlign: TextAlign.center,
            style: AppStyle.style(
              context: context,
              color: Colors.grey[600],
              size: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentViewer() {
    return Container(
      height: 300,
      child: Stack(
        children: [
          PDFView(
            fitPolicy: FitPolicy.BOTH,
            filePath: _capturedFilePath,
            enableSwipe: false,
            swipeHorizontal: false,
            autoSpacing: true,
            pageSnap: true,
            fitEachPage: true,
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.picture_as_pdf,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'PDF',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: FloatingActionButton.small(
              heroTag: "retake",
              onPressed: _onSelectDocument,
              backgroundColor: AppColors.DEFAULT_ORANGE,
              child: const Icon(Icons.refresh, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadActions() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Scan/Upload Button
          Material(
            elevation: selectedDocumentId != null ? 4 : 0,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: selectedDocumentId != null ? _onSelectDocument : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: selectedDocumentId != null
                      ? AppColors.DEFAULT_ORANGE.withOpacity(0.1)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selectedDocumentId != null
                        ? AppColors.DEFAULT_ORANGE
                        : Colors.grey[300]!,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: selectedDocumentId != null
                            ? AppColors.DEFAULT_ORANGE
                            : Colors.grey[400],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.document_scanner_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Scan Document',
                            style: AppStyle.style(
                              context: context,
                              color: selectedDocumentId != null
                                  ? AppColors.DARK_PRIMARY
                                  : Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              size: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            selectedDocumentId != null
                                ? 'Tap to scan your document'
                                : 'Select document type first',
                            style: AppStyle.style(
                              context: context,
                              color: Colors.grey[600],
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: selectedDocumentId != null
                          ? AppColors.DEFAULT_ORANGE
                          : Colors.grey[400],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Upload Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _canUpload() ? _onUploadDocument : null,
              icon: Icon(
                _isUploading ? Icons.hourglass_empty : Icons.cloud_upload,
                color: Colors.white,
              ),
              label: Text(
                _isUploading ? 'Uploading...' : 'Upload Document',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _canUpload()
                    ? AppColors.DEFAULT_ORANGE
                    : Colors.grey[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: _canUpload() ? 4 : 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadOverlay() {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return Container(
          color: Colors.black.withOpacity(0.7),
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(40),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    value: _progressAnimation.value,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.DEFAULT_ORANGE,
                    ),
                    strokeWidth: 6,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Uploading Document...',
                    style: AppStyle.style(
                      context: context,
                      color: AppColors.DARK_PRIMARY,
                      fontWeight: FontWeight.bold,
                      size: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(_progressAnimation.value * 100).toInt()}%',
                    style: AppStyle.style(
                      context: context,
                      color: Colors.grey[600],
                      size: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool _canUpload() {
    return selectedDocumentId != null && 
           _capturedFilePath != null && 
           !_isUploading;
  }

  void _onSelectDocument() async {
    if (selectedDocumentId == null) {
      _showErrorSnackBar('Please select a document type first');
      return;
    }

    try {
      HapticFeedback.mediumImpact();
      
      final scannedDocResult = await FlutterDocScanner().getScanDocuments(
        page: 1,
      );
      
      if (scannedDocResult != null) {
        log('Scanned document result: $scannedDocResult');
        
        final pdfUri = scannedDocResult['pdfUri'];
        if (pdfUri != null) {
          setState(() {
            _capturedFilePath = Uri.parse(pdfUri).toFilePath();
          });
          
          HapticFeedback.lightImpact();
          _showSuccessSnackBar('Document scanned successfully!');
        }
      } else {
        _showErrorSnackBar('Document scanning was cancelled');
      }
    } catch (e) {
      log('Document scanning error: $e');
      _showErrorSnackBar('Failed to scan document. Please try again.');
    }
  }

  void _onUploadDocument() async {
    if (!_canUpload()) return;

    try {
      HapticFeedback.mediumImpact();
      
      final file = File(_capturedFilePath!);
      final bytes = await file.readAsBytes();
      final base64 = base64Encode(bytes);
      final fileName = "$selectedDocumentName-${widget.inspectionId}.pdf";

      final json = {
        'documentId': selectedDocumentId,
        'fileName': fileName,
        'file': base64,
      };

      log('Uploading document: ${json.keys}');
      await context.read<SubmitDocumentCubit>().onSubmitDocument(
        context,
        widget.inspectionId,
        json,
      );
    } catch (e) {
      log('Upload error: $e');
      _showErrorSnackBar('Failed to upload document. Please try again.');
    }
  }

  void _showSuccessDialog() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Success!',
                style: AppStyle.style(
                  context: context,
                  color: AppColors.DARK_PRIMARY,
                  fontWeight: FontWeight.bold,
                  size: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your document has been uploaded successfully.',
                textAlign: TextAlign.center,
                style: AppStyle.style(
                  context: context,
                  color: Colors.grey[600],
                  size: 14,
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Go back to previous screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.DEFAULT_ORANGE,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}