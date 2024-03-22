import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AccessTokenProvider extends ChangeNotifier {
  var res, refreshToken;
  accessToken() async {
    final pref = await SharedPreferences.getInstance();
    refreshToken = pref.getString('refreshToken');
    print(refreshToken);
    try {
      var apiUrl = 'https://api.sunmateio.dk/authentication/login';
      res = await http.get(
        Uri.parse(apiUrl),
        headers: {'authorization': "Bearer $refreshToken"},
      );
      print(res.statusCode);
      if (res.statusCode == 200) {
        print(res.body);
        var response = jsonDecode(res.body);
        await pref.setString('access_token', response['access_token']);
        await pref.setString('access_expire', response['payload']['exp']);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
