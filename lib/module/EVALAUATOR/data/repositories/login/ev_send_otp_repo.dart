import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/const/ev_api_const.dart';

class EvSendOtpRepo {
  static Future<Map<String, dynamic>> sendOtp(String mobileNumber) async {
    try {
      // final url = Uri.parse('${EvApiConst.baseUrl}${EvApiConst.login}');
      final url = Uri.parse("https://app.crisant.com/api/login");

      Response response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"mobileNumber": mobileNumber}),
      );

      final decodedata = jsonDecode(response.body);

      if (decodedata['status'] == 200) {
        log(decodedata['messages'].toString());
        return {
          'error': decodedata['error'],
          'message': decodedata['message'],
          'employeeId': decodedata['data']['employeeId'],
        };
      } else {
        log(decodedata['messages'].toString());

        return {'error': decodedata['error'], 'message': decodedata['message']};
      }
    } catch (e) {
      log('repo - catch error - login user => ${e.toString()}   ');
      return {};
    }
  }
}
