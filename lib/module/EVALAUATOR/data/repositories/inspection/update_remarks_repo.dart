import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:wheels_kart/common/controllers/auth cubit/auth_cubit.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/const/ev_api_const.dart';

class UpdateRemarksRepo {
  static Future<Map<String, dynamic>> updateRemarks(
    BuildContext context,
    String inspectionId,
    String remarks,
  ) async {
    final state = context.read<AppAuthController>().state;
    if (state is AuthCubitAuthenticateState) {
      try {
        final url = Uri.parse('${EvApiConst.baseUrl}${EvApiConst.updateRemarks}');
        
        final body = jsonEncode({
          'inspectionId': inspectionId,
          'remarks': remarks,
        });

        log('Update Remarks API Request: $body');

        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': state.userModel.token!,
          },
          body: body,
        );

        final decodedata = jsonDecode(response.body);
        log('Update Remarks API Response: $decodedata');

        if (decodedata['status'] == 200) {
          return {
            'error': decodedata['error'],
            'message': decodedata['message'],
            'data': decodedata['data'],
          };
        } else {
          return {
            'error': decodedata['error'],
            'message': decodedata['message'],
          };
        }
      } catch (e) {
        log('Update Remarks API Error: ${e.toString()}');
        return {
          'error': true,
          'message': 'Network error: ${e.toString()}',
        };
      }
    } else {
      return {
        'error': true,
        'message': 'User not authenticated',
      };
    }
  }
}
