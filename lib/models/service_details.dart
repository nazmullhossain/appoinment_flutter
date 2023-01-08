class ProviderDetails {
  String? serviceImgUrl;
  String? serviceTitle;
  String? address;
  int? appointmentCost;

  String? experienceYear;

  String? providerImg;
  String? providerFirstName;
  String? providerLastName;
  String? providerStatus;

  double? averageRatings;
  int? totalReviews;

  int? instantService;
  int? homeService;

  ProviderDetails({
    this.providerFirstName,
    this.providerLastName,
    this.address,
  });

  factory ProviderDetails.fromJSON(Map<dynamic, dynamic> json) {
    return ProviderDetails(
      address: json['address']?[0]?['street_address'] +
          ', ' +
          json['address']?[0]?['city'] +
          ', ' +
          json['address']?[0]?['country'],
    );
  }
}
