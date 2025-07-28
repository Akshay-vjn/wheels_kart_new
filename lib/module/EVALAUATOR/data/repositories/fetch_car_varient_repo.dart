import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/const/ev_api_const.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';

class FetchCarVarientRepo {
  static Future<Map<String, dynamic>> fetchCarVarient(
      BuildContext context, String makeId, String fueltype,String transmissiontype) async {
    final state = context.read<AppAuthController>().state;
    if (state is AuthCubitAuthenticateState) {
      try {
        final url = Uri.parse('${EvApiConst.baseUrl}${EvApiConst.fetchCarVarient}');

        Response response = await http.post(url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': state.userModel.token!
            },
            body: jsonEncode({
              "modelId": makeId,
              "fuel_type":fueltype, 
              "transmission_type": transmissiontype
            }));

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
        log('repo - catch error - fetch varients => ${e.toString()}   ');
        return {};
      }
    } else {
      return {};
    }
  }
}
