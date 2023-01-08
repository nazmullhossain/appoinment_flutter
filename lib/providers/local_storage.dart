import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalData with ChangeNotifier {
  int? userId;
  int? userRole;
  int? userPicId;

  bool? onlineStatus;

  String? userToken;
  String? userName;
  String? userEmail;
  String? userPicLink;
  String? videoCallToken;

  Future getLocalData() async {
    SharedPreferences successLogin = await SharedPreferences.getInstance();
    var logId = successLogin.getInt('loginId');
    var logRole = successLogin.getInt('role');
    var proPicId = successLogin.getInt('proPicId');
    var online = successLogin.getBool('online_status');
    var logToken = successLogin.getString('token');
    var logName = successLogin.getString('loginName');
    var logEmail = successLogin.getString('email');
    var proPicLink = successLogin.getString('proPicLink');
    var videoToken = successLogin.getString('videoCallToken');

    userId = json.decode(json.encode(logId));
    userRole = json.decode(json.encode(logRole));
    userPicId = json.decode(json.encode(proPicId));
    onlineStatus = json.decode(json.encode(online));
    userToken = json.decode(json.encode(logToken));
    userName = json.decode(json.encode(logName));
    userEmail = json.decode(json.encode(logEmail));
    userPicLink = json.decode(json.encode(proPicLink));
    videoCallToken = json.decode(json.encode(videoToken));

    notifyListeners();

    debugPrint('userId : $userId');
  }

  Future clearLocalData() async {
    SharedPreferences successLogin = await SharedPreferences.getInstance();
    successLogin.remove('token');
    successLogin.remove('loginName');
    successLogin.remove('email');
    successLogin.remove('role');
    successLogin.remove('online_status');
    successLogin.remove('loginId');
    successLogin.remove('proPicId');
    successLogin.remove('proPicLink');
    successLogin.remove('videoCallToken');

    notifyListeners();
  }
}
