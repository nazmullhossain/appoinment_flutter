import 'dart:async';
import 'dart:convert';

// import 'package:consult_24/providers/appointment.dart';
import 'package:consult_24/providers/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../models/call_api.dart';

class ProviderScreen extends StatefulWidget {
  ProviderScreen({Key? key}) : super(key: key);

  @override
  State<ProviderScreen> createState() => _ProviderScreenState();
}

class _ProviderScreenState extends State<ProviderScreen> {
  bool _isInit = true;
  bool isOnline = false;
  bool _isLoading = true;
  bool completeProfile = false;

// provider details
  String? providerImgUrl;
  String? providerDisplayName;

  double avgRating = 3;
  String? lifeTimeServiceCount = '0';
  int totalReviewCount = 1;
  String? providerEmailAddress;
  String? providerPhoneNumber;
  String? providerGender;
  String providerExperienceYear = '0';
  String? batchLevel;

// company details
  String? totalEmployees;
  String? companyName;
  String? businessGoal;
  String? foundingYear;
  String? spentMoney;

  // mixed Details
  String? socialMediaLink;
  String? websiteLink;

  // address details
  String? address;

  // bank info
  var bankName = [];
  var accountName = [];
  var accountNumber = [];

  // card information
  var cardName = [];
  var cardNumber = [];
  var expiryDate = [];

  // service list
  List serviceOffered = [];

  int? providerId;

  var providerDataBody;
  var profilePictureBody;
  var bankInfoBody;
  var cardInfoBody;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    SharedPreferences successLogin = await SharedPreferences.getInstance();

    var logId = successLogin.getInt('loginId');
    var loginId = json.decode(json.encode(logId));

    Provider.of<LocalData>(context, listen: false).getLocalData();

    setState(() {
      providerId = loginId;
    });

    _isInit = false;
    if (providerId != null) {
      await _getProviderProfilePicture(providerId);
      await _getProviderDetails();
      await _getProviderServiceDetails();
      await _getProviderBankInfo();
      await _getProviderCardInfo();
      // Provider.of<Appointment>(context, listen: false)
      //     .getAllAppointmentList(providerId);
    }

