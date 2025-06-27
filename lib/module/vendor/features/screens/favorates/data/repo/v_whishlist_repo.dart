import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/module/vendor/core/const/v_api_const.dart';

class VWhishlistRepo {
  static Future<Map<String, dynamic>> onFetchWishList(
    BuildContext context,
  ) async {
    final state = context.read<AppAuthController>().state;
    if (state is AuthCubitAuthenticateState) {
      try {
        final url = Uri.parse('${VApiConst.baseUrl}${VApiConst.whishList}');

        Response response = await http.post(
          url,
          headers: {'Authorization': state.userModel.token},
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
        log(
          'repo - catch error - vendor - Wish list add remove => ${e.toString()}F',
        );
        return {};
      }
    } else {
      return {};
    }
  }
}
