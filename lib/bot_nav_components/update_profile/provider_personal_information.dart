import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:consult_24/reuse_similiar_code/form/address_info.dart';
import 'package:consult_24/reuse_similiar_code/form/personal_info.dart';
import 'package:consult_24/reuse_similiar_code/form/business_info.dart';
import 'package:consult_24/reuse_similiar_code/widgets/gender_selector.dart';
import 'package:consult_24/reuse_similiar_code/widgets/camera_use.dart';
// import 'package:consult_24/reuse_similiar_code/widgets/dropdown_menu.dart';
// import 'package:consult_24/reuse_similiar_code/widgets/date_picker.dart';
// import 'package:consult_24/reuse_similiar_code/widgets/text_input_field.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart' as dio;
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http_parser/http_parser.dart';
// import 'package:http/http.dart' as http;

import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../models/call_api.dart';

class ProviderPersonalInformation extends StatefulWidget {
  // PersonalInformation({Key? key}) : super(key: key);

  @override
  State<ProviderPersonalInformation> createState() =>
      _ProviderPersonalInformationState();
}

class _ProviderPersonalInformationState
    extends State<ProviderPersonalInformation> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _middleName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final TextEditingController _businessGoal = TextEditingController();
  final TextEditingController _spentMoney = TextEditingController();
  final TextEditingController _numberOfEmployees = TextEditingController();
  final TextEditingController _foundingYear = TextEditingController();
  final TextEditingController _experienceLevel = TextEditingController();
  final TextEditingController _companyName = TextEditingController();
  final TextEditingController _socialMediaLink = TextEditingController();
  final TextEditingController _websiteLink = TextEditingController();

  final TextEditingController _streetAddress = TextEditingController();
  final TextEditingController _apartmentAddress = TextEditingController();
  final TextEditingController _zipCode = TextEditingController();
  final TextEditingController _cityName = TextEditingController();
  final TextEditingController _stateName = TextEditingController();

  var _isInit = true;
  late String userData = '';
  late String userEmail = '';
  late int userId;
  late String userToken;
  File? imgLink;

  // double _initialTime = 0.0;
  DateTime? date;
  int? userImg;
  int? proPicId;
  String? serverImg;

  var responseProfilePictureBody;

  @override
  void initState() {
    _dateController.text = '';
    super.initState();
  }

  @override
  didChangeDependencies() async {
    if (_isInit) {
      SharedPreferences successLogin = await SharedPreferences.getInstance();
      var userName = successLogin.getString('loginName');
      var successUserName = json.decode(json.encode(userName));

      var email = successLogin.getString('email');
      var successUserEmail = json.decode(json.encode(email));

      var logId = successLogin.getInt('loginId');
      var loginId = json.decode(json.encode(logId));

      var logToken = successLogin.getString('token');
      var loginToken = json.decode(json.encode(logToken));
      setState(() {
        if (successUserName != null) {
          userData = successUserName;
          _userName.text = userData;
          userId = loginId;
          userToken = loginToken;
          // _dateController.minTime = getText();
        } else {
          userData = 'GuestUser';
        }
      });
      setState(() {
        if (successUserEmail != null) {
          userEmail = successUserEmail;
          _emailController.text = userEmail;
        }
      });
      setState(() {
        userId = loginId;
        // print(userId);
        // print(userId.runtimeType);
      });
    }

    _isInit = false;
    _getImage();
    super.didChangeDependencies();
  }

  var _isLoading = false;

  String? _providerGendervalue;

  final List providerGender = ['Male', 'Female', 'Other'];

  String? _selectedCountry;

  // final _batchLevel = ['Beginner', 'Intermediate', 'Expert'];
  String? _selectedBatchLevel;

  Future _update() async {
    setState(() {
      _isLoading = true;
    });
    if (_isLoading = true) {
      Timer.periodic(const Duration(milliseconds: 100), (timer) {
        // setState(() {
        //   _initialTime = _initialTime + 0.25;
        //   _isLoading = false;
        // });
      });
    }

    await Future.delayed(const Duration(seconds: 5));

    var providerData = {
      "first_name": _firstName.text.toString(),
      "middle_name": _middleName.text.toString(),
      "last_name": _lastName.text.toString(),
      "phone_number": _phoneNumber.text.toString(),
      "gender": _providerGendervalue.toString(),
      "account_status": "Active",
      "online_status": "False",
      "activity_status": "False",
      "payment_to_method": "sdfsdfsdf",
      "payment_from_method": "sdfsdfsdf",
      "businees_goal": _businessGoal.text.toString(),
      "spent_money_in_business": _spentMoney.text.toString(),
      "number_of_employees": _numberOfEmployees.text.toString(),
      "founding_year": _foundingYear.text.toString(),
      "experience_level": _experienceLevel.text.toString(),
      "company_name": _companyName.text.toString(),
      "social_media_link": _socialMediaLink.text.toString(),
      "website_url": _websiteLink.text.toString(),
      "batch_level": _selectedBatchLevel.toString(),
      "avg_res_time": "null",
      "avg_rating": "0",
      "lifetime_service_count": "null",
      "positive_review_id": "null",
      "nagetive_review_id": "null",
      "street_address": _streetAddress.text.toString(),
      "apt": _apartmentAddress.text.toString(),
      "zip_code": _zipCode.text.toString(),
      "city": _cityName.text.toString(),
      "state": _stateName.text.toString(),
      "country": _selectedCountry.toString(),
    };

    debugPrint('Provider info : $providerData');

    try {
      var responseData = await CallApi().putData(
        providerData,
        '/auth_api/provider_profile/$userId',
      );

      try {
        if (serverImg != null) {
          // =====================================================================

          // code for patch image

          // =====================================================================

          // creating instance
          var dioRequest = dio.Dio();
          dioRequest.options.baseUrl =
              'https://c24apidev.accelx.net/auth_api/profile_picture/';

          // adding token
          dioRequest.options.headers = {
            'Authorization': 'Token ' '$userToken',
            'Content-Type': 'application/x-www-form-urlencoded'
          };

          // adding extra info
          var formData = dio.FormData.fromMap({
            'uploaded_user': userId,
          });

          // add image to upload
          var file = await dio.MultipartFile.fromFile(imgLink!.path,
              filename: basename(imgLink!.path),
              contentType: MediaType('image', basename(imgLink!.path)));

          formData.files.add(MapEntry('profile_picture', file));

          // send to server
          var responseImg = await dioRequest.patch(
            'https://c24apidev.accelx.net/auth_api/profile_picture/$proPicId',
            data: formData,
          );
          debugPrint('${responseImg.statusCode}');
        } else {
          // =====================================================================

          // code for post image

          // =====================================================================

          // creating instance
          var dioRequest = dio.Dio();
          dioRequest.options.baseUrl =
              'https://c24apidev.accelx.net/auth_api/profile_picture/';

          // adding token
          dioRequest.options.headers = {
            'Authorization': 'Token ' '$userToken',
            'Content-Type': 'application/x-www-form-urlencoded'
          };

          // adding extra info
          var formData = dio.FormData.fromMap({
            'uploaded_user': userId,
          });

          // add image to upload
          var file = await dio.MultipartFile.fromFile(imgLink!.path,
              filename: basename(imgLink!.path),
              contentType: MediaType('image', basename(imgLink!.path)));

          formData.files.add(MapEntry('profile_picture', file));

          // send to server
          var responseImg = await dioRequest.post(
            'https://c24apidev.accelx.net/auth_api/profile_picture/',
            data: formData,
          );

          if (responseData.statusCode == 201 && responseImg.statusCode == 201) {
            (BuildContext context) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account update successful.'),
                ),
              );
              setState(() {
                _isLoading = false;
                Navigator.pushReplacementNamed(context, '/profilePage');
              });
            };
          } else {
            setState(() {
              _isLoading = false;
            });
            (BuildContext context) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account update has failed.'),
                ),
              );
            };
          }
        }
      } catch (error) {
        debugPrint('This is camera error: $error');
      }

      // print(json.decode(responseImg.toString()));
      // print(responseImg.statusCode);
    } catch (error) {
      debugPrint('This is provider data error: $error');
    }
  }

  _getImage() async {
    try {
      var responseProfilePicture =
          await CallApi().getData('/auth_api/ServiceProviderProfilePicture/');

      responseProfilePictureBody = json.decode(responseProfilePicture?.body);

      try {
        var picId = responseProfilePictureBody?[0]?['id'];
        var serverImageLink =
            responseProfilePictureBody?[0]?['profile_picture'];

        setState(() {
          proPicId = picId;
          serverImg = serverImageLink;
        });
        debugPrint('${responseProfilePicture.statusCode}');
      } catch (error) {
        debugPrint('image getting $error');
      }
    } catch (error) {
      debugPrint('image getting $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // final textSize = MediaQuery.of(context).textScaleFactor;
    return serverImg == null && proPicId == null
        ? Container(
            height: 100.h,
            width: 100.w,
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          )
        : SizedBox(
            child: Column(
              children: [
                Container(
                  // height: 100.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.only(
                    top: 2.h,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 1.5.w,
                    vertical: 1.5.h,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 2.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Text(
                            'Personal Information :',
                            style: TextStyle(
                              fontSize: 2.5.h,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.05.w,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GenderSelector(genderValue: _providerGendervalue),
                            CameraUse(
                              buttonName: 'Upload',
                              imgLink: imgLink,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        ProfileInformation(
                          firstName: _firstName,
                          middleName: _middleName,
                          lastName: _lastName,
                          userName: _userName,
                          phoneNumber: _phoneNumber,
                          emailController: _emailController,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),

                // company update
                Container(
                  width: 100.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.only(
                    top: 4.h,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 1.5.w,
                    vertical: 3.h,
                  ),
                  child: BusinessInformation(
                    businessGoal: _businessGoal,
                    spentMoney: _spentMoney,
                    numberOfEmployees: _numberOfEmployees,
                    companyName: _companyName,
                    foundingYear: _foundingYear,
                    socialMediaLink: _socialMediaLink,
                    websiteLink: _websiteLink,
                  ),
                ),

                SizedBox(
                  height: height * 0.0010,
                ),
                // Address update
                Container(
                  width: 100.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.only(
                    top: 4.h,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 1.5.w,
                    vertical: 3.h,
                  ),
                  child: AddressInformation(
                    selectedCountry: _selectedCountry,
                    stateName: _stateName,
                    zipCode: _zipCode,
                    cityName: _cityName,
                    streetAddress: _streetAddress,
                    apartmentAddress: _apartmentAddress,
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                _isLoading == true
                    ? CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                        backgroundColor: Colors.grey[100],
                      )
                    : ElevatedButton(
                        onPressed: _update,
                        // onPressed: (() => {
                        //       _update(),
                        //
                        //     }),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.035,
                          ),
                          child: Text(
                            'Update',
                            style: TextStyle(
                              letterSpacing: width * 0.00001,
                            ),
                          ),
                        ),
                      )
              ],
            ),
          );
  }
}
