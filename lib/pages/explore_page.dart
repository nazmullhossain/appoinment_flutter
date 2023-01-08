// built in dart packages
import 'dart:async';

// import 'package:consult_24/screens/search_result_screen.dart';
// import 'package:consult_24/providers/auth_manage.dart';

import '../pages/home_pages/provider_home_page.dart';
import '../providers/local_storage.dart';
import '../providers/search.dart';
import '../providers/search_provider.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../bot_nav_components/explore/trendy_topics.dart';

// manageable widgets
import '../bot_nav_components/explore/categories/categories.dart';

class ExplorePages extends StatefulWidget {
  @override
  State<ExplorePages> createState() => _ExplorePagesState();
}

class _ExplorePagesState extends State<ExplorePages> {
  int? roleId;
  int? id;
  String? zipCode;

  var filteredKeyword;

  bool onFocus = false;
  bool _autoFocus = false;
  bool searching = false;
  bool _isLoading = true;

  // var resultCode;
  // var resultBody;
  final TextEditingController searchText = TextEditingController();
  final TextEditingController _getZipCode = TextEditingController();
  var allSuggestions = [];

  var recentSearch = [
    'Air Cooler Cleaning',
    'Roof painting',
    'office decoration',
    'Fitness trainer',
    'Floor Cleaning',
    'Dogs Care',
    'Desktop clean',
    'Car wash',
  ];

  @override
  void initState() {
    super.initState();
    Provider.of<SearchHelper>(context, listen: false).getLocalStorageData();
    Provider.of<SearchHelper>(context, listen: false).getAllKeyword();
    Provider.of<LocalData>(context, listen: false).getLocalData();
    Timer(const Duration(milliseconds: 2000), () {
      setState(() {
        _isLoading = false;
      });
    });
    setState(() {
      onFocus = false;
    });
  }

  _getServiceList() async {
    searching = true;
    try {
      await Provider.of<SearchProvider>(context, listen: false).searchProfile(
        searchText.text,
        zipCode.toString(),
      );
      Navigator.pushNamed(context, '/searchResult');
    } catch (error) {
      searching = false;
      debugPrint('Service list getting error: $error');
    }
  }

