import 'dart:async';
import 'dart:convert';

import 'package:consult_24/providers/appointment.dart';
import 'package:consult_24/providers/pref_user.dart';
import 'package:consult_24/providers/search_provider.dart';
import 'package:consult_24/ui/theme_data.dart';
import 'package:consult_24/bot_nav_components/customer_view/customer_view_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class ServiceDetailsScreen extends StatefulWidget {
  ServiceDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  String? imgUrl;
  String? serviceTitle;
  String? address;
  int appointmentCost = 10;

  String? providerImg;
  String? providerName;
  String? providerStatus;

  double averageRatings = 4.8;
  int totalReviews = 12;

  String experienceYear = 'Ameture';

  bool _isLoading = true;

  int? customerId;
  String? customerName;
  int? roleId;

  @override
  void didChangeDependencies() async {
    SharedPreferences successLogin = await SharedPreferences.getInstance();
    var custmIdJson = successLogin.getInt('loginId');
    var custNameJson = successLogin.getString('loginName');
    var userRoleJson = successLogin.getInt('role');

    var custId = json.decode(json.encode(custmIdJson));
    var custName = json.decode(json.encode(custNameJson));
    var role = json.decode(json.encode(userRoleJson));

    setState(() {
      customerId = custId;
      customerName = custName;
      roleId = role;
      if (customerId != null) {
        Provider.of<PrefUser>(context, listen: false)
            .getPrefProvider(customerId: customerId);
      }
    });

    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2500), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int experience =
        Provider.of<SearchProvider>(context, listen: false).experienceYear;

    if (experience <= 2 && experience > 0) {
      experienceYear = 'Intermediate';
    } else if (experience > 2 && experience < 5) {
      experienceYear = 'Expert';
    } else if (experience > 5) {
      experienceYear = 'Professional';
    }

    // averageRatings = serviceProviderDetails.averageRatings;
    // providerImg = serviceProviderDetails.providerImg;

    // debugPrint('$_isFavorite');
    debugPrint('WidgetBuilding');

    // debugPrint(serviceProviderDetails.serviceTitle);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: _isLoading == true
              ? CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                )
              : Container(
                  height: 100.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 100.w,
                          width: 100.w,
                          child: Consumer<SearchProvider>(
                              builder: (context, imgFile, child) {
                            return Column(
                              children: [
                                imgFile.serviceImg == null
                                    ? Container(
                                        height: 20.h,
                                        width: 100.w,
                                        color: Colors.black,
                                      )
                                    : Image(
                                        image: NetworkImage(
                                          imgFile.serviceImg.toString(),
                                        ),
                                      ),
                                Expanded(
                                  child: Container(
                                    height: 76.h,
                                    width: 96.w,
                                    padding: EdgeInsets.only(
                                        left: 2.w, right: 2.w, top: 0.3.h),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 2.w),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(10),
                                        right: Radius.circular(10),
                                      ),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Consumer<SearchProvider>(builder:
                                          (context, serviceProviderDetails,
                                              child) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 0.8.h, bottom: 1.5.h),
                                              height: 8.h,
                                              width: 100.w,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 3.w,
                                                vertical: 0.8.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[50],
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(4),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        serviceProviderDetails
                                                                    .serviceTitle ==
                                                                null
                                                            ? 'Loading..'
                                                            : '${serviceProviderDetails.serviceTitle}',
                                                        style: TextStyle(
                                                          fontSize: 2.h,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 0.05.w,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                      SizedBox(height: 0.8.h),
                                                      Text(
                                                        serviceProviderDetails
                                                                    .address ==
                                                                null
                                                            ? 'Loading...'
                                                            : 'Payment method: ',
                                                        style: TextStyle(
                                                          fontSize: 1.5.h,
                                                          color: Colors.black54,
                                                          letterSpacing: 0.05.w,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Consumer<Appointment>(builder:
                                                      (context, appointment,
                                                          child) {
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            _showDialogForAppointment();
                                                          },
                                                          child: Text(
                                                            serviceProviderDetails
                                                                        .appointmentCost ==
                                                                    null
                                                                ? '0'
                                                                : 'Get Service \n\$${serviceProviderDetails.appointmentCost}/hr',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize: 1.5.h,
                                                              color:
                                                                  Colors.white,
                                                              letterSpacing:
                                                                  0.03.w,
                                                            ),
                                                          ),
                                                        ),
                                                        // SizedBox(height: 0.5.h),
                                                        // Text(
                                                        //   '\$ $appointmentCost/hr',
                                                        //   style: TextStyle(
                                                        //     fontSize: 1.8.h,
                                                        //     color: Theme.of(context)
                                                        //         .colorScheme
                                                        //         .primary,
                                                        //   ),
                                                        // ),
                                                      ],
                                                    );
                                                  }),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 0.5.h),
                                                  child: Text(
                                                    'About the service',
                                                    style: TextStyle(
                                                      fontSize: 1.7.h,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black54,
                                                      letterSpacing: 0.05.w,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 100.w,
                                                  margin: EdgeInsets.only(
                                                      bottom: 1.h),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 2.w,
                                                    vertical: 0.8.h,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(4)),
                                                    color: Colors.grey[50],
                                                  ),
                                                  child: Text(
                                                    serviceProviderDetails
                                                                .serviceDescription ==
                                                            null
                                                        ? 'The service has no description'
                                                        : '${serviceProviderDetails.serviceDescription}',
                                                    style: TextStyle(
                                                      fontSize: 1.6.h,
                                                      letterSpacing: 0.04.w,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.black38,
                                              height: 2.w,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 1.h,
                                                // horizontal: 1.w,
                                              ),
                                              child: Text(
                                                'Service Provider Info',
                                                style: TextStyle(
                                                  fontSize: 1.8.h,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black54,
                                                  letterSpacing: 0.05.w,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 7.h,
                                              width: 100.w,
                                              margin:
                                                  EdgeInsets.only(bottom: 2.h),
                                              // margin: EdgeInsets.symmetric(
                                              //   vertical: 0.5.h,
                                              //   horizontal: 0.3.w,
                                              // ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(4)),
                                                color: Colors.grey[50],
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 1.w,
                                                vertical: 1.h,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    height: 100.h,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          height: 100.h,
                                                          width: 12.w,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    Radius
                                                                        .circular(
                                                                            4)),
                                                            image: providerImg ==
                                                                    null
                                                                ? const DecorationImage(
                                                                    image:
                                                                        AssetImage(
                                                                      'assets/images/null-pro-pic-2.png',
                                                                    ),
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                    scale: 1,
                                                                  )
                                                                : DecorationImage(
                                                                    image: NetworkImage(
                                                                        '$providerImg'),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 2.w,
                                                        ),
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              serviceProviderDetails
                                                                          .providerName ==
                                                                      null
                                                                  ? 'Loading...'
                                                                  : '${serviceProviderDetails.providerName}',
                                                              style: TextStyle(
                                                                fontSize: 1.8.h,
                                                                letterSpacing:
                                                                    0.05.w,
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              '$experienceYear provider',
                                                              style: TextStyle(
                                                                fontSize: 1.4.h,
                                                                letterSpacing:
                                                                    0.03.w,
                                                                color: Colors
                                                                    .black54,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 100.h,
                                                    // width: 50.w,
                                                    child: Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            debugPrint(
                                                                'Message clicked');
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              horizontal: 3.w,
                                                            ),
                                                            height: 100.h,
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      3,
                                                                      65,
                                                                      83),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    4),
                                                              ),
                                                            ),
                                                            child: Icon(
                                                              Icons
                                                                  .chat_bubble_rounded,
                                                              size: 3.h,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 1.w,
                                                        ),
                                                        Consumer<PrefUser>(
                                                            builder: (context,
                                                                prefProvider,
                                                                child) {
                                                          return InkWell(
                                                            onTap: () {
                                                              if (roleId == 2) {
                                                                prefProvider
                                                                    .prefProvider(
                                                                  customerId:
                                                                      customerId
                                                                          .toString(),
                                                                  customerName:
                                                                      customerName,
                                                                  providerId: serviceProviderDetails
                                                                      .desireProviderId
                                                                      .toString(),
                                                                  providerName:
                                                                      serviceProviderDetails
                                                                          .providerUserName,
                                                                );

                                                                //
                                                              } else {
                                                                _showDialogForPref();
                                                              }
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                horizontal: 3.w,
                                                              ),
                                                              height: 100.h,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        0,
                                                                        126,
                                                                        84),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          4),
                                                                ),
                                                              ),
                                                              child: Icon(
                                                                Icons.favorite,
                                                                size: 3.h,
                                                                color: prefProvider
                                                                            .statusCodeCustm ==
                                                                        201
                                                                    //     ||
                                                                    // _isFavorite ==
                                                                    //     true
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .white,
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 24.h,
                                              width: 100.w,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 0.5.h),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      // RatingStars(
                                                      //   value: Provider.of<
                                                      //               SearchProvider>(
                                                      //           context)
                                                      //       .averageRatings,
                                                      //   starCount: 1,
                                                      //   starOffColor: Colors.grey,
                                                      //   starSize: 2.h,
                                                      //   starColor: yellowClr,
                                                      //   maxValueVisibility: false,
                                                      //   valueLabelVisibility:
                                                      //       false,
                                                      //       starBuilder: (avera, yellowClr) {},
                                                      // ),

                                                      RatingBarIndicator(
                                                        unratedColor:
                                                            Colors.grey,
                                                        itemBuilder:
                                                            (context, _) =>
                                                                Icon(
                                                          Icons.star_outlined,
                                                          size: 2.h,
                                                          color: yellowClr,
                                                        ),
                                                        rating: averageRatings,
                                                        itemCount: 1,
                                                        itemSize: 3.h,
                                                      ),

                                                      SizedBox(width: 2.w),
                                                      Text(
                                                        serviceProviderDetails
                                                                    .averageRatings ==
                                                                0
                                                            ? '0'
                                                            : '${serviceProviderDetails.averageRatings}',
                                                        style: TextStyle(
                                                          fontSize: 1.6.h,
                                                          letterSpacing: 0.05.w,
                                                          color:
                                                              Colors.grey[800],
                                                        ),
                                                      ),
                                                      SizedBox(width: 1.w),
                                                      Text(
                                                        '($totalReviews Reviews)',
                                                        style: TextStyle(
                                                          fontSize: 1.6.h,
                                                          letterSpacing: 0.06.w,
                                                          color:
                                                              Colors.grey[800],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 1.h),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 2.w,
                                                      vertical: 1.h,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[50],
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  4)),
                                                    ),
                                                    child: SizedBox(
                                                      child: CustomerReview(),
                                                      height: 15.h,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Divider(
                                              color: Colors.black38,
                                              height: 2.w,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 0.8.h),
                                                  child: Text(
                                                    'Business information',
                                                    style: TextStyle(
                                                      fontSize: 1.8.h,
                                                      color: Colors.grey[700],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 0.05.w,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 1.h),
                                                  width: 100.w,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[50],
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(4)),
                                                  ),
                                                  padding: EdgeInsets.all(2.w),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        serviceProviderDetails
                                                                    .companyName ==
                                                                null
                                                            ? 'Company name: Loading...'
                                                            : 'Company name: ${serviceProviderDetails.companyName}',
                                                        style: TextStyle(
                                                          fontSize: 1.7.h,
                                                          letterSpacing: .03.w,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Divider(
                                                        height: 1.w,
                                                        color: Colors.white70,
                                                      ),
                                                      Text(
                                                        serviceProviderDetails
                                                                    .foundingYear ==
                                                                null
                                                            ? 'Founding year: Loading...'
                                                            : 'Founding year: ${serviceProviderDetails.foundingYear}',
                                                        style: TextStyle(
                                                          fontSize: 1.7.h,
                                                          letterSpacing: .03.w,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Divider(
                                                        height: 1.w,
                                                        color: Colors.white70,
                                                      ),
                                                      Text(
                                                        serviceProviderDetails
                                                                    .numberEmployees ==
                                                                null
                                                            ? 'Number of employees: Loading...'
                                                            : 'Number of employees: ${serviceProviderDetails.numberEmployees}',
                                                        style: TextStyle(
                                                          fontSize: 1.7.h,
                                                          letterSpacing: .03.w,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Divider(
                                                        height: 1.w,
                                                        color: Colors.white70,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 0.5.h),
                                                      child: Text(
                                                        'Business description: ',
                                                        style: TextStyle(
                                                          fontSize: 1.7.h,
                                                          letterSpacing: .03.w,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 100.w,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 2.w),
                                                      margin: EdgeInsets.only(
                                                          bottom: 2.5.h),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[50],
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    4)),
                                                      ),
                                                      child: Text(
                                                        serviceProviderDetails
                                                                    .businessGoal ==
                                                                null
                                                            ? 'Loading...'
                                                            : '${serviceProviderDetails.businessGoal}',
                                                        style: TextStyle(
                                                          fontSize: 1.7.h,
                                                          letterSpacing: .03.w,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.black38,
                                              height: 2.w,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                bottom: 1.h,
                                                top: 0.5.h,
                                              ),
                                              width: 100.w,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Other way to get service',
                                                    style: TextStyle(
                                                      fontSize: 1.8.h,
                                                      color: Colors.grey[700],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 0.05.w,
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 0.8.h),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 1.w),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[50],
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  4)),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        ListTile(
                                                          onTap: () {
                                                            debugPrint(
                                                                'Instant call clicked');
                                                          },
                                                          // leading: Text(
                                                          //   '1',
                                                          //   style: TextStyle(
                                                          //     fontSize: 1.8.h,
                                                          //     letterSpacing: 0.03.w,
                                                          //     color: Colors.black87,
                                                          //   ),
                                                          // ),
                                                          title: Text(
                                                            'Get instant service over phone',
                                                            style: TextStyle(
                                                              fontSize: 2.h,
                                                              letterSpacing:
                                                                  0.03.w,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                          subtitle: Text(
                                                            'Cost only \$${serviceProviderDetails.instantService}/hr',
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                              fontSize: 1.7.h,
                                                              color: const Color
                                                                  .fromARGB(
                                                                255,
                                                                0,
                                                                87,
                                                                114,
                                                              ),
                                                              letterSpacing:
                                                                  0.03.w,
                                                            ),
                                                          ),
                                                          trailing: Icon(
                                                            Icons
                                                                .install_mobile,
                                                            size: 4.h,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: Colors.white,
                                                          height: 2.w,
                                                        ),
                                                        ListTile(
                                                          onTap: () {
                                                            debugPrint(
                                                                'Instant call clicked');
                                                          },
                                                          // leading: Text(
                                                          //   '1',
                                                          //   style: TextStyle(
                                                          //     fontSize: 1.8.h,
                                                          //     letterSpacing: 0.03.w,
                                                          //     color: Colors.black87,
                                                          //   ),
                                                          // ),
                                                          title: Text(
                                                            'Get delay service in house',
                                                            style: TextStyle(
                                                              fontSize: 2.h,
                                                              letterSpacing:
                                                                  0.03.w,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                          subtitle: Text(
                                                            'Cost only \$${serviceProviderDetails.homeService}/hr',
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                              fontSize: 1.7.h,
                                                              color: const Color
                                                                  .fromARGB(
                                                                255,
                                                                0,
                                                                87,
                                                                114,
                                                              ),
                                                              letterSpacing:
                                                                  0.03.w,
                                                            ),
                                                          ),
                                                          trailing: Icon(
                                                            Icons.home,
                                                            size: 5.h,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget rating() => RatingStars(
        value: Provider.of<SearchProvider>(context).averageRatings,
        maxValue: 5,
        starCount: 1,
        starOffColor: Colors.grey,
      );

  _showDialogForAppointment() {
    return showDialog(
        context: context,
        builder: (BuildContext appointmentContext) {
          return Center(
            child: Card(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.5.w),
                height: 30.h,
                width: 95.w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 18.w,
                          child: Center(
                            child: Text(
                              'Type',
                              style: TextStyle(
                                fontSize: 2.h,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 18.w,
                          child: Center(
                            child: Text(
                              'StartTime',
                              style: TextStyle(
                                fontSize: 2.h,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 18.w,
                          child: Center(
                            child: Text(
                              'Duration',
                              style: TextStyle(
                                fontSize: 2.h,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 18.w,
                          child: Center(
                            child: Text(
                              'Date',
                              style: TextStyle(
                                fontSize: 2.h,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 18.w,
                          child: Center(
                            child: Text(
                              'Status',
                              style: TextStyle(
                                fontSize: 2.h,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Consumer<Appointment>(
                          builder: (context, appointment, child) {
                        return ListView.builder(
                          itemCount: appointment.appointmentId.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                _showDialogForBooking(index);
                                // appointment
                                //     .customerConfirmAppointment(
                                //   appointment.appointmentId[index],
                                //   appointment.appointmentType[index],
                                //   customerId,
                                // )
                                //     .then((value) {
                                //   if (value.statusCode == 201) {
                                //     setState(() {
                                //       _isLoading = false;
                                //     });
                                //     ScaffoldMessenger.of(context).showSnackBar(
                                //       const SnackBar(
                                //         content: Text(
                                //             'Appointment booked successfull'),
                                //       ),
                                //     );
                                //     Navigator.pop(appointmentContext);
                                //     debugPrint(
                                //         'appointment booked: ${appointment.appointmentId[index]}');
                                //   } else {
                                //     setState(() {
                                //       _isLoading = false;
                                //     });
                                //     ScaffoldMessenger.of(context).showSnackBar(
                                //       const SnackBar(
                                //         content:
                                //             Text('Appointment booked failed'),
                                //       ),
                                //     );
                                //     Navigator.pop(appointmentContext);
                                //     debugPrint(
                                //         'appointment booked: ${appointment.appointmentId[index]}');
                                //   }
                                // });

                                // setState(() {
                                //   Navigator.pop(context);
                                //   _isLoading = true;
                                // });
                              },
                              child: SizedBox(
                                height: 6.h,
                                width: 95.w,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 18.w,
                                      child: Center(
                                        child: Text(
                                          '${appointment.appointmentType[index]}',
                                          style: TextStyle(
                                            fontSize: 2.h,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 18.w,
                                      child: Center(
                                        child: Text(
                                          '${appointment.appointmentStartTime[index]}',
                                          style: TextStyle(
                                            fontSize: 2.h,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 18.w,
                                      child: Center(
                                        child: Text(
                                          '${appointment.appointmentDuration[index]}',
                                          style: TextStyle(
                                            fontSize: 2.h,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 18.w,
                                      child: Center(
                                        child: Text(
                                          '${appointment.appointmentDate[index]}',
                                          style: TextStyle(
                                            fontSize: 2.h,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 18.w,
                                      child: Center(
                                        child: Text(
                                          '${appointment.appointmentStatus[index]}',
                                          style: TextStyle(
                                            fontSize: 2.h,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  _showDialogForBooking(
    var confirm,
  ) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext bookingContext) {
        return Container(
          height: 15.h,
          width: 70.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Do you want to book this provider?',
                style: TextStyle(
                  fontSize: 2.h,
                  letterSpacing: 0.03.w,
                ),
              ),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Consumer<Appointment>(builder: (context, appointment, index) {
                    return ElevatedButton(
                      onPressed: () {
                        appointment
                            .customerConfirmAppointment(
                          appointment.appointmentId[confirm],
                          appointment.appointmentType[confirm],
                          customerId,
                        )
                            .then((value) {
                          if (value.statusCode == 200) {
                            setState(() {
                              _isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Appointment booked successfull'),
                              ),
                            );
                            Navigator.pop(bookingContext);
                            debugPrint(
                                'appointment booked: ${appointment.appointmentId[confirm]}');
                          } else {
                            setState(() {
                              _isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Appointment booked failed'),
                              ),
                            );
                            Navigator.pop(bookingContext);
                          }
                        });

                        // setState(() {
                        //   Navigator.pop(context);
                        //   _isLoading = true;
                        // });
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 2.2.h,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'Confirm',
                            style: TextStyle(
                              fontSize: 2.h,
                              letterSpacing: 0.03.w,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(width: 10.w),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.error,
                        width: 1.w,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(bookingContext);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.cancel_outlined,
                          size: 2.2.h,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 2.h,
                            letterSpacing: 0.03.w,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  _showDialogForPref() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Card(
              child: Container(
                height: 28.h,
                width: 70.w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: Column(
                  children: [
                    Text(
                      'Please login to mark as favorite',
                      style: TextStyle(
                        fontSize: 1.9.h,
                        letterSpacing: 0.025.w,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/loginScreen');
                        },
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 2.h,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.03.w,
                          ),
                        ))
                  ],
                ),
              ),
            ),
          );
        });
  }
}
