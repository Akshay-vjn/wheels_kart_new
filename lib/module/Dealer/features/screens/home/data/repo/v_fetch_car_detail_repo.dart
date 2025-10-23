import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_api_const.dart';

class VFetchCarDetailRepo {
  static Future<Map<String, dynamic>> onGetCarDetails(
      BuildContext context,
      String inspectionId,
      ) async {
    final state = context.read<AppAuthController>().state;
    if (state is AuthCubitAuthenticateState) {
      try {
        final url = Uri.parse('${VApiConst.baseUrl}${VApiConst.details}');

        print("🔍 Fetching inspection ID: $inspectionId");

        Response response = await http.post(
          url,
          body: {"inspectionId": inspectionId},
          headers: {
            'Authorization': state.userModel.token!,
          },
        );

        final decodedata = jsonDecode(response.body);

        // FRESH DEBUG
        print("\n🚀 === API RESPONSE FOR ID: $inspectionId ===");
        if (decodedata.containsKey('data')) {
          final data = decodedata['data'];
          print("✅ Data keys: ${data.keys.toList()}");
          print("🔑 Has paymentDetails: ${data.containsKey('paymentDetails')}");
          print("🔑 Has carDetails: ${data.containsKey('carDetails')}");
          
          if (data.containsKey('carDetails')) {
            final carDetails = data['carDetails'];
            print("🚗 CarDetails keys: ${carDetails.keys.toList()}");
            print("📝 Has inspection_remarks: ${carDetails.containsKey('inspection_remarks')}");
            if (carDetails.containsKey('inspection_remarks')) {
              print("📝 Inspection remarks: ${carDetails['inspection_remarks']}");
            }
          }

          if (data.containsKey('paymentDetails')) {
            print("💰 PaymentDetails found!");
            print("📄 Payment data: ${data['paymentDetails']}");
          } else {
            print("❌ NO paymentDetails in response");
          }
        }
        print("=== END API RESPONSE ===\n");

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
        log('repo - catch error - Dealer - DASHBOARD => ${e.toString()}F');
        return {};
      }
    } else {
      return {};
    }
  }
}