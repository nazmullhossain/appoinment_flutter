// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
// import 'package:to_resolve/models/customer_info.dart';
import '../../models/call_api.dart';

// other packages

class CustomerDetailsScreen extends StatefulWidget {
  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  var _isInit = true;
  String? userName;
  String? userImage;
  String? userAddress;
  String? userEmail;
  String? userInterest;
  int? customerId;
  String? userGender;
  String? customerZip;
  // bank info
  var bankName = [];
  var accountName = [];
  var accountNumber = [];

  // card information
  var cardName = [];
  var cardNumber = [];
  var expiryDate = [];

  var customerDataBody;
  var profilePictureBody;
  var bankInfoBody;
  var cardInfoBody;

  @override
  didChangeDependencies() async {
    if (_isInit) {
      SharedPreferences successLogin = await SharedPreferences.getInstance();

      var logId = successLogin.getInt('loginId');
      var loginId = json.decode(json.encode(logId));

      // print(success);
      setState(() {
        customerId = loginId;
      });
    }
    _isInit = false;
    if (customerId != null) {
      _getProfileImage(customerId);
      _getCustomerDetails(customerId);
      _getBankDetails(customerId);
      _getCardDetails(customerId);
    }
    super.didChangeDependencies();
  }

  _getProfileImage(var profileId) async {
    // profile picture data
    try {
      var responseProfilePicture = await CallApi()
          .getData('/auth_api/CustomerProfilePicture/?user_id=$profileId');

      profilePictureBody = json.decode(responseProfilePicture.body);

      print(profilePictureBody);

      if (responseProfilePicture.statusCode == 200) {
        var profilePicture = profilePictureBody?.last['profile_picture'];

        setState(() {
          userImage = profilePicture;
        });
      }
    } catch (error) {
      print('Customer profile picture error: $error');
    }
  }

  _getCustomerDetails(var profileId) async {
    // print(userId);

// get customer data
    try {
      var responseData =
          await CallApi().getData('/auth_api/customer_profile/$profileId');
      // final data = json.decode(response.body);
      customerDataBody = json.decode(responseData.body);

      // print(responseProfilePictureBody);

      setState(() {
        if (responseData.statusCode == 200) {
          setState(() {
            userName = (customerDataBody?['user']?['first_name'] +
                ' ' +
                customerDataBody?['user']?['middle_name'] +
                ' ' +
                customerDataBody?['user']?['last_name']);

            userAddress = customerDataBody?['address'][0]['apt'] +
                ', ' +
                customerDataBody?['address'][0]['street_address'] +
                ', ' +
                customerDataBody?['address'][0]['city'] +
                ', ' +
                customerDataBody?['address'][0]['state'] +
                ', ' +
                customerDataBody?['address'][0]['country'];

            customerZip = customerDataBody?['address'][0]['zip_code'];

            userEmail = customerDataBody?['user']?['email'];
            userGender = customerDataBody?['user']?['gender'];
          });
        }
      });

      // print(responseDataBody);
    } catch (error) {
      print('Customer profile data error: $error');
    }
  }

  _getBankDetails(var profileId) async {
    // get bank information
    try {
      var responseBank =
          await CallApi().getData('/billing/customer_bank_info/$profileId');

      bankInfoBody = json.decode(responseBank.body);

      if (responseBank.statusCode == 200 && bankInfoBody != null) {
        for (int i = 0; i < bankInfoBody.length; i++) {
          bankName.add(bankInfoBody[i]?['bank_name']);
          accountName.add(bankInfoBody[i]?['bank_account_name']);
          accountNumber.add(bankInfoBody[i]?["bank_account_number"]);
        }
      }
    } catch (error) {
      print('Customer bank error: $error');
    }
  }

