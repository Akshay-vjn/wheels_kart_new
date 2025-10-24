import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_api_const.dart';

class VGetMyOwnedRepo {
  static Future<Map<String, dynamic>> onGetMyOwned(
    BuildContext context,
  ) async {
    final state = context.read<AppAuthController>().state;
    if (state is AuthCubitAuthenticateState) {
      try {
        final url = Uri.parse('${VApiConst.baseUrl}${VApiConst.myOwned}');
        log("🌐 Calling owned auctions API: $url");
        log("🔑 Using token: ${state.userModel.token!.substring(0, 20)}...");

        Response response = await http.post(
          url,
          headers: {
            'Authorization': state.userModel.token!,
          },
        );

        log("📡 API Response Status: ${response.statusCode}");
        log("📄 API Response Body: ${response.body}");

        final decodedata = jsonDecode(response.body);

        if (decodedata['status'] == 200 || decodedata['status'] == 201) {
          log("✅ API call successful, data length: ${decodedata['data']?.length ?? 0}");
          return {
            'error': decodedata['error'],
            'message': decodedata['message'],
            'data': decodedata['data'],
          };
        } else {
          log("❌ API call failed: ${decodedata['message']}");
          return {
            'error': decodedata['error'],
            'message': decodedata['message'],
          };
        }
      } catch (e) {
        log('❌ repo - catch error - Dealer - OWNED AUCTIONS => ${e.toString()}');
        return {
          'error': true,
          'message': 'Failed to fetch owned auctions: ${e.toString()}',
        };
      }
    } else {
      log("❌ User not authenticated");
      return {
        'error': true,
        'message': 'User not authenticated',
      };
    }
  }
}
