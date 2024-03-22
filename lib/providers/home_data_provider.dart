import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmate/config/environment.dart';
import 'package:sunmate/providers/access_token_provider.dart';

class HomeDataProvider extends ChangeNotifier {
  var error;
  var loader = false;
  var response;
  var token;
  var res;

  homeData(context) async {
    final pref = await SharedPreferences.getInstance();
    var expireTime = pref.getString('access_expire');
    if (expireTime != null) {
      DateFormat format = DateFormat('EEE, dd MMM yyyy HH:mm:ss \'GMT\'');
      DateTime expirationTime = format.parse(expireTime!);

      bool isTokenExpired = expirationTime.isBefore(DateTime.now());

      if (isTokenExpired) {
        await AccessTokenProvider().accessToken();
      }
    }

    token = pref.getString('access_token');

    try {
      var apiUrl = '${Environment().config.apiLiveHost}';
      loader = true;
      notifyListeners();
      response = await http.get(
        Uri.parse(apiUrl),
        headers: {'authorization': "Bearer $token"},
      );
      loader = false;
      notifyListeners();

      if (response.statusCode == 200) {
        res = jsonDecode(response.body);
        print(res);
        print('===========${res['current_status']['status']}');
        print('------------${res['other_information']}');
        notifyListeners();
      } else if (response.statusCode == 401) {
        await AccessTokenProvider().accessToken(); // Refresh token
        // Retry the request with the new token
        response = await http.get(
          Uri.parse(apiUrl),
          headers: {'authorization': "Bearer $token"},
        );

        if (response.statusCode == 200) {
          // If the request is successful after token refresh, update response
          res = jsonDecode(response.body);

          notifyListeners();
        } else {
          // If the request still fails, set error message accordingly
          error = 'Failed to fetch data: ${response.statusCode}';
          notifyListeners();
        }
      } else {
        // For other status codes, set error message accordingly
        error = 'Failed to fetch data: ${response.statusCode}';
        notifyListeners();
      }
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }
}
