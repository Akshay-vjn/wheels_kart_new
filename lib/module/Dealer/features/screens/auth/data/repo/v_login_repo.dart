// import 'dart:convert';
// import 'dart:developer';

// import 'package:http/http.dart' as http;
// import 'package:http/http.dart';
// import 'package:wheels_kart/module/Dealer/core/const/v_api_const.dart';

// class VLoginRepo {
//   static Future<Map<String, dynamic>> loginVendor(
//     String mobileNumber,
//     String password,
//   ) async {
//     try {
//       final url = Uri.parse('${VApiConst.baseUrl}${VApiConst.vendorLogin}');

//       Response response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           "vendorMobileNumber": mobileNumber,
//           "vendorPassword": password,
//         }),
//       );

//       final decodedata = jsonDecode(response.body);

//       if (decodedata['status'] == 200) {
//         return {
//           'error': decodedata['error'],
//           'message': decodedata['messages'],
//           'token': decodedata['data']['token'],
//         };
//       } else {
//         return {
//           'error': decodedata['error'],
//           'message': decodedata['messages'],
//         };
//       }
//     } catch (e) {
//       log('repo - catch error - login user => ${e.toString()}   ');
//       return {};
//     }
//   }
// }
