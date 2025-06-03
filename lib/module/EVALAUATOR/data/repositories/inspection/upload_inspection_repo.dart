import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/const/ev_api_const.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/upload_inspection_model.dart';

class UploadInspectionRepo {
  static Future<Map<String, dynamic>> uploadInspection(
      BuildContext context, UploadInspectionModel uploadModel) async {
    final state = context.read<EvAuthBlocCubit>().state;
    if (state is AuthCubitAuthenticateState) {
      try {
        final url = Uri.parse('${EvApiConst.baseUrl}${EvApiConst.uploadInspection}');
        Object body;
        //
        body = jsonEncode(uploadModel.toJson());
        //
        Response response = await http.post(url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': state.userModel.token
            },
            body: body);

        final decodedata = jsonDecode(response.body);

        if (decodedata['status'] == 200) {
          log(decodedata.toString());

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
        log('repo - catch error - uploading inspectiobn  => ${e.toString()}   ');
        return {};
      }
    } else {
      return {};
    }
  }
}
