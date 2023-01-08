import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class ProfileStatus extends StatefulWidget {
  @override
  State<ProfileStatus> createState() => _ProfileStatusState();
}

class _ProfileStatusState extends State<ProfileStatus> {
  var _isInit = true;
  late String userData = 'Guestuser';
  String? token;
  int? userId;

  @override
  void initState() {
    super.initState();
  }

  @override
  didChangeDependencies() async {
    if (_isInit) {
      SharedPreferences successLogin = await SharedPreferences.getInstance();
      var scsBody = successLogin.getString('loginName');
      var success = json.decode(json.encode(scsBody));

      var tokenJson = successLogin.getString('token');
      var tokenDecode = json.decode(json.encode(tokenJson));

      var userIdJson = successLogin.getInt('role');
      var userIdDecode = json.decode(json.encode(userIdJson));
      setState(() {
        token = tokenDecode;
        if (success != null) {
          userData = success;
        }
        userId = userIdDecode;
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  _logOut() async {
    final logOutApi =
        Uri.parse('https://c24apidev.accelx.net/auth/token/logout/');
    var responseLogout = await http.post(logOutApi, headers: {
      "Content-Type": 'Application/json',
      'Authorization': 'Token $token',
    });
    debugPrint('${responseLogout.statusCode}');

    // print(json.decode(responseLogout!.body));
  }

  // @override
  // void dispose() async {
  //   super.dispose();

  //   SharedPreferences successLogin = await SharedPreferences.getInstance();
  //   successLogin.remove('token');
  //   successLogin.remove('loginName');
  //   successLogin.remove('email');
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 9.h,
        width: 100.w,
        margin: EdgeInsets.symmetric(vertical: 2.h),
        padding: EdgeInsets.symmetric(
          horizontal: 4.w,
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  userId == 2
                      ? '/customerDetails'
                      : userId == 3
                          ? '/providerDetails'
                          : '/loginScreen',
                );
              },
              child: Container(
                height: 7.6.h,
                width: 18.w,
                child: Image.asset(
                  'assets/images/pro-pic.png',
                  fit: BoxFit.fill,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            SizedBox(
              width: 1.5.w,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  userData != null ? userData : 'Guestuser',
                  style: TextStyle(
                    fontSize: 2.h,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.01.w,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    _logOut();
                    SharedPreferences successLogin =
                        await SharedPreferences.getInstance();
                    successLogin.clear();
                    successLogin.remove('token');
                    successLogin.remove('loginName');
                    successLogin.remove('email');
                    successLogin.remove('role');
                    successLogin.remove('online_status');
                    successLogin.remove('loginId');
                    successLogin.remove('proPicId');
                    successLogin.remove('proPicLink');
                    successLogin.remove('videoCallToken');
                    Navigator.pushReplacementNamed(
                      context,
                      '/loginScreen',
                    );
                  },
                  child: userData != 'Guestuser'
                      ? const Text('Logout')
                      : const Text('Login'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
