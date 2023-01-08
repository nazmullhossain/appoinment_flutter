import 'dart:convert';

import 'package:consult_24/models/call_api.dart';
import 'package:flutter/widgets.dart';

class PrefUser with ChangeNotifier {
  int? statusCodeCustm;

  var prefProList = [];
  var prefProId = [];

  var prefProviderLevel = {};

// mark as pref provider
  prefProvider({
    @required String? customerId,
    @required String? providerId,
    @required String? customerName,
    @required String? providerName,
  }) async {
    try {
      final prefApi = await CallApi().postData(
        {
          'user_customer': customerId,
          'provider': providerId,
          'customer_name': customerName,
          'provider_name': providerName,
        },
        '/auth_api/pref_provider_Customer_ApiView/',
      );

      statusCodeCustm = prefApi.statusCode;
      debugPrint('prefProvider From Customer: ${prefApi.statusCode}');
    } catch (error) {
      debugPrint('prefProviderCustomer error: $error');
    }

    notifyListeners();
  }

  // get pref provider
  getPrefProvider({@required int? customerId}) async {
    try {
      final prefApi = await CallApi().getData(
          '/auth_api/customer_view_service_provider_list/?customerId=$customerId');

      var prefProviderList = json.decode(prefApi.body);
      debugPrint('prefProvider get statuscode: ${prefApi.statusCode}');

      if (prefApi.statusCode == 200) {
        for (int i = 0; i < prefProviderList.length; i++) {
          prefProList.add(prefProviderList?[i]?['id']);
          prefProId.add(prefProviderList?[i]?['provider']);
        }

        prefProviderLevel = Map.fromIterables(prefProId, prefProList);
      }
    } catch (error) {
      debugPrint('pref provider get error: $error');
    }

    notifyListeners();
  }

  // delete pref provider
  // deletePrefProvider()
  // /auth_api/PreProviderListDetailsAPIView/{id}
}
