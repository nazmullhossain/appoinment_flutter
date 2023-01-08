import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
// import 'package:flutter_credit_card/credit_card_form.dart';
// import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:sizer/sizer.dart';

class CardInfo extends StatefulWidget {
  String? cardName;
  String? cardNumber;
  String? expiryDate;
  String? cvvCode;

  bool isBackFocused = false;

  CardInfo({
    @required this.cardName,
    @required this.cardNumber,
    @required this.expiryDate,
    @required this.cvvCode,
  });

  @override
  State<CardInfo> createState() => _CardInfoState();
}

class _CardInfoState extends State<CardInfo> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CreditCardWidget(
            cardNumber: widget.cardNumber.toString(),
            expiryDate: widget.expiryDate.toString(),
            cardHolderName: widget.cardName.toString(),
            cvvCode: widget.cvvCode.toString(),
            showBackView: widget.isBackFocused,
            cardBgColor: Colors.grey,
            obscureCardNumber: true,
            obscureCardCvv: true,
            onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {}),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CreditCardForm(
                  cardNumber: widget.cardNumber.toString(),
                  expiryDate: widget.expiryDate.toString(),
                  cardHolderName: widget.cardName.toString(),
                  cvvCode: widget.cvvCode.toString(),
                  onCreditCardModelChange: onCreditCardModelChange,
                  themeColor: Theme.of(context).colorScheme.primary,
                  formKey: formKey,
                  cardNumberDecoration: InputDecoration(
                    focusColor: Theme.of(context).colorScheme.primary,
                    prefixIcon: const Icon(Icons.numbers_sharp),
                    label: Text(
                      'Card Number',
                      style: TextStyle(fontSize: 1.7.h),
                    ),
                    fillColor: Colors.grey[50],
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                    ),
                  ),
                  cardHolderDecoration: InputDecoration(
                    label: Text(
                      'Card Name',
                      style: TextStyle(fontSize: 1.7.h),
                    ),
                    prefixIcon: const Icon(Icons.person),
                    fillColor: Colors.grey[50],
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                    ),
                  ),
                  cvvCodeDecoration: InputDecoration(
                    label: Text(
                      'CVV number',
                      style: TextStyle(fontSize: 1.7.h),
                    ),
                    prefixIcon: const Icon(Icons.numbers_sharp),
                    fillColor: Colors.grey[50],
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                    ),
                  ),
                  expiryDateDecoration: InputDecoration(
                    label: Text(
                      'Expery Date',
                      style: TextStyle(fontSize: 1.7.h),
                    ),
                    fillColor: Colors.grey[50],
                    filled: true,
                    prefixIcon: const Icon(Icons.calendar_month),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      widget.cardName = creditCardModel.cardHolderName;
      widget.expiryDate = creditCardModel.expiryDate;
      widget.cardNumber = creditCardModel.cardNumber;
      widget.cvvCode = creditCardModel.cvvCode;
      widget.isBackFocused = creditCardModel.isCvvFocused;
    });
  }
}
