// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:consult_24/bot_nav_components/update_profile/provider_personal_information.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
// import 'package:to_resolve/providers/call_api.dart';
// import 'package:to_resolve/widgets/more/payment_method.dart';
import '../bot_nav_components/update_profile/customer_personal_information.dart';

class CompleteProfileScreen extends StatefulWidget {
  // UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  var _isInit = true;
  var userId;
  var userRole;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      SharedPreferences successLogin = await SharedPreferences.getInstance();
      var loginIdJson = successLogin.getInt('loginId');
      var loginId = json.decode(json.encode(loginIdJson));

      var userRoleJson = successLogin.getInt('role');
      var userRoleId = json.decode(json.encode(userRoleJson));

      setState(() {
        userId = loginId;
        userRole = userRoleId;
      });
    }

    _isInit = false;
    super.didChangeDependencies();

    // var res = await CallApi().getData('/auth_api/customer_profile/${userId}');
    // var resBody = json.decode(res?.body);
    // print(resBody);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // print(userId);
    return Scaffold(
      appBar: AppBar(
          // leading: IconButton(
          //   icon: const Icon(Icons.arrow_back),
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          // ),
          ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            // height: 100.h,
            width: 100.w,
            padding: EdgeInsets.fromLTRB(
              5.w,
              5.w,
              5.w,
              5.w,
            ),
            color: Colors.grey[100],
            child: userRole == 2
                ? CustomerPersonalInformation()
                : userRole == 3
                    ? ProviderPersonalInformation()
                    : Container(
                        height: height * 0.240,
                        width: width * 0.500,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        margin: EdgeInsets.only(
                          top: height * 0.020,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.015,
                          vertical: height * 0.015,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              children: [
                                Text(
                                  'Please Login to continue',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.error),
                                ),
                                SizedBox(
                                  height: height * 0.010,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/loginScreen');
                                  },
                                  child: const Text('Login'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}
