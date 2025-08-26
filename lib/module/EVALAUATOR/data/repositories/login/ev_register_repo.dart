import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/const/ev_api_const.dart';

class EvRegisterRepo {
  static Future<Map<String, dynamic>> registerEvaluator(
    String mobileNumber,
    String password,
    String confirmPassword,
    String name,
  ) async {
    try {
      final url = Uri.parse('${EvApiConst.baseUrl}${EvApiConst.register}');

      Response response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userMobileNumber": mobileNumber,
          "userPassword": password,
          "confirmPassword": confirmPassword,
          "userFullName": name,
        }),
      );

      final decodedata = jsonDecode(response.body);

      if (decodedata['status'] == 200) {
        log(decodedata['messages'].toString());
        return {
          'error': decodedata['error'],
          'message': decodedata['messages'],
          'token': decodedata['data']['token'],
        };
      } else {
        log(decodedata['messages'].toString());

        return {
          'error': decodedata['error'],
          'message': "${decodedata['message']},${decodedata['data']}",
        };
      }
    } catch (e) {
      log('repo - catch error - login user => ${e.toString()}   ');
      return {};
    }
  }
}
