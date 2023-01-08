import 'package:consult_24/fake_data/fake_customer_reviews.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomerReview extends StatelessWidget {
  var fakeCustomer = DUMMY_CUSTOMERS
      .map((custData) => CustomerCard(
            imgLink: custData.customerImgUrl,
            reviewDetails: custData.reviewDetails,
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 2.w),
      height: 17.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: fakeCustomer.length,
        itemBuilder: (context, index) => fakeCustomer[index],
        separatorBuilder: (context, _) => SizedBox(
          width: 2.w,
        ),
      ),
    );
  }
}

class CustomerCard extends StatelessWidget {
  String? imgLink;
  String? reviewDetails;

  CustomerCard({
    @required this.imgLink,
    @required this.reviewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 12.h,
        width: 28.w,
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 1.h),
              height: 8.h,
              width: 16.w,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(imgLink.toString()),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              color: Colors.white,
              child: Text(
                reviewDetails.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 2.h, letterSpacing: 0.02.w),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
