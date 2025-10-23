import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_api_const.dart';

class VGetDocumentsRepo {
  static Future<Map<String, dynamic>> onGetDocuments(
    BuildContext context,
  ) async {
    final state = context.read<AppAuthController>().state;
    log('VGetDocumentsRepo: Auth state: ${state.runtimeType}');
    
    if (state is AuthCubitAuthenticateState) {
      try {
        final url = Uri.parse(
          '${VApiConst.baseUrl}${VApiConst.receivedDocuments}',
        );
        
        log('VGetDocumentsRepo: Making request to: $url');
        log('VGetDocumentsRepo: Token: ${state.userModel.token}');

        Response response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': state.userModel.token!,
          },
        );

        log('VGetDocumentsRepo: Response status: ${response.statusCode}');
        log('VGetDocumentsRepo: Response body: ${response.body}');

        final decodedata = jsonDecode(response.body);

        if (decodedata['status'] == 200) {
          log('VGetDocumentsRepo: Success response');
          return {
            'error': decodedata['error'],
            'message': decodedata['message'],
            'data': decodedata['data'],
          };
        } else {
          log('VGetDocumentsRepo: Error response: ${decodedata['message']}');
          return {
            'error': decodedata['error'],
            'message': decodedata['message'],
          };
        }
      } catch (e) {
        log('VGetDocumentsRepo: Exception - ${e.toString()}');
        return {};
      }
    } else {
      log('VGetDocumentsRepo: User not authenticated');
      return {};
    }
  }
}
