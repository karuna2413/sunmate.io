import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmate/providers/auth_provider.dart';

import '../config/environment.dart';
import '../main.dart';

class GoogleVerificationProvider extends ChangeNotifier {
  var response, res, err, method;
  googleVerification(code, context) async {
    final pref = await SharedPreferences.getInstance();
    method = pref.getString('method');

    var token = Provider.of<AuthProvider>(context, listen: false).authToken;
    var apiUrl = '${Environment().config.apiHost}api/verification-mfa';

    response = await http.post(Uri.parse(apiUrl),
        headers: {'authorization': "Bearer $token"},
        body: {"auth_method": method, "one_time_password": code});

    res = jsonDecode(response.body);
    print(res);
    print(response.statusCode);
    if (response.statusCode == 200 && res['success'] == true) {
      await pref.setString('refresh_expire', res['token_Information']['exp']);
      await pref.setString('language', res['language']);
      await pref.setString('refreshToken', res['token']);
      await pref.setString('language', res['language']);
      MyApp.setLocale(context, Locale(res['language']));
      return res;
    } else {
      return res;
    }
  }

  resendOTP(context) async {
    final pref = await SharedPreferences.getInstance();
    method = pref.getString('method');

    var token = Provider.of<AuthProvider>(context, listen: false).authToken;
    var apiUrl = '${Environment().config.apiHost}api/resend-otp';

    response = await http.post(
      Uri.parse(apiUrl),
      headers: {'authorization': "Bearer $token"},
    );
    try {
      print(response.body);
      res = jsonDecode(response.body);
      print(res);
      print(response.statusCode);
      if (response.statusCode == 200 && res['success'] == true) {
        return res;
      } else {
        return res;
      }
    } catch (e) {
      return response;
    }
  }
}
