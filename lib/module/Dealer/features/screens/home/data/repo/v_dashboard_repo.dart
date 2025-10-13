import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_api_const.dart';

class VAuctionData {
  static Future<Map<String, dynamic>> getAuctionData(
    BuildContext context,
  ) async {
    final state = context.read<AppAuthController>().state;
    if (state is AuthCubitAuthenticateState) {
      try {
        final url = Uri.parse('${VApiConst.baseUrl}${VApiConst.auctionData}');

        Response response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': state.userModel.token!,
          },
        );

        final decodedata = jsonDecode(response.body);

        if (decodedata['status'] == 200) {
          // Handle both old and new API response formats
          final data = decodedata['data'];
          
          // New format: data contains 'live' and 'closed' arrays
          if (data is Map && data.containsKey('live') && data.containsKey('closed')) {
            return {
              'error': decodedata['error'],
              'message': decodedata['message'],
              'live': data['live'] ?? [],
              'closed': data['closed'] ?? [],
            };
          } 
          // Old format: data is a direct list
          else if (data is List) {
            return {
              'error': decodedata['error'],
              'message': decodedata['message'],
              'data': data,
            };
          }
          
          // Default case
          return {
            'error': decodedata['error'],
            'message': decodedata['message'],
            'data': data,
          };
        } else {
          return {
            'error': decodedata['error'],
            'message': decodedata['message'],
          };
        }
      } catch (e) {
        log('repo - catch error - Dealer - DASHBOARD => ${e.toString()}F');
        return {};
      }
    } else {
      return {};
    }
  }
}
