import 'package:flutter/foundation.dart';

class Welcome {
  Welcome({
    this.user,
    this.customer,
    this.address,
  });

  User? user;
  Customer? customer;
  List<Address>? address;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        user: User.fromJson(json["user"]),
        customer: Customer.fromJson(json["customer"]),
        address:
            List<Address>.from(json["address"].map((x) => Address.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "customer": customer?.toJson(),
        "address": List<dynamic>.from(address!.map((x) => x.toJson())),
      };
}

class Address {
  Address({
    this.id,
    this.streetAddress,
    this.apt,
    this.zipCode,
    this.city,
    this.state,
    this.country,
    this.addressUser,
  });

  int? id;
  String? streetAddress;
  String? apt;
  String? zipCode;
  String? city;
  String? state;
  String? country;
  int? addressUser;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        streetAddress: json["street_address"],
        apt: json["apt"],
        zipCode: json["zip_code"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        addressUser: json["address_user"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "street_address": streetAddress,
        "apt": apt,
        "zip_code": zipCode,
        "city": city,
        "state": state,
        "country": country,
        "address_user": addressUser,
      };
}

class Customer {
  Customer({
    this.id,
    this.avgRating,
    this.lifetimeServiceCount,
    this.positiveReviewId,
    this.nagetiveReviewId,
    this.prefProviderList,
    this.userCustomer,
  });

  int? id;
  String? avgRating;
  String? lifetimeServiceCount;
  String? positiveReviewId;
  String? nagetiveReviewId;
  List<dynamic>? prefProviderList;
  int? userCustomer;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        avgRating: json["avg_rating"],
        lifetimeServiceCount: json["lifetime_service_count"],
        positiveReviewId: json["positive_review_id"],
        nagetiveReviewId: json["nagetive_review_id"],
        prefProviderList:
            List<dynamic>.from(json["pref_provider_list"].map((x) => x)),
        userCustomer: json["user_customer"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "avg_rating": avgRating,
        "lifetime_service_count": lifetimeServiceCount,
        "positive_review_id": positiveReviewId,
        "nagetive_review_id": nagetiveReviewId,
        "pref_provider_list":
            List<dynamic>.from(prefProviderList!.map((x) => x)),
        "user_customer": userCustomer,
      };
}

class User {
  User({
    this.id,
    this.username,
    this.firstName,
    this.middleName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.gender,
    this.joiningDate,
    this.role,
    this.onlineStatus,
    this.activityStatus,
    this.accountStatus,
    this.paymentToMethod,
    this.paymentFromMethod,
  });

  int? id;
  String? username;
  String? firstName;
  String? middleName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? gender;
  DateTime? joiningDate;
  int? role;
  bool? onlineStatus;
  bool? activityStatus;
  String? accountStatus;
  String? paymentToMethod;
  String? paymentFromMethod;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        firstName: json["first_name"],
        middleName: json["middle_name"],
        lastName: json["last_name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        gender: json["gender"],
        joiningDate: DateTime.parse(json["joining_date"]),
        role: json["role"],
        onlineStatus: json["online_status"],
        activityStatus: json["activity_status"],
        accountStatus: json["account_status"],
        paymentToMethod: json["payment_to_method"],
        paymentFromMethod: json["payment_from_method"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "first_name": firstName,
        "middle_name": middleName,
        "last_name": lastName,
        "email": email,
        "phone_number": phoneNumber,
        "gender": gender,
        "joining_date": joiningDate?.toIso8601String(),
        "role": role,
        "online_status": onlineStatus,
        "activity_status": activityStatus,
        "account_status": accountStatus,
        "payment_to_method": paymentToMethod,
        "payment_from_method": paymentFromMethod,
      };
}
