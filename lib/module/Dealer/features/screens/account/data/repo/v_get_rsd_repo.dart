import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_api_const.dart';

/// Repository for RSD (Refundable Security Deposit) data operations
/// Handles API calls to fetch RSD history
class VGetRsdRepo {
  /// Fetches RSD list from the server
  /// 
  /// Returns a Map containing:
  /// - 'error': bool - Whether an error occurred
  /// - 'message': String - Response message
  /// - 'data': List - RSD data (if successful)
  static Future<Map<String, dynamic>> getRsdList(BuildContext context,) async {
    final state = context
        .read<AppAuthController>()
        .state;

    if (state is AuthCubitAuthenticateState) {
      try {
        final url = Uri.parse(
          '${VApiConst.baseUrl}${VApiConst.rsdHistory}',
        );

        final Response response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': state.userModel.token!,
          },
        );

        final decodedData = jsonDecode(response.body);

        if (decodedData['status'] == 200) {
          return {
            'error': decodedData['error'],
            'message': decodedData['message'],
            'data': decodedData['data'],
          };
        } else {
          return {
            'error': decodedData['error'],
            'message': decodedData['message'],
          };
        }
      } catch (e) {
        log('repo - catch error - RSD History => ${e.toString()}');
        return {
          'error': true,
          'message': 'Failed to fetch RSD history: ${e.toString()}',
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