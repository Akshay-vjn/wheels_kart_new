import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_api_const.dart';

class VFetchOwnedCarDetailRepo {
  static Future<Map<String, dynamic>> onGetOwnedCarDetails(
    BuildContext context,
    String inspectionId,
  ) async {
    final state = context.read<AppAuthController>().state;
    if (state is AuthCubitAuthenticateState) {
      try {
        final url = Uri.parse('${VApiConst.baseUrl}${VApiConst.ownedDetails}');

        Response response = await http.post(
          url,
          body: {"inspectionId": inspectionId},
          headers: {
            // 'Content-Type': 'application/json',
            'Authorization': state.userModel.token!,
          },
        );

        final decodedata = jsonDecode(response.body);

        // DEBUG: Check for inspection_remarks in owned car details
        print("\n🚀 === OWNED CAR API RESPONSE FOR ID: $inspectionId ===");
        if (decodedata.containsKey('data')) {
          final data = decodedata['data'];
          print("✅ Data keys: ${data.keys.toList()}");
          print("🔑 Has carDetails: ${data.containsKey('carDetails')}");
          print("🔑 Has inspection_remarks at root: ${data.containsKey('inspection_remarks')}");
          
          if (data.containsKey('carDetails')) {
            final carDetails = data['carDetails'];
            print("🚗 CarDetails keys: ${carDetails.keys.toList()}");
            print("📝 Has inspection_remarks: ${carDetails.containsKey('inspection_remarks')}");
            if (carDetails.containsKey('inspection_remarks')) {
              print("📝 Inspection remarks: ${carDetails['inspection_remarks']}");
            }
          }
          
          if (data.containsKey('inspection_remarks')) {
            print("📝 Root level inspection_remarks: ${data['inspection_remarks']}");
          }
        }
        print("=== END OWNED CAR API RESPONSE ===\n");

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
        log('repo - catch error - Dealer - OWNED DETAILS => ${e.toString()}');
        return {};
      }
    } else {
      return {};
    }
  }
}
