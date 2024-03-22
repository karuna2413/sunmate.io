import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/environment.dart';
import '../models/login.dart';
import '../models/register.dart';

class AuthProvider extends ChangeNotifier {
  bool isLogin = false;
  bool logged = false;
  var error;
  var accessToken;
  int? expireTime;
  var refreshToken;
  UserLogin? _loginModel;
  var response;
  UserLogin? get loginModel => _loginModel;
  var token;
  var method;
  var otp;
  var name, email;
  var lan;
  void updateLanguage() async {
    final pref = await SharedPreferences.getInstance();
    lan = pref.getString('language') ?? "en";
    notifyListeners();
  }

  void updateLoginModel(UserLogin newLoginModel) {
    _loginModel = newLoginModel;
    notifyListeners();
  }

  login(check) async {
    final storage = new FlutterSecureStorage();

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_loginModel != null) {
      final apiUrl = '${Environment().config.apiHost}api/login';

      response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(_loginModel!.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        if (check == true) {
          await prefs.setBool('check', check);

          await storage.write(key: 'email', value: _loginModel?.email);
          await storage.write(key: 'password', value: _loginModel?.password);
        } else {
          await prefs.setBool('check', false);
        }

        await prefs.setString('user', jsonEncode(responseData));
        if (responseData['auth_method'] != null) {
          method = responseData['auth_method'];
          print('------------method$method');
          await prefs.setString('method', method);
        }
        String? userPref = prefs.getString('user');
        if (responseData['otp'] != null) {
          otp = responseData['otp'].toString();
          await prefs.setString('otp', otp);
        }

        print(responseData);

        if (method == 'none') {
          if (responseData['token_Information'] != null &&
              responseData['language'] != null &&
              responseData['token'] != null) {
            await prefs.setString(
                'refresh_expire', responseData['token_Information']['exp']);
            print('methodnonblock');
            await prefs.setString('language', responseData['language']);
            await prefs.setString('refreshToken', responseData['token']);
            print('refreshlogin${responseData['token']}');
          }
        } else if (responseData['token'] != null) {
          accessToken = responseData['token'];
          setAuthToken(accessToken);
        }
        print('ress$responseData');

        return response;
      } else {
        return response;
      }
    }
  }

  Future registerUser(UserRegistration user) async {
    String url = '${Environment().config.apiHost}api/register';
    final response = await http.post(Uri.parse(url), body: {
      "name": user.name,
      "email": user.email,
      "password": user.password,
      "terms": user.terms.toString(),
      "lang": user.lang,
      "zipcode": user.zipcode
    }, headers: {
      'authorization': "Bearer ${Environment.registerKey}"
    });
    print(response.body);
    if (response.statusCode == 201) {
      var responseData = json.decode(response.body);

      return response;
    } else {
      return response;
    }
  }

  logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('refreshToken');
    prefs.remove('access_token');
    prefs.remove('check');
  }

  String? _authToken;

  String? get authToken => _authToken;

  setAuthToken(token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // _authToken = token;
    print('auth$_authToken');
    if (token == null) {
      _authToken = null;
    } else {
      await prefs.setString('token', accessToken);
      _authToken = prefs.getString('token');
    }
    print('getauth$_authToken');

    notifyListeners();
  }
}
