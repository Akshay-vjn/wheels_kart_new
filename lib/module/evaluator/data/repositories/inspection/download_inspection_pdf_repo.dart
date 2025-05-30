import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:wheels_kart/core/constant/string.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/auth%20cubit/auth_cubit.dart';

class DownloadInspectionPdfRepo {
  //  static Future<Map<String, dynamic>> downloadPDF(
  //   BuildContext context,
  //   String inspectionId,
  // ) async {
  //   final state = context.read<EvAuthBlocCubit>().state;
  //   if (state is AuthCubitAuthenticateState) {
  //     try {
  //       final url = Uri.parse('${AppString.baseUrl}pdf');

  //       final response = await http.post(
  //         url,
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Authorization': state.userModel.token,
  //         },
  //         body: {
  //           "inspectionId":inspectionId
  //         },
  //       );

  //       final decodedata = jsonDecode(response.body);

  //       if (decodedata['status'] == 200) {
  //         return {
  //           'error': decodedata['error'],
  //           'message': decodedata['message'],
  //           'data': decodedata['data'],
  //         };
  //       } else {
  //         return {
  //           'error': decodedata['error'],
  //           'message': decodedata['message'].toString(),
  //         };
  //       }
  //     } catch (e) {
  //       log('repo - catch error - Dowloading PDF => ${e.toString()}   ');
  //       return {};
  //     }
  //   } else {
  //     return {};
  //   }
  // }

  static Future<Uint8List?> dowloadPDF(BuildContext context, String id) async {
    final state = context.read<EvAuthBlocCubit>().state;
    if (state is AuthCubitAuthenticateState) {
      try {
        final url = Uri.parse('${AppString.baseUrl}pdf');

        final reponse = await http.post(
          url,
          headers: {
            // 'Content-Type': 'application/json',
            'Authorization': state.userModel.token,
          },
          body: {"inspectionId": id},
        );

        if (reponse.statusCode == 200) {
          return reponse.bodyBytes;
        }else{
          log(reponse.body);
          return null;
        }
      } catch (e) {
         log(e.toString());
        return null;
       
      }
    }
  }
}
