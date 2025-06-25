import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:wheels_kart/module/EVALAUATOR/core/const/ev_api_const.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';

class DownloadInspectionPdfRepo {


  static Future<Uint8List?> dowloadPDF(BuildContext context, String id) async {
    final state = context.read<AppAuthController>().state;
    if (state is AuthCubitAuthenticateState) {
      try {
        final url = Uri.parse('${EvApiConst.baseUrl}${EvApiConst.dowloadinspectionPdf}');

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
    }else{
      return null;
    }
  }
}
