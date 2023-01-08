import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GenderSelector extends StatefulWidget {
  GenderSelector({
    @required this.genderValue,
  });

  String? genderValue;

  @override
  State<GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 2.w),
          child: Text(
            'Your Gender : ',
            style: TextStyle(
              fontSize: 2.3.h,
              color: Colors.grey[700],
            ),
          ),
        ),
        Row(
          children: [
            Radio(
              activeColor: Colors.green,
              toggleable: true,
              value: 'male',
              groupValue: widget.genderValue,
              onChanged: (value) {
                setState(() {
                  widget.genderValue = value.toString();
                });
              },
            ),
            Text(
              'Male',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 0.25.h,
        ),
        Row(
          children: [
            Radio(
              toggleable: true,
              activeColor: Colors.green,
              value: 'female',
              groupValue: widget.genderValue,
              onChanged: (value) {
                setState(() {
                  widget.genderValue = value.toString();
                });
              },
            ),
            Text(
              'Female',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 0.25.h,
        ),
        Row(
          children: [
            Radio(
              activeColor: Colors.green,
              focusColor: Colors.yellow,
              toggleable: true,
              value: 'others',
              groupValue: widget.genderValue,
              onChanged: (value) {
                setState(() {
                  widget.genderValue = value.toString();
                });
              },
            ),
            Text(
              'Others',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 1.h,
        ),
      ],
    );
  }
}
