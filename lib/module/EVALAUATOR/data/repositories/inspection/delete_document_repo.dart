import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/const/ev_api_const.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';

class DeleteDocumentRepo {
  static Future<Map<String, dynamic>> deleteDocument(
    BuildContext context,
    String inspectionId,
    String inspectionDocumentId,
  ) async {
    final state = context.read<AppAuthController>().state;
    if (state is AuthCubitAuthenticateState) {
      try {
        final url = Uri.parse('${EvApiConst.baseUrl}${EvApiConst.deleteDoc}');

        Response response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': state.userModel.token!!!,
          },
          body: jsonEncode({
            "inspectionId": inspectionId,
            "inspectionDocumentId": inspectionDocumentId,
          }),
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
        log('repo - catch error - fetch car inspections => ${e.toString()}   ');
        return {};
      }
    } else {
      return {};
    }
  }
}
