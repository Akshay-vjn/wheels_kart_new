import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:wheels_kart/core/constant/string.dart';
import 'package:http/http.dart' as http;
import 'package:wheels_kart/module/evaluator/data/bloc/auth%20cubit/auth_cubit.dart';

class FetchCitiesRepo {
  static Future<Map<String, dynamic>> getCityList(BuildContext context) async {
    final state = context.read<EvAuthBlocCubit>().state;
    if (state is AuthCubitAuthenticateState) {
      try {
        final url = Uri.parse('${AppString.baseUrl}city');

        Response response = await http.post(url, headers: {
          'Content-Type': 'application/json',
          'Authorization': state.userModel.token
        });

        final decodedata = jsonDecode(response.body);

        if (decodedata['status'] == 200) {
          return {
            'error': decodedata['error'],
            'message': decodedata['message'],
            'data': decodedata['data']
          };
        } else {
          return {
            'error': decodedata['error'],
            'message': decodedata['message']
          };
        }
      } catch (e) {
        log('`repo` - catch error - fetch locationa  => ${e.toString()}   ');
        return {};
      }
    } else {
      return {};
    }
  }
}
