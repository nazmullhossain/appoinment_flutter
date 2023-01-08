import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class WidgetColumn extends StatelessWidget {
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? route;
  final String? columnName;

  WidgetColumn({
    @required this.prefixIcon,
    @required this.columnName,
    @required this.route,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, '$route');
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            height: 6.h,
            margin: EdgeInsets.only(bottom: 1.h),
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      prefixIcon,
                      size: MediaQuery.of(context).size.height * .023,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.03,
                    ),
                    Text(
                      columnName!,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 2.3.h,
                        letterSpacing: 0.01.w,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                Icon(
                  suffixIcon,
                  size: MediaQuery.of(context).size.height * 0.02,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
