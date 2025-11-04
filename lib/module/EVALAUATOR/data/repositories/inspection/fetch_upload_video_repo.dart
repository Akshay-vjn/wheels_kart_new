import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/const/ev_api_const.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';

class FetchUploadVideoRepo {
  static Future<Map<String, dynamic>> fetchVihicleVideo(
    BuildContext context,
    String inspectionID,
  ) async {
    final state = context.read<AppAuthController>().state;
    if (state is AuthCubitAuthenticateState) {
      try {
        final url = Uri.parse(
          '${EvApiConst.baseUrl}${EvApiConst.viewVideos}',
        );

        Response response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': state.userModel.token!,
          },
          body: jsonEncode({"inspectionId": inspectionID}),
        );

        log('Fetch videos response status: ${response.statusCode}');
        log('Fetch videos response body: ${response.body}');
        
        final decodedata = jsonDecode(response.body);

        if (decodedata['status'] == 200 || response.statusCode == 200) {
          return {
            'error': decodedata['error'] ?? false,
            'message': decodedata['message'] ?? 'Videos fetched successfully',
            'data': decodedata['data'] ?? [],
          };
        } else {
          return {
            'error': decodedata['error'] ?? true,
            'message': decodedata['message'] ?? 'Failed to fetch videos',
            'data': [],
          };
        }
      } catch (e) {
        log('repo - catch error - fetch vehicle videos => ${e.toString()}');
        return {
          'error': true,
          'message': 'Failed to fetch videos: ${e.toString()}',
        };
      }
    } else {
      return {};
    }
  }
}
