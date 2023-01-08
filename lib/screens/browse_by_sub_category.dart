import 'dart:async';

// import 'package:consult_24/providers/category_subcategory.dart';
import 'package:consult_24/providers/category_subcategory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../providers/appointment.dart';
import '../providers/search_provider.dart';

class BrowseBySubCategory extends StatefulWidget {
  int? subCategoryId;
  List serviceName = [];
  List serviceDescription = [];
  List appointmentCost = [];
  List searchingResult = [];
  Map subCategories = {};

  @override
  State<BrowseBySubCategory> createState() => _BrowseBySubCategoryState();
}

class _BrowseBySubCategoryState extends State<BrowseBySubCategory> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    // Provider.of<CategorySubCategory>(context, listen: false);
    Timer(const Duration(milliseconds: 1500), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    var provider = Provider.of<SearchProvider>(context, listen: false);
    setState(() {
      widget.searchingResult = provider.browseBySubCategory;
      widget.subCategoryId = provider.browseBySubCategoryId;
      widget.appointmentCost = provider.browseBySubCategoryCost;
      widget.serviceDescription = provider.browseBySubCategoryDescription;
      widget.serviceName = provider.browseBySubCategoryServiceName;
      widget.subCategories =
          Provider.of<CategorySubCategory>(context, listen: false)
              .subCategoriesGet;
    });
    super.didChangeDependencies();
  }

  // @override
  // void dispose() {
  //   widget.searchingResult.clear();
  //   widget.appointmentCost.clear();
  //   widget.serviceDescription.clear();
  //   widget.serviceName.clear();
  //   widget.subCategoryId;
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    debugPrint('Browse by category');
    debugPrint('${widget.serviceDescription}');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: widget.subCategories[widget.subCategoryId]!.isEmpty
            ? const Text('search result')
            : Text('${widget.subCategories[widget.subCategoryId]}'),
        centerTitle: true,
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
                    horizontal: 1.w,
                    vertical: 1.h,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: widget.searchingResult.isEmpty
                      ? Text(
                          'No result found..!',
                          style:
                              TextStyle(fontSize: 3.h, color: Colors.black54),
                        )
                      : ListView.builder(
                          itemCount: widget.searchingResult.length,
                          itemBuilder: (context, index) {
                            return Consumer<SearchProvider>(
                              builder: (context, searchResult, child) {
                                return InkWell(
                                  onTap: () {
                                    var serviceId =
                                        searchResult.searchResultIds[index];
                                    var userId =
                                        searchResult.serviceProviderId[index];
                                    if (serviceId != null) {
                                      searchResult.getServiceDetails(serviceId);
                                    }
                                    searchResult.getProviderDetails(userId);
                                    searchResult.getProviderPic(userId);
                                    searchResult.getServiceImageFile(
                                        user: userId, service: serviceId);

                                    Provider.of<Appointment>(context,
                                            listen: false)
                                        .serviceAppointmentAvaility(serviceId);
                                    Navigator.pushNamed(
                                      context,
                                      '/searchDetailsScreen',
                                    );
                                  },
                                  child: Container(
                                    height: 8.h,
                                    width: 100.w,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 1.w,
                                      horizontal: 2.w,
                                    ),
                                    margin: EdgeInsets.only(
                                      bottom: 1.h,
                                      left: 1.w,
                                      right: 1.w,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 8.h,
                                          width: 70.w,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${widget.serviceName[index]}',
                                                style: TextStyle(
                                                  fontSize: 1.8.h,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                  letterSpacing: 0.04.w,
                                                ),
                                              ),
                                              SizedBox(height: 1.w),
                                              Text(
                                                'Service description: ${widget.serviceDescription[index].toString().substring(0, 4)}',
                                                maxLines: 3,
                                                style: TextStyle(
                                                  fontSize: 1.5.h,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black87,
                                                  letterSpacing: 0.02.w,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8.h,
                                          width: 20.w,
                                          child: Container(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Cost\nonly \$${widget.appointmentCost[index]}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 1.7.h,
                                                    letterSpacing: .1.w,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
        ),
      ),
    );
  }
}
