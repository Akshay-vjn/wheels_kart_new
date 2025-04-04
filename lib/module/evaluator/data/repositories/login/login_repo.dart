import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wheels_kart/core/constant/string.dart';

class LoginRepo {
  static Future<Map<String, dynamic>> loginUserRepo(
      String mobileNumber, String password) async {
    try {
      final url = Uri.parse('${AppString.baseUrl}login');

      Response response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(
              {"userMobileNumber": mobileNumber, "userPassword": password}));

      final decodedata = jsonDecode(response.body);

      if (decodedata['status'] == 200) {
        log(decodedata['messages'].toString());
        return {
          'error': decodedata['error'],
          'message': decodedata['messages'],
          'token': decodedata['data']['token']
        };
      } else {
        log(decodedata['messages'].toString());

        return {
          'error': decodedata['error'],
          'message': decodedata['messages']
        };
      }
    } catch (e) {
        log('repo - catch error - login user => ${e.toString()}   ');
      return {};
    }
  }
}