  @override
  void dispose() {
    searchText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height;
    // print(Provider.of<LocalData>(context, listen: false).userRole);
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: 100.h,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Center(
            child: _isLoading == true
                ? CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                  )
                : Column(
                    children: [
                      Consumer<LocalData>(
                        builder: (context, authData, child) {
                          return Expanded(
                            child: authData.userRole == 3
                                ? ProviderScreen()
                                : SizedBox(
                                    height: 100.h,
                                    width: 100.w,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 0,
                                          child: SizedBox(
                                            height: 25.h,
                                            width: 100.w,
                                            child: Image.asset(
                                              'assets/images/app_home_screen_image.jpg',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 17.h,
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 5.w,
                                            ),
                                            color: Colors.white,
                                            width: 90.w,
                                            child: Consumer<SearchHelper>(
                                                builder: (context, searchHelper,
                                                    child) {
                                              return TextField(
                                                autofocus: _autoFocus,
                                                controller: searchText,
                                                cursorColor: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                cursorHeight: 3.h,
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                onTap: () {
                                                  setState(() {
                                                    onFocus = true;

                                                    filteredKeyword =
                                                        recentSearch;
                                                  });

                                                  // debugPrint(filteredKeyword);
                                                },
                                                onChanged: (value) {
                                                  setState(() {
                                                    filteredKeyword = searchHelper
                                                        .allSuggestions
                                                        .where(
                                                            (suggestionResult) {
                                                      final suggestionLower =
                                                          suggestionResult
                                                              .toString()
                                                              .toLowerCase();
                                                      final searchTextLower =
                                                          value.toLowerCase();

                                                      return suggestionLower
                                                          .contains(
                                                              searchTextLower);
                                                    }).toList();
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  hintText: 'Search anything',
                                                  hintStyle: TextStyle(
                                                    fontSize: 2.h,
                                                    fontFamily:
                                                        GoogleFonts.montserrat()
                                                            .fontFamily,
                                                    letterSpacing: -0.5,
                                                    wordSpacing: 0.5,
                                                  ),
                                                  fillColor: Colors.white,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                    horizontal: 20,
                                                  ),
                                                  focusedBorder:
                                                      const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  prefixIcon: IconButton(
                                                    icon: Icon(
                                                      Icons.arrow_back,
                                                      size: 3.h,
                                                    ),
                                                    onPressed: () {
                                                      searchText.clear();
                                                      searchText.text = '';
                                                      setState(() {
                                                        _autoFocus = false;
                                                        onFocus = false;
                                                        searching = false;
                                                      });
                                                    },
                                                  ),
                                                  suffixIcon: SizedBox(
                                                    width: 24.w,
                                                    child: Row(
                                                      children: [
                                                        IconButton(
                                                          onPressed:
                                                              showDialogForZip,
                                                          icon: Icon(
                                                            Icons
                                                                .location_on_sharp,
                                                            size: 3.h,
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            vertical: 1.2.h,
                                                          ),
                                                          alignment:
                                                              Alignment.center,
                                                          color: Colors.red,
                                                        ),
                                                        IconButton(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            vertical: 1.2.h,
                                                          ),
                                                          onPressed: () {
                                                            if (zipCode == '' &&
                                                                searchText
                                                                        .text ==
                                                                    '') {
                                                              if (searchText
                                                                      .text ==
                                                                  '') {
                                                                showDialogSearch();
                                                              } else if (zipCode ==
                                                                  '') {
                                                                showDialogForZip();
                                                              }
                                                            } else {
                                                              _getServiceList();
                                                            }
                                                          },
                                                          icon: Icon(
                                                            Icons
                                                                .search_outlined,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                            size: 3.h,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                        if (onFocus == true &&
                                            filteredKeyword != null)
                                          Positioned(
                                            top: 22.h,
                                            child: Center(
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: 5.w,
                                                ),
                                                color: Colors.white,
                                                height: 70.h,
                                                width: 90.w,
                                                child: ListView.builder(
                                                  itemCount:
                                                      filteredKeyword.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          index) {
                                                    // debugPrint(filteredKeyword);
                                                    var suggestion =
                                                        filteredKeyword[index];

                                                    return ListTile(
                                                      onTap: () {
                                                        searchText.text =
                                                            suggestion;
                                                      },
                                                      leading: Icon(
                                                        Icons.search_sharp,
                                                        size: 4.h,
                                                      ),
                                                      title: Text(suggestion),
                                                    );
                                                  },
                                                  scrollDirection:
                                                      Axis.vertical,
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (onFocus == false &&
                                            searchText.text == '')
                                          Positioned(
                                            top: 25.h,
                                            child: SizedBox(
                                              height: 60.h,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 0.1.h,
                                                    ),
                                                    SizedBox(
                                                      height: 22.h,
                                                      width: 100.w,
                                                      child: Categories(),
                                                    ),
                                                    SizedBox(
                                                      width: 100.w,
                                                      // height: 40.h,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: 5.w,
                                                          top: 1.h,
                                                        ),
                                                        child: TrendyTopicsUI(),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  showDialogSearch() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Card(
              child: Container(
                height: 20.h,
                width: 70.w,
                padding: EdgeInsets.symmetric(
                  horizontal: 5.w,
                  vertical: 2.h,
                ),
                color: Colors.transparent,
                child: Stack(
                  children: [
                    Positioned(
                      top: 2,
                      right: 2,
                      child: InkWell(
                        onTap: Navigator.of(context).pop,
                        child: const Text('X'),
                      ),
                    ),
                    const Center(
                      child: Text('Please write something to search'
                          ' or'
                          ' accept our suggesstion'),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  showDialogForZip() {
    return showDialog(
      context: context,
      builder: (BuildContext contex) {
        return Center(
          child: Card(
            child: Container(
              height: 28.h,
              width: 80.w,
              padding: EdgeInsets.symmetric(
                vertical: 5.w,
              ),
              color: Colors.transparent,
              child: Stack(
                children: [
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 3.w,
                        ),
                        child: Text(
                          'Please enter your local or desire zip code.',
                          softWrap: true,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Zip: ',
                            style: TextStyle(
                              fontSize: 1.8.h,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: 1.2.w,
                            ),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          SizedBox(
                            width: 50.w,
                            child: TextFormField(
                              controller: _getZipCode,
                              autofocus: true,
                              keyboardType: TextInputType.streetAddress,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  gapPadding: 10.w,
                                ),
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.location_on,
                                  size: 3.h,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            zipCode = _getZipCode.text;

                            if (searchText.text != '') {
                              _getServiceList;
                            }

                            Navigator.pop(context);
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 1.h,
                          ),
                          child: Text(
                            'OK',
                            style: TextStyle(
                              fontSize: 2.h,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
