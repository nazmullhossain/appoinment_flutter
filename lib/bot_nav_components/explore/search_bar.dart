// built in flutter packages
import 'dart:convert';

import 'package:consult_24/models/call_api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

// a single widget to do search only
class SearchBar extends StatefulWidget {
  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  int? roleId;
  int? id;
  String? zipCode;

  bool onFocus = true;
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
  ];

  @override
  void didChangeDependencies() async {
    SharedPreferences successLogin = await SharedPreferences.getInstance();
    var roleJson = successLogin.getInt('role');
    var roleDecode = json.decode(json.encode(roleJson));

    var logId = successLogin.getInt('loginId');
    var loginId = json.decode(json.encode(logId));

    setState(() {
      roleId = roleDecode;
      _getUserZip(loginId);
    });
    _getAllKeyword();
    super.didChangeDependencies();
  }

  _getAllKeyword() async {
    final keywordApi = Uri.parse('https://c24apidev.accelx'
        '.net/api/servicekeywordlistAPI_View/');

    try {
      var responseKeyword = await http.get(keywordApi);

      var keyWordBody = json.decode(responseKeyword.body);

      // print(keyWordBody?['service_keyword_list']);

      if (responseKeyword.statusCode == 200) {
        setState(() {
          allSuggestions = keyWordBody?['service_keyword_list'];
          print(allSuggestions);
        });
      }
    } catch (error) {
      print('Keyword list get error: $error');
    }
  }

  _getUserZip(int? userId) async {
    try {
      var responseZip = await CallApi().getData(
          '/auth_api/UserIDWiseAddressZipCodeAPIView/?user_id=$userId');

      print('user id:${responseZip.statusCode}');

      var responseZipBody = json.decode(responseZip.body);

      if (responseZip.statusCode == 200) {
        var userZipCode = responseZipBody?[0]?['zip_code'];

        setState(() {
          zipCode = userZipCode;
        });
      }
    } catch (error) {
      print('Getting error on userID: $error');
    }
  }

  _getServiceList() async {
    var getServiceApi = Uri.parse(
        'https://c24apidev.accelx.net/api/SearchServiceList/?zip_code=$zipCode&search=${searchText.text}');

    try {
      var responseServiceGet = await http.get(getServiceApi);

      print('Searching result: ${responseServiceGet.statusCode}');
    } catch (error) {
      print('service get result error: $error');
    }
  }

  @override
  void dispose() {
    searchText.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   searchText.addListener(_printLatestValue);
  // }

  _fetchSearch(String input) {}

  void _printLatestValue() {
    print('Second text field: ${searchText.text}');
  }

  onTextFieldSubmitted(String input) async {}

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    print(zipCode);
    return SafeArea(
      child: SizedBox(
        width: 100.w,
        height: 6.h,
        child: Row(
          children: [
            SizedBox(
              width: 76.w,
              child: TextFormField(
                // onChanged: (String input) {
                //   recentValues.add(input);
                //   print('Search value: $input');
                // },
                autofocus: false,
                enableSuggestions: true,
                controller: searchText,
                cursorColor: Theme.of(context).colorScheme.primary,
                cursorHeight: 3.h,
                textAlignVertical: TextAlignVertical.center,
                onTap: buildSuggetions,
                decoration: InputDecoration(
                  hintText: 'Search for getting help...',
                  hintStyle: TextStyle(
                    fontSize: 2.h,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                    letterSpacing: -0.5,
                    wordSpacing: 0.5,
                  ),
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  focusedBorder:
                      const OutlineInputBorder(borderSide: BorderSide.none),
                  prefixIcon: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 3.h,
                    ),
                    onPressed: () {
                      searchText.clear();
                      searchText.text = '';
                      buildSuggetions();
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 24.w,
              child: Row(
                children: [
                  IconButton(
                    onPressed: showDialogForZip,
                    icon: Icon(
                      Icons.location_on_sharp,
                      size: 3.h,
                      color: Colors.black87,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 1.2.h,
                    ),
                    alignment: Alignment.center,
                    color: Colors.red,
                  ),
                  IconButton(
                    padding: EdgeInsets.symmetric(
                      vertical: 1.2.h,
                    ),
                    onPressed: () {
                      if (zipCode == '' && searchText == '') {
                        if (searchText == '') {
                          showDialogSearch();
                        } else if (zipCode == '') {
                          showDialogForZip();
                        }
                      } else {
                        _getServiceList();
                      }
                    },
                    icon: Icon(
                      Icons.search_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 3.h,
                    ),
                  ),
                ],
              ),
            ),
            // ElevatedButton(onPressed: () {
            //   onTextFieldSubmitted(input);
            // }, child: child)
          ],
        ),
      ),
    );
  }

  _searchOperation(String searchText) {
    // searchResult.clear();
  }

  buildActions(BuildContext context) => [
        IconButton(
          onPressed: searchText.clear,
          icon: Icon(
            Icons.clear,
            size: 3.h,
            color: Colors.red,
          ),
        ),
      ];

  // Widget buildLeading(BuildContext context) => IconButton(
  //       onPressed: () {},
  //       icon: Icon(
  //         Icons.arrow_back,
  //         size: 3.h,
  //         color: Colors.black87,
  //       ),
  //     );

  buildResults() => Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [],
        ),
      );

  buildSuggetions() {
    var suggestions = searchText.text.toString().isEmpty
        ? recentSearch
        : allSuggestions.where((suggestionResult) {
            final suggestionLower = suggestionResult.toString().toLowerCase();
            final searchTextLower = searchText.text.toLowerCase();

            return suggestionLower.contains(searchTextLower);
          }).toList();

    return buildSuggestionsSuccess(suggestions);
  }

  buildSuggestionsSuccess(var suggestions) {
    print('suggestion building....');
    print(suggestions);
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, index) {
        var suggestion = suggestions[index];

        return ListTile(
          onTap: () {
            searchText.text = suggestion;
          },
          leading: const Icon(Icons.search_sharp),
          title: Text(suggestion),
        );
      },
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

                            if (searchText != null) {
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
                            'Save',
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

// https://c24apidev.accelx.net/api/SearchServiceList/?zip_code=1229&search=gardening
