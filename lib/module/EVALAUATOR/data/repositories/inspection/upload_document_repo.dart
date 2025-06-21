import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/const/ev_api_const.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/auth%20cubit/auth_cubit.dart';

class UploadDocumentRepo {
  static Future<Map<String, dynamic>> uploadDocument(
    BuildContext context,
    String insectionId,
    List<Map<String, dynamic>> documents,
    String numberOfOwners,
    String roadTaxPaid,
    String roadTaxValidityDate,
    String insuranceType,
    String insuranceValidityDate,
    String currentRto,
    String carLength,
    String cubicCapacity,
    String manufactureDate,
    String numberOfKeys,
    String regDate,
  ) async {
    final state = context.read<EvAuthBlocCubit>().state;
    if (state is AuthCubitAuthenticateState) {
      try {
        final url = Uri.parse('${EvApiConst.baseUrl}${EvApiConst.uploadDoc}');
        Object body;
        //

        body = jsonEncode({
          'inspectionId': insectionId,
          'documents': documents,
          "noOfOwners": numberOfOwners,
          "roadTaxPaid": roadTaxPaid,
          "roadTaxValidity": roadTaxValidityDate,

          'insuranceType': insuranceType,
          "insuranceValidity": insuranceValidityDate,
          "currentRto": currentRto,
          "carLength": carLength,
          "cubicCapacity": cubicCapacity,
          "manufactureDate": manufactureDate,
          "noOfKeys": numberOfKeys,
          "regDate": regDate,
        });

        log(body.toString());
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
          log(decodedata.toString());

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
          'repo - catch error - uploading inspectiobn  => ${e.toString()}   ',
        );
        return {};
      }
    } else {
      return {};
    }
  }
}
