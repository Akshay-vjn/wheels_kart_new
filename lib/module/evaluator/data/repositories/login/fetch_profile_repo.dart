
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wheels_kart/core/constant/string.dart';
class FetchFProfileDataRepos{

  static Future<Map<String, dynamic>> getProfileData(String token
    ) async {
   
      try {
        final url = Uri.parse('${AppString.baseUrl}login/profile');

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