import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../models/call_api.dart';

class CategorySubCategory with ChangeNotifier {
  String? zipCode;

  String? categoryName;

  var categoryNames = [];
  var categoryIds = [];

  var categoriesPost = {};
  var categoriesGet = {};

  var subCategoryNames = [];
  var subCategoryIds = [];

  var subCategoriesPost = {};
  var subCategoriesGet = {};

  String _selectedCategory = '';

  String? selectedCategory;

  String? selectedSubCategory;

  Future getZipCode({@required int? userId}) async {
    try {
      var responseZip =
          await CallApi().getData('/auth_api/provider_profile/$userId');

      var zipBody = json.decode(responseZip.body);

      debugPrint('Zip: ${responseZip.body}');

      if (responseZip.statusCode == 200) {
        zipCode = zipBody?['address']?[0]?['zip_code'];
        notifyListeners();
      }

      return responseZip;
    } catch (error) {
      debugPrint('zipCode get error: $error');
    }
  }

  Future getSpecCategoryData(int? catId) async {
    try {
      var categoryResponse = await CallApi().getUnauthorizedData(
          '/api/ServiceCategoryListAPIView/?search=$catId');
      var categoryResponseBody = json.decode(categoryResponse.body);

      if (categoryResponse.statusCode == 200) {
        categoryName = categoryResponseBody[0]?['category_name'];
      }

      return categoryResponse;
    } catch (error) {
      debugPrint('getSpecCategoryData: $error');
    }
  }

  Future getCategoryList() async {
    try {
      var categoryResponse = await CallApi()
          .getUnauthorizedData('/api/ServiceCategoryListAPIView/');
      var categoryResponseBody = json.decode(categoryResponse.body);

      if (categoryResponse.statusCode == 200) {
        for (int i = 0; i < categoryResponseBody.length; i++) {
          categoryNames.add(categoryResponseBody[i]?['category_name']);
          categoryIds.add(categoryResponseBody[i]?['id']);

          notifyListeners();
        }

        categoriesPost = Map.fromIterables(categoryNames, categoryIds);
        categoriesGet = Map.fromIterables(categoryIds, categoryNames);

        notifyListeners();

        if (selectedCategory != null) {
          getSubCategoryList(category: categoriesPost[selectedCategory]);
        }
      }
      return categoryResponse;
    } catch (error) {
      debugPrint('category get error: $error');
    }
  }

  Future getSubCategoryList({@required var category}) async {
    try {
      var subCategoryResponse = await CallApi().getUnauthorizedData(
          '/api/CategoryWiseSubCategoryAPIView/?category_id=$category');

      var subCategoryBody = json.decode(subCategoryResponse.body);

      if (subCategoryResponse.statusCode == 200) {
        for (int i = 0; i < subCategoryBody.length; i++) {
          subCategoryNames
              .add(subCategoryBody[i]?["service_sub_category_name"]);
          subCategoryIds.add(subCategoryBody[i]?['id']);

          notifyListeners();
        }

        subCategoriesPost = Map.fromIterables(subCategoryNames, subCategoryIds);
        subCategoriesGet = Map.fromIterables(subCategoryIds, subCategoryNames);
        notifyListeners();
      }

      return subCategoryResponse;
    } catch (error) {
      debugPrint('sub category get error: $error');
    }
  }

  // var browseByCategory;
  // int? browseByCategoryId;
  // List browseByCategoryServiceName = [];
  // List browseByCategoryDescription = [];
  // List browseByCategoryCost = [];
  // Future categoryResult(int? categoryId) async {
  //   final api = Uri.parse(
  //       'https://c24apidev.accelx.net/api/CategoryWiseServiceInfo/?category_id=$categoryId');

  //   try {
  //     var response = await http.get(
  //       api,
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //     );

  //     browseByCategory = json.decode(response.body);

  //     debugPrint('cate data: $browseByCategory');

  //     if (response.statusCode == 200) {
  //       browseByCategoryId = browseByCategory?[0]?['service_category'];
  //       for (var i = 0; i < browseByCategory.length; i++) {
  //         browseByCategoryServiceName.add(browseByCategory[i]?['service_name']);
  //         browseByCategoryDescription
  //             .add(browseByCategory[i]?['service_description']);
  //         browseByCategoryCost.add(browseByCategory[i]?['rate_apt_video_cons']);

  //         print(browseByCategoryServiceName);

  //         // if (browseByCategoryServiceName?.length == browseByCategory.length)

  //       }
  //       return response;
  //     }
  //   } catch (error) {
  //     debugPrint('Categorywise error: $error');
  //   }
  // }
}
