import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class EvVerifyOtpRepo {
  static Future<Map<String, dynamic>> verifyOtp(int userId, String otp) async {
    try {
      // final url = Uri.parse('${VApiConst.baseUrl}${VApiConst.vendorLogin}');
      final url = Uri.parse('https://app.crisant.com/api/login/verify');

      Response response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"otp": otp, "employeeId": userId}),
      );

      final decodedata = jsonDecode(response.body);

      if (decodedata['status'] == 200) {
        return {
          'error': decodedata['error'],
          'message': decodedata['message'],
          // 'token': decodedata['data']['token'],
          "token":
              "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJUaGVfY2xhaW0iLCJhdWQiOiJUaGVfQXVkIiwiaWF0IjoxNzU5NzQ2MDMwLCJleHAiOjE3NjMzNDYwMzAsImRhdGEiOnsidXNlcklkIjoiMyIsInVzZXJGdWxsTmFtZSI6IlN5ZWQgSXNodGl5YXEiLCJ1c2VyTW9iaWxlTnVtYmVyIjoiNzQ4MzUwMzA3MCIsInVzZXJUeXBlIjoiRVZBTFVBVE9SIiwidXNlclN0YXR1cyI6IkFDVElWRSIsImNyZWF0ZWRfYXQiOnsiZGF0ZSI6IjIwMjQtMTAtMTYgMTY6MDE6MjEuMDAwMDAwIiwidGltZXpvbmVfdHlwZSI6MywidGltZXpvbmUiOiJBc2lhL0tvbGthdGEifSwibW9kaWZpZWRfYXQiOiIyMDI0LTEwLTE2IDE2OjAxOjIxIn19.N49n4yVDpZQL-0A4JkwTOmkv4IzTI5QeDCf-3c0R2Zo",
        };
      } else {
        return {'error': decodedata['error'], 'message': decodedata['message']};
      }
    } catch (e) {
      log('repo - catch error - verify OTP Evaluator => ${e.toString()}   ');
      return {};
    }
  }
}
