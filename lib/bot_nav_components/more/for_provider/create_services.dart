import 'dart:async';
import 'dart:convert';

import 'package:consult_24/models/call_api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class CreateServices extends StatefulWidget {
  CreateServices({Key? key}) : super(key: key);

  @override
  State<CreateServices> createState() => _CreateServicesState();
}

class _CreateServicesState extends State<CreateServices> {
  bool _isLoading = true;

  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _serviceName = TextEditingController();
  final TextEditingController _serviceDescription = TextEditingController();
  final TextEditingController _serviceKeywordList = TextEditingController();
  final TextEditingController _serviceExperience = TextEditingController();
  // final TextEditingController _serviceCertification = TextEditingController();
  final TextEditingController _rateAptVideo = TextEditingController();
  final TextEditingController _rateInstVideo = TextEditingController();
  final TextEditingController _rateInHouse = TextEditingController();
  final TextEditingController _ratePromotion = TextEditingController();
  final _serviceStatus = true;
  final _serviceVisibility = true;

  var categories = {};
  var categoryName = [];
  var categoryId = [];

  var subCategories = {};
  var subCategoryName = [];
  var subCategoryId = [];

  String? userToken;
  String? _selectedCategory;
  String? _selectedSubCategory;

  int? providerId;
  String? zipCode;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2000), () {
      setState(() {
        _isLoading = false;
      });
    });
    _getCategoryList();
  }

  @override
  void didChangeDependencies() async {
    SharedPreferences successLogin = await SharedPreferences.getInstance();

    var logId = successLogin.getInt('loginId');
    var loginId = json.decode(json.encode(logId));

    setState(() {
      providerId = loginId;
    });

    _getZip();
    super.didChangeDependencies();
  }

  // get zip code
  _getZip() async {
    try {
      var responseProviderData =
          await CallApi().getData('/auth_api/provider_profile/$providerId');

      var providerDataBody = json.decode(responseProviderData.body);

      if (responseProviderData.statusCode == 200) {
        setState(() {
          zipCode = providerDataBody?['address']?[0]?['zip_code'];
          print(zipCode);
        });
      }
    } catch (error) {
      print('get zip error: $error');
    }
  }

// get categories ID
  _getCategoryList() async {
    try {
      var categoryResponse = await CallApi().getData('/api/service_category/');

      print('Category response = ${categoryResponse.statusCode}');

      var categoryResponseBody = json.decode(categoryResponse.body);

      if (categoryResponse.statusCode == 200) {
        for (int i = 0; i < categoryResponseBody.length; i++) {
          categoryName.add(categoryResponseBody[i]?['category_name']);
          categoryId.add(categoryResponseBody[i]?['id']);
        }

        setState(() {
          if (_selectedCategory != null) {
            _getSubCategories();
          }
          categories = Map.fromIterables(categoryName, categoryId);
          // categories = (categoryName, categoryId) => {
          //       for (var i = 0; i < categoryName.length; i++)
          //         {Map.fromIterables(categoryName, categoryId)}
          //     };
        });
      }
    } catch (error) {
      print('get cat error: $error');
    }
  }

