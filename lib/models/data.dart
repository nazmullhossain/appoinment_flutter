import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class Categories {
  int? id;
  String? categoryName;
  String? imageUrl;
  IconData? iconName;

  Categories({
    this.id,
    this.categoryName,
    this.imageUrl,
    @required this.iconName,
  });
}

class TrendyTopics {
  String? id;
  String? topicsName;
  String? imgUrl;
  String? description;

  TrendyTopics({
    this.id,
    @required this.description,
    @required this.topicsName,
    @required this.imgUrl,
  });
}

class CustomerReviews {
  String? id;
  String? customerName;
  String? reviewDetails;
  String? customerImgUrl;

  CustomerReviews({
    this.id,
    @required this.customerName,
    @required this.reviewDetails,
    @required this.customerImgUrl,
  });
}
