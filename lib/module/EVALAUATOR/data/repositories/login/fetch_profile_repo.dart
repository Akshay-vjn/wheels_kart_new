
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/const/ev_api_const.dart';
class FetchFProfileDataRepos{

  static Future<Map<String, dynamic>> getProfileData(String token
    ) async {
   
      try {
        final url = Uri.parse('${EvApiConst.baseUrl}${EvApiConst.fetchProfile}');

        Response response = await http.post(url, headers: {
          'Content-Type': 'application/json',
          'Authorization': token
        });

        final decodedata = jsonDecode(response.body);

        if (decodedata['status'] == 200) {
          return {
            'error': decodedata['error'],
            'message': decodedata['message'],
            'data': decodedata['data']
          };
        } else {
          return {
            'error': decodedata['error'],
            'message': decodedata['message']
          };
        }
      } catch (e) {
        log('repo - catch error - fetch user profile data => ${e.toString()}   ');
        return {};
      }
    
  }
}