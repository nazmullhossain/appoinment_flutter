import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BankInfo extends StatelessWidget {
  TextEditingController? bankName = TextEditingController();
  TextEditingController? bankAccName = TextEditingController();
  TextEditingController? bankAccNumber = TextEditingController();
  TextEditingController? bankBranchName = TextEditingController();

  BankInfo({
    @required this.bankName,
    @required this.bankAccName,
    @required this.bankAccNumber,
    @required this.bankBranchName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          autofocus: false,
          controller: bankName,
          decoration: InputDecoration(
            label: const Text('Bank Name'),
            fillColor: Colors.grey[50],
            filled: true,
            prefixIcon: const Icon(Icons.person),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 1.w,
            ),
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        TextFormField(
          autofocus: false,
          controller: bankAccName,
          decoration: InputDecoration(
            label: const Text('Account Name'),
            fillColor: Colors.grey[50],
            filled: true,
            prefixIcon: const Icon(Icons.person),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 2.w,
            ),
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        TextFormField(
          autofocus: false,
          controller: bankBranchName,
          decoration: InputDecoration(
            label: const Text('Branch Name'),
            fillColor: Colors.grey[50],
            filled: true,
            prefixIcon: const Icon(Icons.location_on),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 2.w,
            ),
          ),
        ),

        SizedBox(
          height: 1.h,
        ),
        TextFormField(
          autofocus: false,
          controller: bankAccNumber,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            label: const Text('Account Number'),
            fillColor: Colors.grey[50],
            filled: true,
            prefixIcon: const Icon(Icons.numbers),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 2.w,
            ),
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        // TextFormField(
        //   autofocus: false,
        //   controller: _bankSwiftCode,
        //   keyboardType: TextInputType.number,
        //   decoration: InputDecoration(
        //     label: const Text('Swift code'),
        //     fillColor: Colors.grey[50],
        //     filled: true,
        //     contentPadding: EdgeInsets.symmetric(
        //       horizontal: 5.w,
        //     ),
        //     border: InputBorder.none,
        //   ),
        // ),
        // SizedBox(
        //   height: 2.h,
        //   child: DecoratedBox(
        //     decoration: BoxDecoration(
        //       color: Colors.grey[100],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
