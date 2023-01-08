import 'dart:convert';

import 'package:consult_24/models/call_api.dart';
import 'package:flutter/widgets.dart';

class UserBankDetails with ChangeNotifier {
  int? userId;

  List? bankName = [];
  List? bankAccName = [];
  List? bankAccNumber = [];
  List? bankBranchName = [];

  List bankList = [];

  //....................Provider.................!

// Post provider bank info
  Future postProviderBank(Map? bankData) async {
    try {
      var response =
          await CallApi().postData(bankData, '/billing/provider_bank_info/');

      return response;
    } catch (error) {
      debugPrint('Post Provider Bank: $error');
    }
    notifyListeners();
  }

  // get provider bank info
  Future getProviderBank(int? providerId) async {
    try {
      var response =
          await CallApi().getData('/billing/provider_bank_info/$providerId');

      print(response.statusCode);

      var providerBank = json.decode(response.body);

      if (response.statusCode == 200) {
        bankList = providerBank;
        for (int i = 0; i < providerBank.length; i++) {
          bankName?.add(providerBank[i]?['bank_name']);
          bankAccName?.add(providerBank[i]?['bank_account_name']);
          bankAccNumber?.add(providerBank[i]?["bank_account_number"]);
          bankBranchName?.add(providerBank[i]?['bank_branch_name']);
        }
      }

      return response;
    } catch (error) {
      debugPrint('Get provider bank error: $error');
    }
    notifyListeners();
  }

  // update provider bank info
  Future updateProviderBank(Map? bankData, int? providerId) async {
    try {
      var response = await CallApi()
          .putData(bankData, '/billing/provider_bank_info/$providerId');

      return response;
    } catch (error) {
      debugPrint('Update provider bank error: $error');
    }
    notifyListeners();
  }

  // Delete provider Bank info
  Future deleteProviderBank(int? providerId) async {
    try {
      var response =
          await CallApi().deleteData('/billing/provider_bank_info/$providerId');

      return response;
    } catch (error) {
      debugPrint('Delete provider bank error: $error');
    }
  }

  // ....................Customer..................
}
