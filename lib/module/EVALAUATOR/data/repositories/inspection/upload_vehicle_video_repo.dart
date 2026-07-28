import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/const/ev_api_const.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';

class UploadVehicleVideoRepo {
  static Future<Map<String, dynamic>> uploadVehicleVideo(
    BuildContext context,
    String inspectionId,
    String video,
    String fileName,
  ) async {
    final state = context.read<AppAuthController>().state;
    if (state is AuthCubitAuthenticateState) {
      try {
        final url = Uri.parse('${EvApiConst.baseUrl}${EvApiConst.uploadVideo}');
        // final List<Map<String, dynamic>> data = [];
        // data.add(video);
        Response response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': state.userModel.token!,
          },

          body: jsonEncode({
            "inspectionId": inspectionId,
            'videos': [
              {"videoType": fileName, "video": video},
            ],
          }),
        );

        log('Upload video response status: ${response.statusCode}');
        log('Upload video response body: ${response.body}');

        // Handle HTML error responses (e.g. 413 Payload Too Large, 502 Bad Gateway, 504 Gateway Timeout)
        if (response.statusCode == 413) {
          return {
            'error': true,
            'message': 'Video payload is too large for the server (HTTP 413). Please try a shorter video.',
          };
        } else if (response.statusCode >= 500) {
          return {
            'error': true,
            'message': 'Server error (HTTP ${response.statusCode}). Please try again later.',
          };
        }

        try {
          final decodedata = jsonDecode(response.body);

          if (decodedata['status'] == 200 || response.statusCode == 200) {
            return {
              'error': decodedata['error'] ?? false,
              'message': decodedata['message'] ?? 'Video uploaded successfully',
              'data': decodedata['data'],
            };
          } else {
            return {
              'error': decodedata['error'] ?? true,
              'message': decodedata['message'] ?? 'Upload failed',
            };
          }
        } on FormatException catch (_) {
          log('Response is not valid JSON. Response body: ${response.body}');
          return {
            'error': true,
            'message': 'Server returned an invalid response (HTTP ${response.statusCode}).',
          };
        }
      } catch (e) {
        log('repo - catch error - upload vehicle video => ${e.toString()}');
        return {
          'error': true,
          'message': 'Upload failed: ${e.toString()}',
        };
      }
    } else {
      return {};
    }
  }
}
