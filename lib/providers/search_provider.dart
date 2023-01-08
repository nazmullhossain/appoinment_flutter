import 'dart:convert';

// import 'package:consult_24/providers/call_api.dart';
import 'package:consult_24/models/service_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchProvider with ChangeNotifier {
  ProviderDetails? providerDetails;

  int? serviceId;
  String? serviceName;
  var serviceExpYear;
  var serviceAbility = false;

  // var serviceUserId;
  // var serviceCategory;
  // var serviceSubCategory;

  var searchResultIds = [];
  var searchResultNames = [];
  var searchResultExperiences = [];
  var searchResultDetails = [];
  var serviceProviderId = [];

  var detailsServiceId = [];

  var searchResults = {};

  // provider and service details for showing details

  String? serviceTitle;
  String? address;
  String? serviceDescription;
  var appointmentCost;
  int experienceYear = 0;

  int? desireProviderId;
  String? providerUserName;
  String? providerImg;
  String? providerName;
  String? providerStatus;
  String? foundingYear;
  String? numberEmployees;
  String? companyName;
  String? businessGoal;

  double averageRatings = 4.8;
  int totalReviews = 12;

  int instantService = 13;
  int homeService = 8;

  String? serviceImg;
  String? serviceCertificate;

  var positiveIds = [];
  var negativeIds = [];

  // api calling

// search profile
  Future searchProfile(String searchText, String zipCode) async {
    var getServiceApi = Uri.parse(
        'https://c24apidev.accelx.net/api/SearchServiceList/?zip_code=$zipCode&search=$searchText');

    try {
      var responseServiceGet = await http.get(getServiceApi);

      // debugPrint('Searching result: ${responseServiceGet.statusCode}');
      // debugPrint('Searching details: ${json.decode(responseServiceGet.body)}');

      var responseBody = json.decode(responseServiceGet.body);

      if (responseServiceGet.statusCode == 200) {
        for (var i = 0; i < responseBody.length; i++) {
          searchResultIds.add(responseBody?[i]?['id']);
          searchResultNames.add(responseBody?[i]?['service_name']);
          searchResultExperiences
              .add(responseBody?[i]?['service_experiance_year']);
          searchResultDetails.add(responseBody?[i]?['service_description']);
          serviceProviderId.add(responseBody?[i]?['service_user']);
        }

        searchResults = Map.fromIterables(searchResultNames, searchResultIds);

        notifyListeners();
      }
    } catch (error) {
      debugPrint('service get result error: $error');
    }

    notifyListeners();
  }

// get service details
  Future getServiceDetails(var detailsId) async {
    var detailsApi = Uri.parse(
        'https://c24apidev.accelx.net/api/Search_Service_Details/$detailsId');

    try {
      var responseDetails = await http.get(detailsApi);

      var detailsBody = json.decode(responseDetails.body);

      // debugPrint('serviceList : ${responseDetails.statusCode}');

      debugPrint('service details body: $detailsBody');

      if (responseDetails.statusCode == 200) {
        serviceTitle = detailsBody?['service_name'];
        appointmentCost = detailsBody?['rate_apt_video_cons'];
        instantService = int.parse(detailsBody?['rate_inst_video_cons']);
        homeService = int.parse(detailsBody?['rate_inhouse_cons']);
        serviceDescription = detailsBody?['service_description'];
        // debugPrint(serviceTitle);
        // return serviceTitle;

        notifyListeners();
      }
    } catch (error) {
      debugPrint('service details error: $error');
    }
    notifyListeners();
  }

// get service image file
  Future getServiceImageFile({
    @required var user,
    @required var service,
  }) async {
    var serviceImageFileApi = Uri.parse(
        'https://c24apidev.accelx.net/api/servicefileGet_APIView/?user_id=$user&service_id=$service');

    try {
      var serviceImageFileresponse = await http.get(
        serviceImageFileApi,
        headers: {'Content-Type': 'application/json'},
      );

      var serviceImgFileBody = json.decode(serviceImageFileresponse.body);

      debugPrint(
          'getServiceImageFile status: ${serviceImageFileresponse.statusCode}');

      debugPrint('getServiceImageFile: $serviceImgFileBody');

      if (serviceImageFileresponse.statusCode == 200) {
        serviceImg = serviceImgFileBody.last?['service_image'];
        serviceCertificate = serviceImgFileBody.last?['service_description'];
      }
    } catch (error) {
      debugPrint('getServiceImageFile error: $error');
    }
  }

