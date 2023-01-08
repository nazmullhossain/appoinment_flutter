import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../widgets/text_input_field.dart';

class BusinessInformation extends StatelessWidget {
  BusinessInformation({
    this.businessGoal,
    this.spentMoney,
    this.numberOfEmployees,
    this.companyName,
    this.foundingYear,
    this.socialMediaLink,
    this.websiteLink,
  });

  TextEditingController? businessGoal = TextEditingController();
  TextEditingController? spentMoney = TextEditingController();
  TextEditingController? numberOfEmployees = TextEditingController();
  TextEditingController? companyName = TextEditingController();
  TextEditingController? foundingYear = TextEditingController();
  TextEditingController? socialMediaLink = TextEditingController();
  TextEditingController? websiteLink = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(
        horizontal: 2.w,
        vertical: 1.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Business Information :',
              style: TextStyle(
                fontSize: 2.5.h,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.05.w,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          TextInputField(
            icon: Icons.description,
            keyboard: TextInputType.text,
            label: 'Business Description',
            maxLine: 3,
            readPermit: false,
            textController: businessGoal,
            validateFunction: (value) {
              value = businessGoal?.text;
              if (value == '') {
                return 'This field is required';
              } else if (value!.length > 300) {
                return 'Not more than 300';
              } else {
                return null;
              }
            },
          ),
          SizedBox(
            height: 1.h,
          ),
          TextInputField(
            icon: Icons.money,
            keyboard: TextInputType.number,
            label: 'Total spent money',
            readPermit: false,
            textController: spentMoney,
            validateFunction: (value) {
              value = spentMoney?.text;
              if (value == '') {
                return 'This field is required';
              } else {
                return null;
              }
            },
          ),
          SizedBox(
            height: 1.h,
          ),
          TextInputField(
            icon: Icons.group,
            keyboard: TextInputType.number,
            readPermit: false,
            label: 'Total employees',
            textController: numberOfEmployees,
            validateFunction: (value) {
              value = numberOfEmployees?.text;
              if (value == '') {
                return 'This field is required';
              } else {
                return null;
              }
            },
          ),
          SizedBox(
            height: 1.h,
          ),
          TextInputField(
            icon: Icons.calendar_view_day,
            readPermit: false,
            label: 'Company name',
            keyboard: TextInputType.name,
            textController: companyName,
            validateFunction: (value) {
              value = companyName?.text;
              if (value == '') {
                return 'This field is required';
              } else {
                return null;
              }
            },
          ),
          SizedBox(
            height: 1.h,
          ),
          TextInputField(
            icon: Icons.calendar_month,
            keyboard: TextInputType.number,
            readPermit: false,
            label: 'Founding year',
            textController: foundingYear,
            validateFunction: (value) {
              value = foundingYear?.text;
              if (value == '') {
                return 'This field is required';
              } else if (value!.length >= 4) {
                return 'Year must be in 4 digit';
              } else {
                return null;
              }
            },
          ),
          SizedBox(
            height: 1.h,
          ),
          TextInputField(
            icon: Icons.social_distance_outlined,
            label: 'Social Medial Link',
            keyboard: TextInputType.url,
            readPermit: false,
            textController: socialMediaLink,
            validateFunction: (value) {
              value = socialMediaLink?.text;
              if (value == '') {
                return 'This field is required';
              } else if (!value!.contains('http://') ||
                  !value.contains('https://')) {
                return 'Must be included http or https';
              } else {
                return null;
              }
            },
          ),
          SizedBox(
            height: 1.h,
          ),
          TextInputField(
            icon: Icons.web_asset,
            readPermit: false,
            keyboard: TextInputType.url,
            label: 'Website Link',
            textController: websiteLink,
            validateFunction: (value) {
              value = websiteLink?.text;
              if (value == '') {
                return 'This field is required';
              } else if (!value!.contains('http://') ||
                  !value.contains('https://')) {
                return 'Must be included http or https';
              } else {
                return null;
              }
            },
          ),
        ],
      ),
    );
  }
}
