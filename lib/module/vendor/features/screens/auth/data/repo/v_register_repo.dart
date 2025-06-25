import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wheels_kart/module/VENDOR/core/const/v_api_const.dart';

class VRegisterRepo {
  static Future<Map<String, dynamic>> registerVendor(
    String mobileNumber,
    String password,
    String name,
    String email,
    String city,
    String confirmPassword,
  ) async {
    try {
      final url = Uri.parse('${VApiConst.baseUrl}${VApiConst.vendorRegister}');

      Response response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "vendorName": name,
          "vendorMobileNumber": mobileNumber,
          "vendorPassword": password,
          "confirmPassword": confirmPassword,
          "vendorEmail": email,
          "vendorCity": city,
        }),
      );

      final decodedata = jsonDecode(response.body);

      if (decodedata['status'] == 200) {
        return {
          'error': decodedata['error'],
          'message': decodedata['messages'],
        };
      } else {
        return {
          'error': decodedata['error'],
          'message': "${decodedata['message']} ${decodedata['data']}",
        };
      }
    } catch (e) {
      log('repo - catch error - login user => ${e.toString()}   ');
      return {};
    }
  }
}