//  get provider Details
  Future getProviderDetails(var providerId) async {
    var providerDetailsApi = Uri.parse(
        'https://c24apidev.accelx.net/auth_api/search_result_for_provider_info/${providerId.toString()}');
    try {
      var providerDetailsResponse = await http.get(
        providerDetailsApi,
        headers: {'Content-type': 'application/json'},
      );
      // await CallApi().getData('/auth_api/provider_profile/$providerId');

      var providerDetailsBody = json.decode(providerDetailsResponse.body);

      debugPrint('Provider details: $providerDetailsBody');
      debugPrint(
          'Provider details status: ${providerDetailsResponse.statusCode}');
      if (providerDetailsResponse.statusCode == 200) {
        var strAdd = providerDetailsBody?['address']?[0]?['street_address'];

        var cityAdd = providerDetailsBody?['address']?[0]?['city'];
        var county = providerDetailsBody?['address']?[0]?['country'];

        address = '$strAdd, $cityAdd, $county';
        // providerDetails = ProviderDetails.fromJSON(providerDetailsBody);

        var fstNam = providerDetailsBody?['user']?['first_name'];
        var lstNam = providerDetailsBody?['user']?['last_name'];

        providerUserName = providerDetailsBody?['user']?['username'];
        desireProviderId = providerDetailsBody?['user']?['id'];

        providerName = '$fstNam $lstNam';

        averageRatings =
            double.parse(providerDetailsBody?['provider']?['avg_rating']);

        // experienceYear =
        //     int.parse(providerDetailsBody?['provider']?['experience_level']);
        foundingYear = providerDetailsBody?['provider']?['founding_year'];
        numberEmployees =
            providerDetailsBody?['provider']?['number_of_employees'];
        businessGoal = providerDetailsBody?['provider']?['businees_goal'];
        companyName = providerDetailsBody?['provider']?['company_name'];

        notifyListeners();
      }
      return providerDetailsResponse;
    } catch (error) {
      debugPrint('Provider details error: $error');
    }
    notifyListeners();
  }

// get provider profile picture
  Future getProviderPic(var providerId) async {
    final profilePicApi = Uri.parse(
        'https://c24apidev.accelx.net/auth_api/Search_Service_Provider_Profile_Picture/?user_id=$providerId');

    try {
      var resApi = await http.get(profilePicApi);

      var proPicBody = json.decode(resApi.body);

      debugPrint('Propic res: ${resApi.statusCode}');
      if (resApi.statusCode == 200) {
        providerImg = proPicBody.last?['profile_picture'];

        notifyListeners();
      }
    } catch (error) {
      debugPrint('pro pic error: $error');
    }
    notifyListeners();
  }

  // categoryWise Search
  var browseBySubCategory;
  int? browseBySubCategoryId;
  List browseBySubCategoryServiceName = [];
  List browseBySubCategoryDescription = [];
  List browseBySubCategoryCost = [];
  Future subCategoryResult(
    int? subCategoryId,
    String? zipCode,
  ) async {
    final api = Uri.parse(
        'https://c24apidev.accelx.net/api/SubCategoryWiseServiceInfo/?sub_category_id=$subCategoryId&zip_code=$zipCode');

    try {
      var response = await http.get(
        api,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      browseBySubCategory = json.decode(response.body);

      debugPrint('cate data: $browseBySubCategory');

      if (response.statusCode == 200) {
        browseBySubCategoryId =
            browseBySubCategory?[0]?['service_sub_category'];
        for (var i = 0; i < browseBySubCategory.length; i++) {
          browseBySubCategoryServiceName
              .add(browseBySubCategory[i]?['service_name']);
          browseBySubCategoryDescription
              .add(browseBySubCategory[i]?['service_description']);
          browseBySubCategoryCost
              .add(browseBySubCategory[i]?['rate_apt_video_cons']);

          searchResultIds.add(browseBySubCategory[i]?['id']);
          serviceProviderId.add(browseBySubCategory[i]?['service_user']);

          // debugPrint("$browseByCategoryServiceName");

          // if (browseByCategoryServiceName?.length == browseByCategory.length)

        }
        return response;
      }
    } catch (error) {
      debugPrint('Categorywise error: $error');
    }
  }
}
