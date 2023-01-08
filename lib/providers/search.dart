import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/call_api.dart';

class SearchHelper with ChangeNotifier {
  int? userRole;
  int? loginId;

  getLocalStorageData() async {
    SharedPreferences successLogin = await SharedPreferences.getInstance();
    var roleJson = successLogin.getInt('role');
    userRole = json.decode(json.encode(roleJson));

    var logId = successLogin.getInt('loginId');
    loginId = json.decode(json.encode(logId));

    if (loginId != null) {
      getUserZip(userId: loginId);
    }

    notifyListeners();
  }

  var allSuggestions = [];

  var zipCode;

  // get all keyword
  getAllKeyword() async {
    final keywordApi = Uri.parse('https://c24apidev.accelx'
        '.net/api/servicekeywordlistAPI_View/');

    try {
      var responseKeyword = await http.get(keywordApi);

      var keyWordBody = json.decode(responseKeyword.body);

      // debugPrint(keyWordBody?['service_keyword_list']);

      if (responseKeyword.statusCode == 200) {
        allSuggestions = keyWordBody?['service_keyword_list'];
        debugPrint('$allSuggestions');
      }
    } catch (error) {
      debugPrint('Keyword list get error: $error');
    }

    notifyListeners();
  }

  // get user zip if available
  getUserZip({@required int? userId}) async {
    try {
      var responseZip = await CallApi().getData(
          '/auth_api/UserIDWiseAddressZipCodeAPIView/?user_id=$userId');

      debugPrint('user id:${responseZip.statusCode}');

      var responseZipBody = json.decode(responseZip.body);

      if (responseZip.statusCode == 200) {
        zipCode = responseZipBody?[0]?['zip_code'];
      }
    } catch (error) {
      debugPrint('Getting error on userID: $error');
    }

    notifyListeners();
  }
}
