import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:wheels_kart/core/constant/string.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/auth%20cubit/auth_cubit.dart';

class UpdateInspectionStatusToCompleted {
  static Future<Map<String, dynamic>> updateInspectionStatusToCompleted(
    BuildContext context,
    String inspectionId,
  ) async {
    
    final state = context.read<EvAuthBlocCubit>().state;
    if (state is AuthCubitAuthenticateState) {
      try {
        final url = Uri.parse(
          '${AppString.baseUrl}inspections/changestatus',
        );

        //
        final response = await http.post(
          url,
          headers: {
            // 'Content-Type':'application/json',
            'Authorization': state.userModel.token,
          },
          body: {"inspectionId": inspectionId},
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
        log('repo - catch error - updating  inspections => ${e.toString()}   ');
        return {};
      }
    } else {
      return {};
    }
  }
}