    super.didChangeDependencies();
  }

  Future _getProviderProfilePicture(var providerId) async {
    try {
      // get provider picture
      var responseProviderPicture = await CallApi().getData(
          '/auth_api/ServiceProviderProfilePicture/?user_id=$providerId');

      profilePictureBody = json.decode(responseProviderPicture.body);

      debugPrint('Image response : ${responseProviderPicture.statusCode}');

      debugPrint('profile picture $profilePictureBody');

      if (responseProviderPicture.statusCode == 200) {
        debugPrint('profile picture tray: ${profilePictureBody.last}');
        var profilePicture = profilePictureBody?[0]?['profile_picture'];

        setState(() {
          providerImgUrl = profilePicture;
        });
      }
    } catch (error) {
      debugPrint('Provider profile picture error: $error');
    }
  }

  Future _getProviderDetails() async {
// get provider details
    try {
      var responseProviderData =
          await CallApi().getData('/auth_api/provider_profile/$providerId');

      providerDataBody = json.decode(responseProviderData.body);

      debugPrint('provider data body: $providerDataBody');
      debugPrint('provider info: ${responseProviderData.statusCode}');

      if (responseProviderData.statusCode == 200) {
        var firstName = providerDataBody?['user']?['first_name'];
        var middleName = providerDataBody?['user']?['middle_name'];
        var lastName = providerDataBody?['user']?['last_name'];

        debugPrint(firstName);

        var serviceCount =
            providerDataBody?['provider']?['lifetime_service_count'];

        // var positiveReview =
        //     providerDataBody?[0]?['provider']?['positive_review_id'];
        // var negativeReview =
        //     providerDataBody?[0]?['provider']?['nagetive_review_id'];

        var apartmentAddress = providerDataBody?['address'][0]['apt'];
        var streetAddress = providerDataBody?['address'][0]['street_address'];
        var cityName = providerDataBody?['address'][0]['city'];
        // var stateName = providerDataBody?[0]?['address'][0]['state'];
        var countryName = providerDataBody?['address'][0]['country'];
        setState(() {
          providerDisplayName = ('$firstName $middleName $lastName');
          isOnline = providerDataBody?['user']?['online_status'];
          providerGender = providerDataBody?['user']?['gender'];
          providerEmailAddress = providerDataBody?['user']?['email'];
          providerPhoneNumber = providerDataBody?['user']?['phone_number'];

          // avgRating = providerDataBody?[0]?['provider']?['avg_rating'];
          if (serviceCount != 'null') {
            lifeTimeServiceCount = serviceCount;
          }

          // totalReviewCount = positiveReview + negativeReview;
          providerExperienceYear =
              providerDataBody?['provider']?['experience_level'];
          businessGoal = providerDataBody?['provider']?['businees_goal'];
          totalEmployees =
              providerDataBody?['provider']?['number_of_employees'];
          companyName = providerDataBody?['provider']?['company_name'];
          socialMediaLink = providerDataBody?['provider']?['social_media_link'];
          websiteLink = providerDataBody?['provider']?['website_url'];
          spentMoney =
              providerDataBody?['provider']?['spent_money_in_business'];
          foundingYear = providerDataBody?['provider']?['founding_year'];
          batchLevel = providerDataBody?['provider']?['batch_level'];

          address =
              ('$apartmentAddress, $streetAddress, $cityName, $countryName.');
        });
      }
    } catch (error) {
      debugPrint('Provider Data error: $error');
    }
  }

  Future _getProviderCardInfo() async {
    // card information
    try {
      var responseCard = await CallApi()
          .getData('/billing/provider_credit_card_info/$providerId');

      cardInfoBody = json.decode(responseCard.body);
      if (responseCard.statusCode == 200) {
        for (int i = 0; i < cardInfoBody.length; i++) {
          cardName.add(cardInfoBody[i]?['credit_card_name']);
          cardNumber.add(cardInfoBody[i]?['credit_card_number']);
          expiryDate.add(cardInfoBody[i]?['credit_card_expire_date']);
        }
      }
    } catch (error) {
      debugPrint('provider card error: $error');
    }
  }

  Future _getProviderBankInfo() async {
    // get provider bank info
    try {
      var responseBank =
          await CallApi().getData('/billing/provider_bank_info/$providerId');

      bankInfoBody = json.decode(responseBank.body);

      if (responseBank.statusCode == 200) {
        for (int i = 0; i < bankInfoBody.length; i++) {
          bankName.add(bankInfoBody[i]?['bank_name']);
          accountName.add(bankInfoBody[i]?['bank_account_name']);
          accountNumber.add(bankInfoBody[i]?["bank_account_number"]);
        }
      }
    } catch (error) {
      debugPrint('provider bank error: $error');
    }
  }

  Future _getProviderServiceDetails() async {
    try {
      var responseService =
          await CallApi().getData('/api/ServiceListProviderAPIView/');

      var serviceListBody = json.decode(responseService.body);

      if (responseService.statusCode == 200) {
        setState(() {
          for (var i = 0; i < serviceListBody.length; i++) {
            serviceOffered.add(serviceListBody[i]['service_name']);
          }
        });
      }
    } catch (error) {
      debugPrint('Service list error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(milliseconds: 2000), () {
      _isLoading = false;
    });
    return Container(
      color: Colors.white,
      height: 100.h,
      width: 100.w,
      child: Center(
        child: _isLoading == true
            ? CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              )
            : Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 84.h,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // image and review
                            Container(
                              color: Colors.grey[50],
                              width: 100.w,
                              margin: EdgeInsets.symmetric(
                                horizontal: 5.w,
                                vertical: 1.h,
                              ),
                              padding: EdgeInsets.only(left: 5.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 15.h,
                                        width: 25.w,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            style: BorderStyle.solid,
                                            color: Colors.grey,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: providerImgUrl == null
                                            ? Image.asset(
                                                'assets/images/null-pro-pic-1.png',
                                                fit: BoxFit.fitWidth,
                                              )
                                            : Image.network(
                                                providerImgUrl.toString(),
                                                fit: BoxFit.fitWidth,
                                              ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 3.w,
                                  ),
                                  // personal information
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: .1.h,
                                    ),
                                    height: 25.h,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                readStar(),
                                                SizedBox(
                                                  width: 1.h,
                                                ),
                                                totalReviewCount == 0
                                                    ? const Text('0')
                                                    : Text(
                                                        '($totalReviewCount)'),
                                                TextButton(
                                                  onPressed: () {},
                                                  child:
                                                      const Text('All reviews'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            providerDisplayName != null
                                                ? Text(
                                                    " $providerDisplayName",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1,
                                                  )
                                                : const Text('No user'),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 3,
                                              ),
                                              child: Icon(
                                                Icons.check_circle,
                                                color: (providerDataBody
                                                            .toString()
                                                            .isNotEmpty &&
                                                        profilePictureBody
                                                            .toString()
                                                            .isNotEmpty &&
                                                        bankName.isNotEmpty &&
                                                        cardNumber.isNotEmpty)
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                    : Colors.grey[400],
                                                size: 2.h,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 0.2.h,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Gender :',
                                              style: TextStyle(
                                                fontSize: 2.2.h,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: .2.w,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 2.w,
                                            ),
                                            Text(
                                              '$providerGender',
                                              style: TextStyle(
                                                  fontSize: 2.h,
                                                  wordSpacing: 0.4.w),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 0.5.h,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Total Experience :',
                                              style: TextStyle(
                                                fontSize: 2.2.h,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: .2.w,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 2.w,
                                            ),
                                            Text(
                                              providerExperienceYear,
                                              style: TextStyle(
                                                fontSize: 2.h,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 0.5.h,
                                        ),
                                        SizedBox(
                                          height: 0.5.h,
                                        ),
                                        lifeTimeServiceCount == null
                                            ? const Text(
                                                'No service given yet.')
                                            : Row(
                                                children: [
                                                  Text(
                                                    'Total service given : ',
                                                    style: TextStyle(
                                                      fontSize: 2.2.h,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 0.2.w,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 1.w,
                                                  ),
                                                  Text(
                                                    '$lifeTimeServiceCount',
                                                    style: TextStyle(
                                                      fontSize: 2.h,
                                                    ),
                                                  ),
                                                ],
                                              )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // service offered
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 1.h,
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 5.w),
                              color: Colors.grey[50],
                              width: 100.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Service offerd: ',
                                    style: TextStyle(
                                      fontSize: 2.2.h,
                                      letterSpacing: .3.w,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.w,
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                    child: serviceOffered.isNotEmpty
                                        ? ListView.separated(
                                            separatorBuilder: (context, _) =>
                                                SizedBox(
                                              height: 1.w,
                                            ),
                                            scrollDirection: Axis.vertical,
                                            itemCount: serviceOffered.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 3.w,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        '${serviceOffered[index]}'),
                                                    SizedBox(
                                                      height: 1.w,
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          )
                                        : const Text('Loading...'),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),

                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.w),
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 2.w,
                              ),
                              width: 100.w,
                              height: 22.h,
                              color: Colors.grey[50],
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Prefered Customer List:',
                                    style: TextStyle(
                                      fontSize: 2.3.h,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3.w,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.w,
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                    child: serviceOffered.isNotEmpty
                                        ? ListView.separated(
                                            separatorBuilder: (context, _) =>
                                                SizedBox(
                                              width: 1.w,
                                            ),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: serviceOffered.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 1.5.w,
                                                ),
                                                child: Container(
                                                  padding:
                                                      EdgeInsets.all(0.5.w),
                                                  height: 12.h,
                                                  width: 26.w,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: 10.h,
                                                        width: 25.w,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 1.w,
                                                      ),
                                                      Text(
                                                        'Customer Name',
                                                        style: TextStyle(
                                                          fontSize: 1.8.h,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        : const Text('Loading...'),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            // contact information
                            Container(
                              color: Colors.grey[50],
                              // height: height * 0.28,
                              margin: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Column(
                                children: [
                                  Text(
                                    'Contact info',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                            top: 5,
                                          ),
                                          child: address == null
                                              ? const Text('No address found.')
                                              : Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Address:',
                                                      style: TextStyle(
                                                        fontSize: 2.2.h,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 0.3.w,
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                        left: 2.w,
                                                      ),
                                                      child: Text('$address'),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                        SizedBox(
                                          height: 0.8.h,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                          ),
                                          child: providerPhoneNumber == null
                                              ? const Text('No number found.')
                                              : Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Phone Number: ',
                                                      style: TextStyle(
                                                        fontSize: 2.2.h,
                                                        letterSpacing: .3.w,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 1.w,
                                                      ),
                                                      child: Text(
                                                          '$providerPhoneNumber'),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                        SizedBox(
                                          height: 0.8.h,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                          ),
                                          child: providerEmailAddress == null
                                              ? const Text('No email found.')
                                              : Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Email Address: ',
                                                      style: TextStyle(
                                                        fontSize: 2.2.h,
                                                        letterSpacing: .3.w,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 1.w,
                                                      ),
                                                      child: Text(
                                                        '$providerEmailAddress',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                        SizedBox(
                                          height: 0.8.h,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                          ),
                                          child: socialMediaLink == null
                                              ? const Text(
                                                  'No social link found.')
                                              : Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Social Link: ',
                                                      style: TextStyle(
                                                        fontSize: 2.2.h,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 0.3.w,
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                        left: 2.w,
                                                      ),
                                                      child: Text(
                                                          '$socialMediaLink'),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                        SizedBox(
                                          height: 0.8.h,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                          ),
                                          child: websiteLink == null
                                              ? const Text('No website found.')
                                              : Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Website link:',
                                                      style: TextStyle(
                                                        fontSize: 2.2.h,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 0.3.w,
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                        left: 2.w,
                                                      ),
                                                      child:
                                                          Text('$websiteLink'),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 1.5.h,
                            ),
                            // company information found
                            Container(
                              color: Colors.grey[50],
                              // height: height * 0.28,
                              margin: EdgeInsets.symmetric(
                                horizontal: 5.w,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.w),
                                child: Column(
                                  children: [
                                    Text(
                                      'Company information: ',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    SizedBox(
                                      height: 3.h,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        companyName == null
                                            ? const Text('No name found')
                                            : Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Company Name: ',
                                                    style: TextStyle(
                                                      fontSize: 2.2.h,
                                                      letterSpacing: .3.w,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 1.w,
                                                    ),
                                                    child: Text(
                                                      '$companyName',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        SizedBox(
                                          height: 0.8.h,
                                        ),
                                        foundingYear == null
                                            ? const Text('No year found')
                                            : Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Founding Year: ',
                                                    style: TextStyle(
                                                      fontSize: 2.2.h,
                                                      letterSpacing: .3.w,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 1.w,
                                                    ),
                                                    child: Text(
                                                      '$foundingYear',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        SizedBox(
                                          height: 0.8.h,
                                        ),
                                        businessGoal == null
                                            ? const Text('No details are found')
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Business-Description: ',
                                                    style: TextStyle(
                                                      fontSize: 2.2.h,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: .3.w,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 0.5.h,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      // border: Border(
                                                      //   // bottom: BorderSide(
                                                      //   //   color: Colors.black87,
                                                      //   //   width: 2.w,
                                                      //   // ),
                                                      // ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        5,
                                                      ),
                                                    ),
                                                    height: 8.h,
                                                    width: 100.w,
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    2.w),
                                                        child: Text(
                                                            '$businessGoal'),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        spentMoney == null
                                            ? const Text('No amount found')
                                            : Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Total Spent: ',
                                                    style: TextStyle(
                                                      fontSize: 2.2.h,
                                                      letterSpacing: .3.w,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 1.w,
                                                    ),
                                                    child: Text(
                                                      '$spentMoney',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        SizedBox(
                                          height: 0.8.h,
                                        ),
                                        totalEmployees == null
                                            ? const Text(
                                                'Employees amount is empty.')
                                            : Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Total Employees: ',
                                                    style: TextStyle(
                                                      fontSize: 2.2.h,
                                                      letterSpacing: .3.w,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 1.w,
                                                    ),
                                                    child: Text(
                                                      '$totalEmployees',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        SizedBox(
                                          height: 0.8.h,
                                        ),
                                      ],
                                    ),

                                    SizedBox(
                                      height: 1.h,
                                    ),

                                    // show banking information
                                  ],
                                ),
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Container(
                                color: Colors.grey[50],
                                margin: EdgeInsets.only(top: 2.h),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 1.h,
                                ),
                                child: Column(
                                  children: [
                                    const Text('Bank Details :'),
                                    bankName.isEmpty
                                        ? Center(
                                            child: Text(
                                              'Bank details not found...!',
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
                                                  margin: EdgeInsets.symmetric(
                                                    vertical: 1.5.h,
                                                  ),
                                                  padding: EdgeInsets.symmetric(
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
                                                            letterSpacing: 1.w,
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
                                                            letterSpacing: 1.w,
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
                            ),

                            SizedBox(
                              height: 1.h,
                            ),

                            // showing card information
                            if (cardInfoBody != null)
                              Container(
                                margin: EdgeInsets.only(top: 2.h),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 1.h,
                                ),
                                child: Column(
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
                                                  margin: EdgeInsets.symmetric(
                                                    vertical: 1.5.h,
                                                  ),
                                                  padding: EdgeInsets.symmetric(
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
                                                            letterSpacing: 1.w,
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

                            // Center(
                            //   child: SizedBox(
                            //     width: 50.w,
                            //     child: ElevatedButton(
                            //       onPressed: () {},
                            //       child: Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.center,
                            //         children: [
                            //           Text(
                            //             'Make an appointment',
                            //             style: TextStyle(
                            //               fontSize: 2.h,
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // ),
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

  Widget readStar() => RatingBarIndicator(
        rating: avgRating,
        itemBuilder: (context, _) => const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        // onRatingUpdate: (rating) {},
        // allowHalfRating: true,
        // updateOnDrag: false,
        // ignoreGestures: true,
        // minRating: 1,
        // maxRating: 5,
        unratedColor: Colors.grey,
        direction: Axis.horizontal,
        itemSize: 2.h,
      );
}