  _getCardDetails(var profileId) async {
    // get card Info
    try {
      var responseCard = await CallApi()
          .getData('/billing/customer_credit_card_info/$customerId');

      cardInfoBody = json.decode(responseCard.body);

      if (responseCard.statusCode == 200 && cardInfoBody != null) {
        for (int i = 0; i < cardInfoBody.length; i++) {
          cardName.add(cardInfoBody[i]?['credit_card_name']);
          cardNumber.add(cardInfoBody[i]?['credit_card_number']);
          expiryDate.add(cardInfoBody[i]?['credit_card_expire_date']);
        }
      }
    } catch (error) {
      print('Customer card error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_sharp),
          ),
        ),
        body: SafeArea(
          child: Container(
            height: 100.h,
            width: 100.w,
            padding: EdgeInsets.symmetric(
              vertical: 1.h,
              horizontal: 2.w,
            ),
            child: Center(
              child: (customerZip == null && userImage == null)
                  ? CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : Container(
                      height: 95.h,
                      width: 100.w,
                      margin: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 1.h,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: height * 1,
                              width: width * 1,
                              color: Colors.grey[100],
                              child: Column(
                                children: [
                                  Container(
                                    height: 22.h,
                                    width: width * 1,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 2.w,
                                      // vertical: height * 0.03,
                                    ),
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 20.h,
                                          width: 48.w,
                                          // color: Colors.amber,
                                          child: userImage != null
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      50,
                                                    ),
                                                  ),
                                                  child: Image.network(
                                                    '$userImage',
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : Image.asset(
                                                  'assets/images/null-pro-pic-2.png',
                                                  fit: BoxFit.fitHeight,
                                                ),
                                          // decoration: BoxDecoration(
                                          //   border: Border.all(
                                          //     width: 1,
                                          //     color: Theme.of(context).colorScheme.primary,
                                          //   ),
                                          //   borderRadius: BorderRadius.circular(10),
                                          // ),
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        // ElevatedButton(
                                        //   onPressed: () {
                                        //     Navigator.of(context)
                                        //         .pushNamed('/proPicUpdateDelete');
                                        //   },
                                        //   child: const Text('Update Image'),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  // Container(
                                  //   height: height * 0.28,
                                  //   width: width * 1,
                                  //   padding: const EdgeInsets.symmetric(
                                  //     horizontal: 15,
                                  //     vertical: 30,
                                  //   ),
                                  //   margin: const EdgeInsets.only(
                                  //     top: 1,
                                  //     bottom: 5,
                                  //     right: 5,
                                  //     left: 5,
                                  //   ),
                                  //   color: Colors.white,
                                  //   child: Column(
                                  //     crossAxisAlignment: CrossAxisAlignment.start,
                                  //     children: [
                                  //       const Text('Interest :'),
                                  //       Text('$userInterest'),
                                  //     ],
                                  //   ),
                                  // ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Container(
                                    height: height * 0.24,
                                    width: width * 1,
                                    padding: EdgeInsets.symmetric(
                                      vertical: height * 0.0025,
                                      horizontal: width * 0.04,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        userName == null
                                            ? const Text('Guest user')
                                            : Text(
                                                'Name:  $userName',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                        userAddress == null
                                            ? const Text(
                                                'Address: No address found',
                                                // softWrap: true,
                                              )
                                            : TextOverflow == true
                                                ? Expanded(
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Text(
                                                        'Address: $userAddress',
                                                        overflow:
                                                            TextOverflow.clip,
                                                        softWrap: true,
                                                        maxLines: 3,
                                                      ),
                                                    ),
                                                  )
                                                : Text(
                                                    'Address: $userAddress',
                                                  ),
                                        userEmail == null
                                            ? const Text(
                                                'Email: No email found',
                                              )
                                            : Text('Email:  $userEmail'),
                                        userGender == null
                                            ? const Text('Gender: None ')
                                            : Text('Gender: $userGender'),
                                        const Text('Date of Birth: '),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.w,
                                  ),

                                  // bank details
                                  Container(
                                    width: width * 1,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 2.w,
                                      vertical: 1.h,
                                    ),
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Bank Details :'),
                                        bankName.isEmpty
                                            ? Center(
                                                child: Text(
                                                  'No bank details found..!',
                                                  style: TextStyle(
                                                    fontSize: 2.h,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 3.h,
                                                ),
                                                child: ListView.builder(
                                                  itemCount: bankName.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Container(
                                                      color: Colors.grey[50],
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                        vertical: 1.5.h,
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        vertical: 1.h,
                                                        horizontal: 4.w,
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              horizontal: 3.w,
                                                            ),
                                                            child: Text(
                                                              'Bank Name:  ${bankName[index]}',
                                                              style: TextStyle(
                                                                fontSize: 1.5.h,
                                                                letterSpacing:
                                                                    1.w,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 1.h,
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              horizontal: 3.w,
                                                            ),
                                                            child: Text(
                                                              'Account Name:  ${accountName[index]}',
                                                              style: TextStyle(
                                                                fontSize: 1.5.h,
                                                                letterSpacing:
                                                                    1.w,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 1.h,
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              horizontal: 3.w,
                                                            ),
                                                            child: Text(
                                                              'Account Number:  ${accountNumber[index]}',
                                                              style: TextStyle(
                                                                fontSize: 1.5.h,
                                                                letterSpacing:
                                                                    1.2.w,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    height: 1.h,
                                  ),

                                  // card details
                                  Container(
                                    width: width * 1,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 2.w,
                                      vertical: 1.h,
                                    ),
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Card Details :'),
                                        cardName.isEmpty
                                            ? Center(
                                                child: Text(
                                                  'No card details found...!',
                                                  style: TextStyle(
                                                    fontSize: 2.h,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 3.h,
                                                ),
                                                child: ListView.builder(
                                                  itemCount: cardName.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Container(
                                                      color: Colors.grey[50],
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                        vertical: 1.5.h,
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        vertical: 1.h,
                                                        horizontal: 4.w,
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              horizontal: 3.w,
                                                            ),
                                                            child: Text(
                                                              'Name on Card:  ${cardName[index]}',
                                                              style: TextStyle(
                                                                fontSize: 1.5.h,
                                                                letterSpacing:
                                                                    1.w,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 1.h,
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              horizontal: 3.w,
                                                            ),
                                                            child: Text(
                                                              'Card Number:  ${cardNumber[index]}',
                                                              style: TextStyle(
                                                                fontSize: 1.5.h,
                                                                letterSpacing:
                                                                    1.2.w,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: SizedBox(
                                width: 40.w,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/updateProfileScreen');
                                  },
                                  child: const Text('Update your profile'),
                                ),
                              ),
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
