import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_api_const.dart';

class VVerifyOtpRepo {
  static Future<Map<String, dynamic>> verifyOtp(int userId, String otp) async {
    try {
      final url = Uri.parse('${VApiConst.baseUrl}${VApiConst.vendorVerifyOTP}');
      // final url = Uri.parse('https://app.crisant.com/api/login/verify');

      Response response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"otp": otp, "vendorId": userId}),
      );

      final decodedata = jsonDecode(response.body);

      if (decodedata['status'] == 200) {
        return {
          'error': decodedata['error'],
          'message': decodedata['message'],
          'token': decodedata['data']['token'],
          // "token":
          //     "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJUaGVfY2xhaW0iLCJhdWQiOiJUaGVfQXVkIiwiaWF0IjoxNzU5NzQzMDEzLCJleHAiOjE3NjMzNDMwMTMsImRhdGEiOnsidmVuZG9ySWQiOiIyMCIsImJpZGRlcklkIjpudWxsLCJ2ZW5kb3JOYW1lIjoiQWtiYXIiLCJ2ZW5kb3JNb2JpbGVOdW1iZXIiOiI5ODQ2NDc1ODU0IiwidmVuZG9yRW1haWwiOiJha2JhckBnbWFpbC5jb20iLCJ2ZW5kb3JDaXR5IjoiTWFsYXBwdXJhbSIsInZlbmRvclN0YXR1cyI6IkFDVElWRSIsInZlbmRvck5vdGlmaWNhdGlvblRva2VuIjoiY0VrYmc2ZFRORWtBb3JfSDZiOFpqQzpBUEE5MWJISjlhbDdJNjZhcGpBaFhzQXUtZ0l2VWVvMnFpZDJESVFPczFLakVva25LeVVNMFpSelhVeEVoTU80VnpkSU53Z0NWQUxjNHdNcGFfblh6cE1ERmJId3QxMzFidnJLOXZ6SWkwcGc5V1pyMTljR0o0TSIsImNyZWF0ZWRfYXQiOnsiZGF0ZSI6IjIwMjUtMDktMDIgMTk6NTc6MTEuMDAwMDAwIiwidGltZXpvbmVfdHlwZSI6MywidGltZXpvbmUiOiJBc2lhL0tvbGthdGEifSwibW9kaWZpZWRfYXQiOiIyMDI1LTEwLTA2IDEyOjEzOjIyIn19.EgPXs9t_yvnPWOfOqdWlCjzyuNEDYK-_PmO_D8oqU_w",
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
