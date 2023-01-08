// built in packages
// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../providers/local_storage.dart';
import '../bot_nav_components/more/widget_column.dart';

// created other files
import '../bot_nav_components/more/profile_status.dart';

class MorePage extends StatefulWidget {
  MorePage({Key? key}) : super(key: key);

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<LocalData>(context, listen: false).getLocalData();
  }

  int? intRoleId;
  @override
  void didChangeDependencies() async {
    SharedPreferences successLogin = await SharedPreferences.getInstance();
    var role = successLogin.getInt('role');
    var roleId = json.decode(json.encode(role));

    if (roleId != null) {
      setState(() {
        intRoleId = roleId;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Widget rebuilding');
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 1.h,
              ),
              ProfileStatus(),
              SingleChildScrollView(
                child: Container(
                  width: 90.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    children: [
                      WidgetColumn(
                        prefixIcon: Icons.edit,
                        columnName: 'Edit or Update profile',
                        route: '/updateUserData',
                      ),
                      WidgetColumn(
                        prefixIcon: intRoleId == 2
                            ? Icons.search
                            : Icons.record_voice_over_outlined,
                        columnName: intRoleId == 2
                            ? 'Find a provider'
                            : intRoleId == 3
                                ? 'Create Services'
                                : 'Signup Here',
                        route: intRoleId == 2
                            ? '/providersList'
                            : intRoleId == 3
                                ? '/createServices'
                                : '/signupScreen',
                        // suffixIcon: FontAwesomeIcons.angleRight,
                      ),
                      WidgetColumn(
                        prefixIcon: Icons.person_pin_outlined,
                        columnName: 'Complete Profile',
                        route: '/completeProfileScreen',
                        // suffixIcon: FontAwesomeIcons.angleRight,
                      ),
                      WidgetColumn(
                        prefixIcon: Icons.payments_outlined,
                        columnName: 'Setup Payments',
                        route: intRoleId == 2
                            ? '/customerPaymentSetup'
                            : intRoleId == 3
                                ? '/providerPaymentSetup'
                                : '/',
                        // suffixIcon: FontAwesomeIcons.angleRight,
                      ),
                      WidgetColumn(
                        prefixIcon: intRoleId == 3
                            ? Icons.schedule_send_outlined
                            : Icons.person_add_alt_outlined,
                        columnName: intRoleId == 3
                            ? 'Create your schedule'
                            : 'Become a member',
                        route: intRoleId == 3
                            ? '/appointmentSchedule'
                            : '/becomeMember',
                        // suffixIcon: FontAwesomeIcons.angleRight,
                      ),
                      WidgetColumn(
                        prefixIcon: Icons.phone,
                        columnName: 'Contact us',
                        route: '/contactUs',
                        // suffixIcon: FontAwesomeIcons.angleRight,
                      ),
                      WidgetColumn(
                        prefixIcon: Icons.details_outlined,
                        columnName: 'About us',
                        route: '/aboutUs',
                        // suffixIcon: FontAwesomeIcons.angleRight,
                      ),
                      WidgetColumn(
                        prefixIcon: Icons.check_box_outlined,
                        columnName: 'Privacy policy',
                        route: '/privacyPolicy',
                        // suffixIcon: FontAwesomeIcons.angleRight,
                      ),
                      WidgetColumn(
                        prefixIcon: Icons.app_registration_rounded,
                        columnName: 'Terms & Conditions',
                        route: '/privacyPolicy',
                        // suffixIcon: FontAwesomeIcons.angleRight,
                      ),
                      InkWell(
                        onTap: () async {
                          String url = '';

                          try {
                            if (await canLaunchUrlString(url)) {
                              await launchUrlString(url);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('No website found'),
                                ),
                              );
                            }
                          } on Error {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No website found'),
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: 100.w,
                          height: 6.h,
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    Icons.web,
                                    size: MediaQuery.of(context).size.height *
                                        .023,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.03,
                                  ),
                                  Text(
                                    'website',
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: 2.3.h,
                                      letterSpacing: 0.01.w,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
