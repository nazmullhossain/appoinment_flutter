import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../models/call_api.dart';
import '../../reuse_similiar_code/form/address_info.dart';
import '../../reuse_similiar_code/form/personal_info.dart';
import '../../reuse_similiar_code/widgets/gender_selector.dart';
import '../../reuse_similiar_code/widgets/camera_use.dart';

class CustomerPersonalInformation extends StatefulWidget {
  // PersonalInformation({Key? key}) : super(key: key);

  @override
  State<CustomerPersonalInformation> createState() =>
      _CustomerPersonalInformationState();
}

class _CustomerPersonalInformationState
    extends State<CustomerPersonalInformation> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _middleName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

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

  String? _customerGendervalue;

  String? _selectedCountry;

  Future _update() async {
    setState(() {
      _isLoading = true;
    });
    if (_isLoading = true) {
      Timer.periodic(const Duration(milliseconds: 100), (timer) {
        // setState(() {
        //   // _initialTime = _initialTime + 0.25;
        //   _isLoading = false;
        // });
      });
    }

    await Future.delayed(const Duration(seconds: 5));

    var customerData = {
      "first_name": _firstName.text.toString(),
      "middle_name": _middleName.text.toString(),
      "last_name": _lastName.text.toString(),
      "phone_number": _phoneNumber.text.toString(),
      "gender": _customerGendervalue.toString(),
      "account_status": "Active",
      "online_status": "True",
      "activity_status": "True",
      "payment_to_method": "credit card",
      "payment_from_method": "credit card",
      "avg_rating": "0",
      "lifetime_service_count": "dfsdfsdf",
      "positive_review_id": "fsdfsdfsdf",
      "nagetive_review_id": "dfsdfsdfs",
      "street_address": _streetAddress.text.toString(),
      "apt": _apartmentAddress.text.toString(),
      "zip_code": _zipCode.text.toString(),
      "city": _cityName.text.toString(),
      "state": _stateName.text.toString(),
      "country": _selectedCountry.toString(),
    };

    try {
      var responseData = await CallApi().putData(
        customerData,
        '/auth_api/customer_profile/$userId',
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
          debugPrint('image posting: ${responseImg.statusCode}');
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
        debugPrint('account update: $error');
      }
    } catch (error) {
      debugPrint('2 $error');
    }
  }

  _getImage() async {
    try {
      var responseProfilePicture =
          await CallApi().getData('/auth_api/CustomerProfilePicture/');

      responseProfilePictureBody = json.decode(responseProfilePicture?.body);

      try {
        var picId = responseProfilePictureBody?[0]?['id'];
        var serverImageLink =
            responseProfilePictureBody?[0]?['profile_picture'];

        setState(() {
          proPicId = picId;
          serverImg = serverImageLink;
        });
        debugPrint('Image: ${responseProfilePicture.statusCode}');
      } catch (error) {
        debugPrint('Profile picture $error');
      }
    } catch (error) {
      debugPrint('4 $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // final textSize = MediaQuery.of(context).textScaleFactor;
    return userData == 'GuestUser'
        ? Container(
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
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                    SizedBox(
                      height: height * 0.010,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/loginScreen');
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
            ),
          )
        : serverImg == null && proPicId == null
            ? Container(
                height: height,
                width: width,
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
                      width: double.infinity,
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
                      child: Form(
                        key: _formKey,
                        child: Column(
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
                                GenderSelector(
                                    genderValue: _customerGendervalue),
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
                      height: height * 0.0010,
                    ),

                    // Address update
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(
                        top: 4.h,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
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
                      height: height * 0.020,
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
