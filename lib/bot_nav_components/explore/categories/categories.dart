// built in packages to make app running
import 'package:consult_24/providers/category_subcategory.dart';
import 'package:consult_24/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../fake_data/fake_categories.dart';

// other packages to help function running

// stateless widget only for pass data to statefull widget and reuse this widget
class Categories extends StatelessWidget {
  var categoryFakeData = DUMMY_CATEGORIES
      .map((catData) => CategoryCard(
            categoryName: catData.categoryName,
            imageUrl: catData.imageUrl,
            iconName: catData.iconName,
            categoryId: catData.id,
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 1.h,
            horizontal: 4.w,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Browse by categories",
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.start,
              ),
              // TextButton(
              //   onPressed: () {
              //     Navigator.of(context).pushNamed('/allCategories');
              //   },
              //   child: const Text('See All >'),
              // ),
            ],
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
        Container(
          padding: EdgeInsets.only(
            left: width * 0.0010,
          ),
          height: 12.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categoryFakeData.length,
            itemBuilder: (context, index) => categoryFakeData[index],
            separatorBuilder: (context, _) => SizedBox(
              width: width * 0.0015,
            ),
          ),
        ),
        // const SizedBox(
        //   height: 5.0,
        // ),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  String? imageUrl;
  String? categoryName;
  IconData? iconName;
  int? categoryId;

  CategoryCard({
    this.categoryName,
    this.imageUrl,
    this.iconName,
    this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        var nextPage = Provider.of<CategorySubCategory>(context, listen: false);
        nextPage.getSpecCategoryData(categoryId);

        nextPage.getSubCategoryList(category: categoryId).then(
          (value) {
            debugPrint('Browse by category : ${value.statusCode}');
            if (value.statusCode == 200) {
              Navigator.pushNamed(context, '/browseByCategory');
            }
          },
        );
      },
      child: Container(
        width: 18.w,
        height: 10.h,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 1.h),
              height: 8.h,
              width: 16.w,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(iconName),
            ),
            Text(
              categoryName.toString(),
              style: TextStyle(
                fontSize: 2.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
