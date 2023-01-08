import 'dart:convert';

import 'package:consult_24/models/call_api.dart';
import 'package:flutter/material.dart';

class UpdateInformation with ChangeNotifier {
// ++++++++++++++++++++____Address update____+++++++++++++++++++
  String? stateName;
  String? zipCode;
  String? cityName;
  String? streetAddress;
  String? apartmentAddress;
  String? selectedCountry;

  int? addressUser;

  Future checking() async {
    print('chcked');
  }

// provider Update

  Future getProviderAddress(int? providerId) async {
    // print('function called');
    try {
      var response = await CallApi()
          .getData('/auth_api/Provider/AddressUpdate/$providerId');

      var address = json.decode(response.body);
      if (response.statusCode == 200) {
        streetAddress = address?['address']?[0]?['street_address'];
        apartmentAddress = address?['address']?[0]?['apt'];
        zipCode = address?['address']?[0]?['zip_code'];
        cityName = address?['address']?[0]?['city'];
        stateName = address?['address']?[0]?['state'];
        selectedCountry = address?['address']?[0]?['country'];
        addressUser = address?['address']?[0]?['address_user'];
      }
      return response;
    } catch (error) {
      debugPrint('provider address error: $error');
    }

    notifyListeners();
  }

  Future putProviderAddress(int? providerId, var data) async {
    try {
      var response = await CallApi()
          .putData(data, '/auth_api/Provider/AddressUpdate/$providerId');

      return response;
    } catch (error) {
      debugPrint('Put Provider Address error: $error');
    }
    notifyListeners();
  }

  // ++++++++++++++++++++____Profile picture update____+++++++++++++++++++

  int? picId;
  String? imageLink;

  // get profile picture
  Future getProviderImage(int? providerId) async {
    print('get image called');
    try {
      var response = await CallApi().getData(
          '/auth_api/ServiceProviderProfilePicture/?user_id=$providerId');

      var profilePicture = json.decode(response.body);

      debugPrint('Image get: ${response.statusCode}');

      if (response.statusCode == 200) {
        picId = profilePicture?[0]?['id'];
        imageLink = profilePicture?[0]?['profile_picture'];
      }

      return response;
    } catch (error) {
      debugPrint('image getting $error');
    }
    notifyListeners();
  }

  // ++++++++++++++++++++____Service Update____+++++++++++++++++++
}
