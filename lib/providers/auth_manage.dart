import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/call_api.dart';

class AuthManage with ChangeNotifier {
  int? signId;
  String? signupName;
  String? secretKey;

  int? tokenStoreStatus;
  int? loginStatus;
  int? fetchStatus;

  String? loginToken;

  String? loginName;
  int? loginId;
  int? loginRole;
  String? loginEmail;

  // signup screen operation

  // signUp state
  Future signUp({
    @required String? userName,
    @required String? roleId,
    @required String? email,
    @required String? password,
    @required String? rePassword,
  }) async {
    final signupUrl = Uri.parse('https://c24apidev.accelx.net/auth_api/token/');

    var signUpData = {
      "username": userName,
      "role": roleId,
      "email": email,
      "password": password,
      "re_password": rePassword,
    };

    try {
      var responseSignUp = await http.post(
        signupUrl,
        body: jsonEncode(signUpData),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      var signUpBody = json.decode(responseSignUp.body);
      debugPrint('signup status: ${responseSignUp.statusCode}');
      if (responseSignUp.statusCode == 201) {
        signId = signUpBody?['id'];
        signupName = signUpBody?['username'];

        if (signupName != null) {
          videoSignUp(name: signupName);
        }
      }
    } catch (error) {
      debugPrint('Sign up error: $error');
    }

    notifyListeners();
  }

  //  login screen operation

  // login
  Future login({
    @required String? email,
    @required String? password,
  }) async {
    final loginApi =
        Uri.parse('https://c24apidev.accelx.net/auth/token/login/');

    var loginData = {
      "password": password,
      "email": email,
    };

    try {
      var loginResponse = await http.post(
        loginApi,
        body: jsonEncode({
          "email": email,
          'password': password
        }),
        headers: {'Content-Type': 'application/json'},
      );

      var loginBody = json.decode(loginResponse.body);

      loginStatus = loginResponse.statusCode;

      debugPrint('Login : ${loginResponse.statusCode}');

      if (loginResponse.statusCode == 200) {
        SharedPreferences successLogin = await SharedPreferences.getInstance();
        successLogin.setString('token', loginBody['auth_token']);

        var userToken = successLogin.getString('token');

        loginToken = json.decode(json.encode(userToken));

        if (loginToken != null) {
          debugPrint('$loginToken');
          fetchInfo();
        }
      }
      return loginResponse;
    } catch (error) {
      debugPrint('Login error: $error');
    }
    notifyListeners();
  }

  // fetch info
  Future fetchInfo() async {
    SharedPreferences successLogin = await SharedPreferences.getInstance();

    try {
      var fetchInfoResponse = await CallApi().getData('/auth/users/me/');

      var fetchInfoBody = json.decode(fetchInfoResponse.body);

      debugPrint('Fetch info: ${fetchInfoResponse.statusCode}');

      fetchStatus = fetchInfoResponse.statusCode;

      if (fetchInfoResponse.statusCode == 200) {
        loginRole = fetchInfoBody?['role'];
        loginId = fetchInfoBody?['id'];
        if (loginId != null) {
          getVideoToken(userId: loginId);
        }

        successLogin.setString(
            'loginName', fetchInfoBody['username'].toString());
        successLogin.setInt('loginId', fetchInfoBody['id']);
        successLogin.setString('email', fetchInfoBody['email']);
        successLogin.setInt('role', fetchInfoBody['role']);
        notifyListeners();
      }
    } catch (error) {
      debugPrint('fetch Info error: $error');
    }
    notifyListeners();
  }

// video id generate and token store

  // create video account
  Future videoSignUp({@required String? name}) async {
    final videoCallCreateApi =
        Uri.parse('https://c24apidev.accelx.net/videocall/create_account/');

    var videoCreateData = {
      'name': name,
      'label': '${name}_meet',
      'redirectURIs': ["https://c24apidev.accelx.net/"],
      "defaultRedirectURI": "https://c24apidev.accelx.net/",
    };

    try {
      var videoSignupResponse = await http.post(
        videoCallCreateApi,
        body: json.encode(videoCreateData),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      var resVideoBody = json.decode(videoSignupResponse.body);

      debugPrint('video sign up: ${videoSignupResponse.statusCode}');

      if (videoSignupResponse.statusCode == 200) {
        secretKey = resVideoBody?[0].split('"')[3];

        if (secretKey != null) {
          storeVideoToken(userId: signId, vidCalToken: secretKey);
        }
      }
    } catch (error) {
      debugPrint('Video signup error: $error');
    }
    notifyListeners();
  }

  // store video token
  Future storeVideoToken({
    @required int? userId,
    @required String? vidCalToken,
  }) async {
    final tokenStoreApi = Uri.parse(
        'https://c24apidev.accelx.net/api/VideoCallingTokenListCreateAPIView/');

    var _tokenStoreBody = {
      "token_store": vidCalToken.toString(),
      "user_video_call_account": userId,
    };

    try {
      var responseTokenStore = await http.post(
        tokenStoreApi,
        body: json.encode(_tokenStoreBody),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      tokenStoreStatus = responseTokenStore.statusCode;

      debugPrint('AuthToken Stored: $tokenStoreStatus');
    } catch (error) {
      debugPrint('Token Storing error: $error');
    }

    notifyListeners();
  }

  // video token get
  Future getVideoToken({@required int? userId}) async {
    final videoTokenApi =
        '/api/UserIDWiseVideoCallingTokenListAPIView/?user_id=${userId.toString()}';

    try {
      var responseToken = await CallApi().getData(videoTokenApi);

      var resBody = json.decode(responseToken.body);

      debugPrint('video token status: ${responseToken.statusCode}');

      if (responseToken.statusCode == 200) {
        SharedPreferences successLogin = await SharedPreferences.getInstance();
        successLogin.setString('videoCallToken', resBody?[0]?["token_store"]);
      }
    } catch (error) {
      debugPrint('Video Token error: $error');
    }
    notifyListeners();
  }
}
