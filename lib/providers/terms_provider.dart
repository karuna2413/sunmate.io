import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/environment.dart';

class Terms extends ChangeNotifier {
  var response;
  terms() async {
    try {
      final apiUrl = '${Environment().config.apiHost}api/terms-and-conditions';

      response = await http.get(Uri.parse(apiUrl));
      var res = response.body;
      return res;
    } catch (e) {
      print(e.toString());
    }
  }
}
