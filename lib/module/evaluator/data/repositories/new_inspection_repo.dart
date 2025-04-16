import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wheels_kart/core/constant/string.dart';
import 'package:wheels_kart/module/evaluator/data/cubit/auth%20cubit/auth_cubit.dart';

class NewInspectionRepo {
  static Future<Map<String, dynamic>> createInspection(
    BuildContext context,
    String name,
    String numbers,
    String address,
    String email,
    int cityId,
  ) async {
    final state = context.read<EvAuthBlocCubit>().state;
    if (state is AuthCubitAuthenticateState) {
      try {
        final url = Uri.parse('${AppString.baseUrl}inspections/create');
        Object body;
        //
        body = jsonEncode({
          "customerName": name,
          "customerMobileNumber": numbers,
          "customerEmailAddress": email,
          "customerAddress": address,
          "cityId": cityId,
        });
        //
        Response response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': state.userModel.token,
          },
          body: body,
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
            'message': decodedata['message'].toString(),
          };
        }
      } catch (e) {
        log('repo - catch error - updating  inspections => ${e.toString()}   ');
        return {};
      }
    } else {
      return {};
    }
  }
}
