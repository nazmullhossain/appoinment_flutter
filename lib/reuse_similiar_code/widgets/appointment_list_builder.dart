import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

class AppointmentListBuilder extends StatelessWidget {
  List? itemCount = [];
  int numbering = 1;
  String? type;
  String? startTime;
  String? endTime;
  String? status;
  String? date;
  // Function<Widget>()? viewDetails;

  AppointmentListBuilder({
    // this.viewDetails,
    // this.numbering,
    @required this.type,
    @required this.startTime,
    @required this.endTime,
    @required this.status,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: viewDetails,
      child: Container(
        margin: EdgeInsets.only(bottom: 1.h),
        height: 5.h,
        width: 100.w,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(
            color: Colors.black87,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // SizedBox(
            //   width: 5.w,
            //   child: const Icon(Icons.arrow_right),
            // ),
            SizedBox(
              width: 19.w,
              child: Center(
                child: Text(
                  '$type',
                  style: TextStyle(
                    fontSize: 2.h,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 19.w,
              child: Center(
                child: Text(
                  '$startTime.',
                  style: TextStyle(
                    fontSize: 2.h,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 19.w,
              child: Center(
                child: Text(
                  '$endTime',
                  style: TextStyle(
                    fontSize: 2.h,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 19.w,
              child: Center(
                child: Text(
                  '$date',
                  style: TextStyle(
                    fontSize: 2.h,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 18.w,
              child: Center(
                child: Text(
                  '$status',
                  style: TextStyle(
                    fontSize: 2.h,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
