import 'package:consult_24/providers/category_subcategory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../providers/search_provider.dart';

class BrowseByCategory extends StatefulWidget {
  Map subCategoryList = {};
  List subCategoryIds = [];
  List subCategoryNames = [];

  String? categoryName;

  TextEditingController zipCode = TextEditingController();

  @override
  State<BrowseByCategory> createState() => _BrowseByCategoryState();
}

class _BrowseByCategoryState extends State<BrowseByCategory> {
  @override
  void didChangeDependencies() {
    var catSubCat = Provider.of<CategorySubCategory>(context, listen: false);

    setState(() {
      widget.subCategoryList = catSubCat.subCategoriesPost;
      widget.subCategoryIds = catSubCat.subCategoryIds;
      widget.subCategoryNames = catSubCat.subCategoryNames;
      widget.categoryName = catSubCat.categoryName;
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    widget.categoryName;
    widget.subCategoryList.clear();
    widget.subCategoryNames.clear();
    widget.subCategoryIds.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back)),
        title: Text('${widget.categoryName}'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          height: 100.h,
          width: 100.w,
          margin: EdgeInsets.symmetric(
            horizontal: 1.w,
            vertical: 1.w,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 2.w,
            vertical: 1.h,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Container(
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
            child: ListView.builder(
              itemCount: widget.subCategoryList.length,
              itemBuilder: (context, index) {
                return Consumer<SearchProvider>(
                  builder: (context, subCatSearch, child) {
                    return InkWell(
                      onTap: () {
                        showDialogForZip(widget.subCategoryIds[index]);
                      },
                      child: Container(
                        height: 5.h,
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
                        child: SizedBox(
                          height: 5.h,
                          width: 70.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.subCategoryNames[index]}',
                                style: TextStyle(
                                  fontSize: 2.h,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  letterSpacing: 0.3.w,
                                ),
                              ),
                            ],
                          ),
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

  showDialogForZip(int? index) {
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
                              controller: widget.zipCode,
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
                            widget.zipCode = widget.zipCode;
                          });

                          Provider.of<SearchProvider>(context, listen: false)
                              .subCategoryResult(index, widget.zipCode.text)
                              .then((value) {
                            if (value.statusCode == 200) {
                              Navigator.pushNamed(
                                context,
                                '/browseBySubCategory',
                              );
                            }
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 1.h,
                          ),
                          child: Text(
                            'Go',
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
