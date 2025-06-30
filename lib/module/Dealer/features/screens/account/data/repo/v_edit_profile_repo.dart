import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_api_const.dart';

class VEditProfileRepo {
  static Future<Map<String, dynamic>> onEditProfile(
    BuildContext context,
    String name,
    String email,
    String city,
  ) async {
    final state = context.read<AppAuthController>().state;
    if (state is AuthCubitAuthenticateState) {
      try {
        final url = Uri.parse('${VApiConst.baseUrl}${VApiConst.editProfile}');

        Response response = await http.post(
          url,
          body: {"DealerName": name, "DealerEmail": email, "DealerCity": city},
          headers: {
            // 'Content-Type': 'application/json',
            'Authorization': state.userModel.token,
          },
        );

        final decodedata = jsonDecode(response.body);

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
        log('repo - catch error - Dealer - EDIT PROFILE => ${e.toString()}F');
        return {};
      }
    } else {
      return {};
    }
  }
}