// get subcategories list
  _getSubCategories() async {
    print(categories[_selectedCategory]);
    try {
      var subCategoryResponse = await CallApi().getData(
          '/api/CategoryWiseSubCategoryAPIView/?category_id=${categories[_selectedCategory]}');

      print('Sub category response = ${subCategoryResponse.statusCode}');

      var subCategoryResponseBody = json.decode(subCategoryResponse.body);

      print(subCategoryResponseBody);

      if (subCategoryResponse.statusCode == 200) {
        setState(() {
          subCategoryName = [];
          subCategoryId = [];
        });
        for (int i = 0; i < subCategoryResponseBody.length; i++) {
          subCategoryName
              .add(subCategoryResponseBody[i]?["service_sub_category_name"]);
          subCategoryId.add(subCategoryResponseBody[i]?['id']);

          print(subCategoryName);
        }

        setState(() {
          subCategories = Map.fromIterables(subCategoryName, subCategoryId);
        });
      }
    } catch (error) {
      print('get sub cat error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('service create building');
    // final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_outlined,
            size: 2.2.h,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
            child: _isLoading == true
                ? CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary)
                : Center(
                    child: zipCode == null
                        ? Container(
                            height: 25.h,
                            width: 70.w,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 3.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('Please update your profile first'),
                                SizedBox(
                                  height: 2.h,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/providerInfoUpdate');
                                  },
                                  child: const Text('Go'),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            height: 100.h,
                            width: width,
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                              vertical: 1.h,
                            ),
                            child: Form(
                              key: _formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Select service category',
                                          style: TextStyle(
                                            fontSize: 2.h,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        SizedBox(
                                          width: 40.w,
                                          child: Column(
                                            children: [
                                              DropdownButtonFormField<String>(
                                                value: _selectedCategory,
                                                items: categoryName
                                                    .map(
                                                      (category) =>
                                                          DropdownMenuItem<
                                                              String>(
                                                        child: Text(
                                                          category,
                                                          style: TextStyle(
                                                            fontSize: 2.h,
                                                          ),
                                                        ),
                                                        value: category,
                                                      ),
                                                    )
                                                    .toList(),
                                                onChanged: (category) {
                                                  setState(() {
                                                    _selectedCategory =
                                                        category;
                                                    if (_selectedCategory !=
                                                        null) {
                                                      categories[
                                                          _selectedCategory];
                                                      _getSubCategories();
                                                    }
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3.h,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Select service sub-category',
                                          style: TextStyle(
                                            fontSize: 2.h,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        SizedBox(
                                          width: 40.w,
                                          child: subCategoryName == []
                                              ? const Text(
                                                  'No sub-category found')
                                              : Column(
                                                  children: [
                                                    DropdownButtonFormField<
                                                        String>(
                                                      value:
                                                          _selectedSubCategory,
                                                      items: subCategoryName
                                                          .map(
                                                            (subCategory) =>
                                                                DropdownMenuItem<
                                                                    String>(
                                                              child: Text(
                                                                subCategory,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 2.h,
                                                                ),
                                                              ),
                                                              value:
                                                                  subCategory,
                                                            ),
                                                          )
                                                          .toList(),
                                                      onChanged: (subCategory) {
                                                        setState(() {
                                                          _selectedSubCategory =
                                                              subCategory;
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3.h,
                                    ),
                                    TextFormField(
                                      autofocus: false,
                                      controller: _serviceName,
                                      keyboardType: TextInputType.text,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null) {
                                          return 'This field is required';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        label: Text(
                                          'Service name',
                                          style: TextStyle(
                                            fontSize: 2.h,
                                          ),
                                        ),
                                        hintText: 'Example @ Dancing',
                                        border: const OutlineInputBorder(),
                                        fillColor: Colors.grey[50],
                                        filled: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 2.5.w),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    TextFormField(
                                      autofocus: false,
                                      controller: _serviceDescription,
                                      keyboardType: TextInputType.multiline,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null) {
                                          return 'This field is required';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        label: Text(
                                          'Service description',
                                          style: TextStyle(
                                            fontSize: 2.h,
                                          ),
                                        ),
                                        hintText:
                                            'Example @ My dancing availability is ...',
                                        border: const OutlineInputBorder(),
                                        fillColor: Colors.grey[50],
                                        filled: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 2.5.w),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    TextFormField(
                                      autofocus: false,
                                      controller: _serviceKeywordList,
                                      keyboardType: TextInputType.text,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null) {
                                          return 'This field is required';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        label: Text(
                                          'Service searching keyword',
                                          style: TextStyle(fontSize: 2.h),
                                        ),
                                        hintText:
                                            'Example @ Classical Dance, Hip-Hop, Tab-dancing',
                                        border: const OutlineInputBorder(),
                                        fillColor: Colors.grey[50],
                                        filled: true,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    TextFormField(
                                      autofocus: false,
                                      controller: _serviceExperience,
                                      keyboardType: TextInputType.number,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null) {
                                          return 'This field is required';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        label: Text(
                                          'Service experience',
                                          style: TextStyle(fontSize: 2.h),
                                        ),
                                        hintText: 'Example @ 5',
                                        border: const OutlineInputBorder(),
                                        fillColor: Colors.grey[50],
                                        filled: true,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    // TextFormField(
                                    //   autofocus: false,
                                    //   controller: _serviceCertification,
                                    //   keyboardType: TextInputType.url,
                                    //   decoration: InputDecoration(
                                    //     label: Text(
                                    //       'Service certification',
                                    //       style: TextStyle(
                                    //         fontSize: 2.h,
                                    //       ),
                                    //     ),
                                    //     hintText: 'Example @ https://www.test.com/',
                                    //     border: const OutlineInputBorder(),
                                    //     fillColor: Colors.grey[50],
                                    //     filled: true,
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   height: 2.h,
                                    // ),
                                    TextFormField(
                                      autofocus: false,
                                      controller: _rateAptVideo,
                                      keyboardType: TextInputType.number,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null) {
                                          return 'This field is required';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        label: Text(
                                          'Charge of Appointment',
                                          style: TextStyle(fontSize: 2.h),
                                        ),
                                        hintText: 'Example @ 69',
                                        border: const OutlineInputBorder(),
                                        fillColor: Colors.grey[50],
                                        filled: true,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    TextFormField(
                                      autofocus: false,
                                      controller: _rateInstVideo,
                                      keyboardType: TextInputType.number,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null) {
                                          return 'This field is required';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        label: Text(
                                          'Charge of Instant service',
                                          style: TextStyle(fontSize: 2.h),
                                        ),
                                        hintText: 'Example @ 69',
                                        border: const OutlineInputBorder(),
                                        fillColor: Colors.grey[50],
                                        filled: true,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    TextFormField(
                                      autofocus: false,
                                      controller: _rateInHouse,
                                      keyboardType: TextInputType.number,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null) {
                                          return 'This field is required';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        label: Text(
                                          'Charge of In house service',
                                          style: TextStyle(fontSize: 2.h),
                                        ),
                                        hintText: 'Example @ 69',
                                        border: const OutlineInputBorder(),
                                        fillColor: Colors.grey[50],
                                        filled: true,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    TextFormField(
                                      autofocus: false,
                                      controller: _ratePromotion,
                                      keyboardType: TextInputType.number,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null) {
                                          return 'This field is required';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        label: Text(
                                          'Charge of Promotion',
                                          style: TextStyle(
                                            fontSize: 2.h,
                                          ),
                                        ),
                                        hintText: 'Example @ 69',
                                        border: const OutlineInputBorder(),
                                        fillColor: Colors.grey[50],
                                        filled: true,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    ElevatedButton(
                                      onPressed: _createService,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 3.w),
                                        child: Text(
                                          'Create service',
                                          style:
                                              TextStyle(letterSpacing: 1.2.w),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  )),
      ),
    );
  }

  _createService() async {
    var serviceData = {
      // "service_user": providerId,
      "service_category": categories[_selectedCategory].toString(),
      "service_sub_category": subCategories[_selectedSubCategory].toString(),
      "service_keyword_list": _serviceKeywordList.text.toString().split(','),
      "service_name": _serviceName.text.toString(),
      "service_description": _serviceDescription.text.toString(),
      "service_experiance_year": _serviceExperience.text.toString(),
      // "service_certificate": _serviceCertification.toString(),
      "rate_apt_video_cons": _rateAptVideo.text.toString(),
      "rate_inst_video_cons": _rateInstVideo.text.toString(),
      "rate_inhouse_cons": _rateInHouse.text.toString(),
      "rate_promotion": _ratePromotion.text.toString(),
      // "service_created_date": DateTime.now(),

      "service_status": true,
      "service_visibility": true,
      "service_zip_code": zipCode.toString(),
    };

    print(serviceData);

    try {
      //CallApi().postData(serviceData, '/api/provider_service_create/');
      var serviceCreateResponse = await CallApi()
          .postData(serviceData, '/api/provider_service_create/');

      print(serviceCreateResponse.statusCode);

      var serviceCreateBody = json.decode(serviceCreateResponse.body);

      if (serviceCreateResponse.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Service has created successfully.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Can not create service now. Try again letter'),
          ),
        );
      }
    } catch (error) {
      print('service creating error: $error');
    }
  }
}
