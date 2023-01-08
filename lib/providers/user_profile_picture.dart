import 'dart:convert';

import 'package:flutter/widgets.dart';

import '../models/call_api.dart';

class ProfilePicture with ChangeNotifier {
  int? proPicId;
  String? serverImg;

// ++++++++++++++++++++++++++++++++++++++++++++++++++++

//              Provider Profile Picture

// +++++++++++++++++++++++++++++++++++++++++++++++++++++

  getProviderImage() async {
    try {
      var responseProfilePicture =
          await CallApi().getData('/auth_api/ServiceProviderProfilePicture/');

      var responseProfilePictureBody =
          json.decode(responseProfilePicture?.body);

      try {
        var picId = responseProfilePictureBody?[0]?['id'];
        var serverImageLink =
            responseProfilePictureBody?[0]?['profile_picture'];

        proPicId = picId;
        serverImg = serverImageLink;

        debugPrint('${responseProfilePicture.statusCode}');
      } catch (error) {
        debugPrint('image getting $error');
      }
    } catch (error) {
      debugPrint('image getting $error');
    }
  }

  // +++++++++++++++++++++++++++++++++++++++++++++++++++++

  //                 Customer profile picture

  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++

  getCustomerImage() async {
    try {
      var responseProfilePicture =
          await CallApi().getData('/auth_api/CustomerProfilePicture/');

      var responseProfilePictureBody =
          json.decode(responseProfilePicture?.body);

      try {
        var picId = responseProfilePictureBody?[0]?['id'];
        var serverImageLink =
            responseProfilePictureBody?[0]?['profile_picture'];

        proPicId = picId;
        serverImg = serverImageLink;

        debugPrint('Image: ${responseProfilePicture.statusCode}');
      } catch (error) {
        debugPrint('Profile picture $error');
      }
    } catch (error) {
      debugPrint('4 $error');
    }
  }
}
