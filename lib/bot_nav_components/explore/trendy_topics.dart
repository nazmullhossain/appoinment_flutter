import 'dart:async';
import 'dart:math';

import 'package:consult_24/fake_data/fake_trendy_topics.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TrendyTopicsUI extends StatelessWidget {
  var trendyTopicsData = DUMMY_TOPICS
      .map(
        (trendData) => TrendyTopicsList(
          imgUrl: trendData.imgUrl,
          topicsName: trendData.topicsName,
          description: trendData.description,
        ),
      )
      .toList();

  var itemCount;

  @override
  Widget build(BuildContext context) {
    for (var i = 4; i < 5; i++) {
      var itemGenerate = Random().nextInt(trendyTopicsData.length);

      if (itemGenerate == 4) {
        itemCount == itemGenerate;
      }

      print('widget building');
      itemCount;
    }

    trendyTopicsData.shuffle();
    Timer(const Duration(milliseconds: 2000), () {});

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trendy topics',
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(height: 2.h),
        SizedBox(
          width: 100.w,
          height: 46.h,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) => trendyTopicsData[index],
          ),
        )
      ],
    );
  }
}

class TrendyTopicsList extends StatelessWidget {
  String? imgUrl;
  String? topicsName;
  String? description;

  TrendyTopicsList({
    this.imgUrl,
    this.topicsName,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 3.w,
          vertical: 0.5.h,
        ),
        margin: EdgeInsets.only(bottom: 1.5.h),
        height: 10.h,
        width: 100.w,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10.h,
              width: 25.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 9.h,
                    width: 25.w,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      // border: Border.all(
                      //   color: Colors.black87,
                      // ),
                      borderRadius: BorderRadius.circular(08),
                      image: DecorationImage(
                        image: AssetImage('$imgUrl'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 3.w),
            SizedBox(
              width: 60.w,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 2.w,
                  right: 1.w,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$topicsName',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 1.8.h,
                        letterSpacing: 0.3.w,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      '$description',
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 1.4.h,
                        letterSpacing: 0.2.w,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
