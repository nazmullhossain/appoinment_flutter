import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// import '../widgets/date_picker.dart';
import '../widgets/text_input_field.dart';

class ProfileInformation extends StatelessWidget {
  ProfileInformation({
    this.firstName,
    this.middleName,
    this.lastName,
    this.userName,
    this.dateController,
    this.phoneNumber,
    this.emailController,
  });

  TextEditingController? firstName = TextEditingController();
  TextEditingController? middleName = TextEditingController();
  TextEditingController? lastName = TextEditingController();
  TextEditingController? userName = TextEditingController();
  TextEditingController? dateController = TextEditingController();
  TextEditingController? phoneNumber = TextEditingController();
  TextEditingController? emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 2.w,
        vertical: 1.w,
      ),
      child: Column(
        children: [
          TextInputField(
            label: 'First name',
            icon: Icons.person,
            textController: firstName,
            readPermit: false,
            keyboard: TextInputType.text,
            validateFunction: (value) {
              value = firstName?.text;
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
            label: 'Middle name',
            icon: Icons.person,
            textController: middleName,
            readPermit: false,
          ),
          SizedBox(
            height: 1.6.h,
          ),
          TextInputField(
            label: 'Last name',
            icon: Icons.person,
            textController: lastName,
            readPermit: false,
            keyboard: TextInputType.text,
            validateFunction: (value) {
              value = lastName?.text;
              if (value == '') {
                return 'This field is required';
              } else {
                return null;
              }
            },
          ),
          SizedBox(
            height: 1.6.h,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.grey[100],
              ),
            ),
          ),
          TextInputField(
            label: 'User name',
            icon: Icons.photo_camera_front_rounded,
            readPermit: true,
            textController: userName,
          ),
          SizedBox(
            height: 1.h,
          ),
          // DateField(
          //   startingDate: DateTime(1950),
          //   finishingDate: DateTime.now(),
          //   dateController: dateController,
          //   label: 'Date of Birth',
          // ),
          // SizedBox(
          //   height: 1.h,
          // ),
          TextInputField(
            readPermit: false,
            label: 'Phone number',
            icon: Icons.phone,
            keyboard: TextInputType.number,
            textController: phoneNumber,
            validateFunction: (value) {
              value = phoneNumber?.text;
              if (value == '') {
                return 'This field is required';
              } else if (value!.length >= 12) {
                return 'This field must be 11';
              } else {
                return null;
              }
            },
          ),
          SizedBox(
            height: 1.h,
          ),
          TextInputField(
            label: 'Email address',
            readPermit: true,
            textController: emailController,
            icon: Icons.email,
          ),
        ],
      ),
    );
  }
}
