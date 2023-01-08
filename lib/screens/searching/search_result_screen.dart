import 'dart:async';

import 'package:consult_24/providers/appointment.dart';
import 'package:consult_24/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SearchResult extends StatefulWidget {
  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  String? title;

  Widget? providerList;

  double avgRatings = 3;
  String? networkImage;
  String totalReview = '5';

  int counter = 1;

  bool isClicked = false;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  // SearchResult({
  @override
  Widget build(BuildContext context) {
    debugPrint('Widget Building');
    return Scaffold(
      appBar: AppBar(
        leading: Consumer<SearchProvider>(
            builder: (context, searchResultState, child) {
          return IconButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                searchResultState.searchResultNames = [];
                searchResultState.searchResultIds = [];
                searchResultState.searchResultDetails = [];
                searchResultState.searchResultExperiences = [];
                searchResultState.detailsServiceId = [];
              });
            },
            icon: const Icon(Icons.arrow_back),
          );
        }),
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
                  margin: EdgeInsets.symmetric(
                    vertical: 1.3.h,
                    horizontal: 1.w,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    child: Consumer<SearchProvider>(
                        builder: (context, searchResultState, child) {
                      return SizedBox(
                        height: 90.h,
                        width: 95.w,
                        child: ListView.builder(
                          // scrollDirection: Axis.vertical,
                          itemCount: searchResultState.searchResultIds.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Consumer<SearchProvider>(
                                builder: (context, searchResultState, child) {
                              return InkWell(
                                onTap: () async {
                                  // setState(() {
                                  //   isClicked = true;
                                  // });
                                  var detailsId =
                                      searchResultState.searchResultIds[index];

                                  var userId = searchResultState
                                      .serviceProviderId[index];

                                  debugPrint('$detailsId');

                                  if (detailsId != null) {
                                    searchResultState
                                        .getServiceDetails(detailsId);
                                  }

                                  searchResultState.getProviderDetails(userId);

                                  searchResultState.getProviderPic(userId);

                                  searchResultState.getServiceImageFile(
                                      user: userId, service: detailsId);
                                  Provider.of<Appointment>(context,
                                          listen: false)
                                      .serviceAppointmentAvaility(detailsId);

                                  Navigator.pushNamed(
                                      context, '/searchDetailsScreen');
                                },
                                child: Container(
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  // color: Colors.grey[100],
                                  margin: EdgeInsets.only(
                                    bottom: 1.5.h,
                                  ),
                                  child: Card(
                                    color: const Color.fromARGB(
                                        255, 255, 252, 239),
                                    child: Consumer<SearchProvider>(builder:
                                        (context, searchResultState, child) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding:
                                                EdgeInsets.only(right: 1.w),
                                            height: 12.h,
                                            width: 100.w,
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 12.h,
                                                  width: 18.w,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    image: DecorationImage(
                                                        image: searchResultState
                                                                    .serviceImg !=
                                                                null
                                                            ? NetworkImage(
                                                                searchResultState
                                                                    .serviceImg
                                                                    .toString(),
                                                              )
                                                            : Image.asset(
                                                                'assets/images/blur-image.jpg',
                                                              ).image,
                                                        fit: BoxFit.fitWidth),
                                                    border: Border.all(
                                                      color: Colors.grey,
                                                      width: 0.5.w,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          searchResultState
                                                                  .searchResultNames[
                                                              index],
                                                          style: TextStyle(
                                                            fontSize: 2.2.h,
                                                            color:
                                                                Colors.black87,
                                                            letterSpacing:
                                                                0.04.w,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          child: Row(
                                                            children: [
                                                              readStar(),
                                                              SizedBox(
                                                                width: 1.5.w,
                                                              ),
                                                              Text(
                                                                '($totalReview)',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black87,
                                                                  fontSize: 2.h,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 1.h,
                                                    ),
                                                    Text(
                                                      'Service Provider experience :   ${searchResultState.searchResultExperiences[index]}',
                                                      style: TextStyle(
                                                        fontSize: 1.8.h,
                                                        color: Colors.grey[900],
                                                        letterSpacing: 0.035.w,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 0.5.h,
                                                    ),
                                                    // SizedBox(
                                                    //   width: 75.w,
                                                    //   child: Text(
                                                    //     'Service description :  ${(searchResultState.searchResultDetails[index]).toString()}',
                                                    //     style: TextStyle(
                                                    //       fontSize: 1.6.h,
                                                    //       color:
                                                    //           Colors.grey[800],
                                                    //       letterSpacing:
                                                    //           0.035.w,
                                                    //     ),
                                                    //     maxLines: 4,
                                                    //     softWrap: true,
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              );
                            });
                          },
                        ),
                      );
                    }),
                  ),
                ),
        ),
      ),
    );
  }

  Widget readStar() => RatingBarIndicator(
        itemCount: 1,
        rating: avgRatings,
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
        itemSize: 2.2.h,
      );
}
