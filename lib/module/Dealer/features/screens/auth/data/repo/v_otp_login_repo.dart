import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_api_const.dart';

class VOtpLoginRepo {
  static Future<Map<String, dynamic>> sendOtp(String mobileNumber) async {
    try {
      final url = Uri.parse('${VApiConst.baseUrl}${VApiConst.vendorLogin}');
      // final url = Uri.parse('https://app.crisant.com/api/login');

      Response response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"vendorMobileNumber": mobileNumber}),
      );

      final decodedata = jsonDecode(response.body);

      if (decodedata['status'] == 200) {
        return {
          'error': decodedata['error'],
          'message': decodedata['message'],
          'employeeId': decodedata['data']['vendorId'],
        };
      } else {
        return {'error': decodedata['error'], 'message': decodedata['message']};
      }
    } catch (e) {
      log('repo - catch error - login user => ${e.toString()}   ');
      return {};
    }
  }
}
