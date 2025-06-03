import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/const/ev_api_const.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/evaluation_data_model.dart';

class UpdateInspectionRepo {
  static Future<Map<String, dynamic>> updateInspection(
      BuildContext context,EvaluationDataEntryModel modeldata) async {
    final state = context.read<EvAuthBlocCubit>().state;
    if (state is AuthCubitAuthenticateState) {
      try {
        final url = Uri.parse('${EvApiConst.baseUrl}${EvApiConst.updateInspection}');
        Object body;
        //
        body = jsonEncode({
            "inspectionId": modeldata.inspectionId,
            "makeId":  modeldata.makeId,
            "manufacturingYear":  modeldata.makeYear,
            "modelId":  modeldata.modelId,
            "engineTypeId":  modeldata.engineTypeId,
            "fuel_type":  modeldata.fuelType,
            "transmission_type":  modeldata.transmissionType,
            "variantId":  modeldata.varientId,
            "regNo":  modeldata.vehicleRegNumber,
            "kmsDriven":  modeldata.totalKmsDriven,
            "cityId":  modeldata.locationID,

        });
        //
        Response response = await http.post(url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': state.userModel.token
            },
            body: body);

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
        log('repo - catch error - updating  inspections => ${e.toString()}   ');
        return {};
      }
    } else {
      return {};
    }
  }
}
