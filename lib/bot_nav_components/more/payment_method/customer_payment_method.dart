import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

// import 'package:http/http.dart' as http;

import '../../../models/call_api.dart';
import '../../../reuse_similiar_code/widgets/bank_info.dart';
import '../../../reuse_similiar_code/widgets/card_info.dart';

class CustomerPaymentMethod extends StatefulWidget {
  @override
  State<CustomerPaymentMethod> createState() => _CustomerPaymentMethodState();
}

class _CustomerPaymentMethodState extends State<CustomerPaymentMethod> {
  final TextEditingController _bankName = TextEditingController();
  final TextEditingController _bankAccName = TextEditingController();
  final TextEditingController _bankAccNumber = TextEditingController();
  final TextEditingController _bankBranchName = TextEditingController();
  // final TextEditingController _bankSwiftCode = TextEditingController();

  final TextEditingController _creditCardName = TextEditingController();
  final TextEditingController _creditCardNumber = TextEditingController();
  final TextEditingController _cardCVVnumber = TextEditingController();
  final TextEditingController _cardExperyDate = TextEditingController();

  final List<String> _paymentMethod = ['None', 'Bank Account', 'Credit Card'];
  late String? _selectedMethod = 'None';

  var _isInit = true;
  // var _isLoading = false;
  late String userData = '';
  int? userId;
  String? userToken;
  @override
  didChangeDependencies() async {
    if (_isInit) {
      SharedPreferences successLogin = await SharedPreferences.getInstance();
      var userName = successLogin.getString('loginName');
      var successName = json.decode(json.encode(userName));

      var id = successLogin.getInt('loginId');
      var loginId = json.decode(json.encode(id));

      var token = successLogin.getString('token');
      var loginToken = json.decode(json.encode(token));

      setState(() {
        if (successName != null) {
          userData = successName;
          userId = loginId;
          userToken = loginToken;
        } else {
          userData = 'GuestUser';
        }
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  _submitBankInfo() async {
    var bankData = {
      "bank_name": _bankName.text.toString(),
      "bank_branch_name": _bankBranchName.text.toString(),
      "bank_account_name": _bankAccName.text.toString(),
      "bank_account_number": _bankAccNumber.text.toString(),
      "bank_info_user": userId,
    };

    try {
      var responseBankApi =
          await CallApi().postData(bankData, '/billing/customer_bank_info/');

      if (responseBankApi.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bank information updated has successful.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bank information updated has failed.'),
          ),
        );
      }
      // print(responseBankApi.statusCode);
    } catch (error) {
      debugPrint('customer bank error: $error');
    }
  }

  _submitCardInfo() async {
    var cardData = {
      "credit_card_name": _creditCardName.text.toString(),
      "credit_card_number": _creditCardNumber.text.toString(),
      "credit_card_expire_date": _cardExperyDate.value.text.toString(),
      "cvv_number": _cardCVVnumber.text.toString(),
      "credit_card_info_user": userId,
    };

    try {
      var responseCardApi = await CallApi()
          .postData(cardData, '/billing/customer_credit_card_info/');

      if (responseCardApi.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Card information updated has successful.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Card information updated has failed.'),
          ),
        );
      }

      // print(json.decode(responseCardApi.body));
      // print(responseCardApi.statusCode);
    } catch (error) {
      debugPrint('Customer credit card: $error');
    }
  }

  _showWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('Please select a method to update your payment information'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // final textSize = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: userData == 'GuestUser'
          ? Center(
              child: Container(
                height: height * 0.240,
                width: width * 0.700,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                margin: EdgeInsets.only(
                  top: 4.h,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 5.w,
                  vertical: 3.w,
                ),
                child: Card(
                  // color: Theme.of(context).colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Text(
                          'Please Login to continue',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        SizedBox(
                          height: 3.5.h,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/loginScreen');
                          },
                          child: const Text('Login'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          : SingleChildScrollView(
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(
                    5.w,
                    3.h,
                    5.w,
                    3.h,
                  ),
                  color: Theme.of(context).colorScheme.background,
                  child: Column(
                    children: [
                      Text(
                        'Payment Info',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        margin: const EdgeInsets.only(
                          top: 20,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 2.h,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Select a payment method',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(
                                  width: 32.w,
                                  child: DropdownButtonFormField<String>(
                                    value: _selectedMethod,
                                    items: _paymentMethod
                                        .map((item) => DropdownMenuItem<String>(
                                              child: Text(
                                                item,
                                                style: TextStyle(
                                                  fontSize: 2.h,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                              value: item,
                                            ))
                                        .toList(),
                                    onChanged: (item) {
                                      setState(() {
                                        _selectedMethod = item;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2.h,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                              ),
                            ),
                            if (_selectedMethod == 'Bank Account')
                              SizedBox(
                                height: 60.h,
                                width: 100.w,
                                child: BankInfo(
                                  bankName: _bankName,
                                  bankBranchName: _bankBranchName,
                                  bankAccName: _bankAccName,
                                  bankAccNumber: _bankAccNumber,
                                ),
                              ),
                            if (_selectedMethod == 'Credit Card')
                              SizedBox(
                                height: 60.h,
                                width: 100.w,
                                child: CardInfo(
                                  cardName: _creditCardName.text,
                                  cardNumber: _creditCardNumber.text,
                                  expiryDate: _cardExperyDate.text,
                                  cvvCode: _cardCVVnumber.text,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(3.h),
                        child: ElevatedButton(
                          onPressed: _selectedMethod == 'Bank Account'
                              ? _submitBankInfo
                              : _selectedMethod == 'Credit Card'
                                  ? _submitCardInfo
                                  : _showWarning,
                          child: Text(
                            _selectedMethod == 'Bank Account'
                                ? 'Update Bank Info'
                                : _selectedMethod == 'Credit Card'
                                    ? 'Update Card Info'
                                    : 'Payment Info',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
