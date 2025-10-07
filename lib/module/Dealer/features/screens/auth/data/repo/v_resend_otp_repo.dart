import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_api_const.dart';

class VResendOtpRepo {
  static Future<Map<String, dynamic>> resendOTP(int userId) async {
    try {
      final url = Uri.parse('${VApiConst.baseUrl}${VApiConst.vendorResendOTP}');
      // final url = Uri.parse('https://app.crisant.com/api/login/resend');

      Response response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"vendorId": userId}),
      );

      final decodedata = jsonDecode(response.body);

      if (decodedata['status'] == 200) {
        return {'error': decodedata['error'], 'message': decodedata['message']};
      } else {
        return {'error': decodedata['error'], 'message': decodedata['message']};
      }
    } catch (e) {
      log('repo - catch error - verify OTP Evaluator => ${e.toString()}   ');
      return {};
    }
  }
}
