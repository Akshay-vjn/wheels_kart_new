import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wheels_kart/module/evaluator/data/repositories/inspection/download_inspection_pdf_repo.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadPdfCubit extends Cubit<DownloadPdfState> {
  DownloadPdfCubit() : super(DownloadPdfInitial());

  Future<void> onDownloadPDF(BuildContext context, String inspectionID) async {
    try {
      emit(DownloadPdfLoadingState());

      // Check and request storage permission
      bool hasPermission = await _requestStoragePermission();
      if (!hasPermission) {
        emit(DowloadPdfErrorState(message: 'Storage permission denied'));
        return;
      }

      // Download the PDF
      final response = await DownloadInspectionPdfRepo.dowloadPDF(
        context,
        inspectionID,
      );

      if (response != null && response.isNotEmpty) {
        final bytes = response;
        
        // Generate unique filename to avoid conflicts
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName = 'inspection_report_${inspectionID}_$timestamp.pdf';
        
        // Get the appropriate directory for saving files
        final Directory? directory = await _getDownloadDirectory();
        if (directory == null) {
          emit(DowloadPdfErrorState(message: 'Unable to access storage directory'));
          return;
        }

        final file = File('${directory.path}/$fileName');
        
        // Write the PDF file
        await file.writeAsBytes(bytes);
        
        // Verify file was created successfully
        if (await file.exists()) {
          emit(DowloadPdfSuccessState(
            filePath: file.path,
            fileName: fileName,
          ));
          
          // Open the file
          final result = await OpenFile.open(file.path);
          if (result.type != ResultType.done) {
            // If can't open directly, show file location
            _showFileLocationDialog(context, file.path);
          }
        } else {
          emit(DowloadPdfErrorState(message: 'Failed to save PDF file'));
        }
      } else {
        emit(DowloadPdfErrorState(message: 'No data received from server'));
      }
    } catch (e) {
      emit(DowloadPdfErrorState(message: 'Download failed: ${e.toString()}'));
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      // For Android 10+ (API 29+), we need different permissions
      if (await Permission.storage.isGranted) {
        return true;
      }
      
      final status = await Permission.storage.request();
      if (status.isGranted) {
        return true;
      }
      
      // Try with manage external storage for Android 11+
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }
      
      final manageStatus = await Permission.manageExternalStorage.request();
      return manageStatus.isGranted;
    } else if (Platform.isIOS) {
      // iOS doesn't need explicit storage permission for app documents
      return true;
    }
    
    return false;
  }

  Future<Directory?> _getDownloadDirectory() async {
    try {
      if (Platform.isAndroid) {
        // Try to get external storage directory first
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          final downloadDir = Directory('${externalDir.path}/Downloads');
          if (!await downloadDir.exists()) {
            await downloadDir.create(recursive: true);
          }
          return downloadDir;
        }
        
        // Fallback to application documents directory
        return await getApplicationDocumentsDirectory();
      } else {
        // For iOS, use application documents directory
        return await getApplicationDocumentsDirectory();
      }
    } catch (e) {
      // Final fallback to application documents directory
      return await getApplicationDocumentsDirectory();
    }
  }

  void _showFileLocationDialog(BuildContext context, String filePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 24),
              SizedBox(width: 12),
              Text(
                'Download Complete',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PDF has been saved successfully!',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'File Location:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      filePath,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await OpenFile.open(filePath);
              },
              child: Text('Open File'),
            ),
          ],
        );
      },
    );
  }

  void retryDownload(BuildContext context, String inspectionID) {
    onDownloadPDF(context, inspectionID);
  }
}

// States
@immutable
sealed class DownloadPdfState {}

final class DownloadPdfInitial extends DownloadPdfState {}

final class DownloadPdfLoadingState extends DownloadPdfState {}

final class DowloadPdfErrorState extends DownloadPdfState {
  final String message;
  
  DowloadPdfErrorState({
    this.message = 'An error occurred while downloading the PDF',
  });
}

final class DowloadPdfSuccessState extends DownloadPdfState {
  final String filePath;
  final String fileName;
  
  DowloadPdfSuccessState({
    required this.filePath,
    required this.fileName,
  });
}