class CategoryResult {
  String? categoryName;
  String? serviceName;
  String? serviceDescription;
  String? appointmentCost;
  List? searchingResult = [];

  CategoryResult({
    this.categoryName,
    this.serviceName,
    this.serviceDescription,
    this.appointmentCost,
    this.searchingResult,
  });

  factory CategoryResult.fromJson(var json) {
    return CategoryResult(
      categoryName: json[''],
      serviceDescription: json['service_description'],
      appointmentCost: json['rate_apt_video_cons'],
      serviceName: json['service_name'],
      searchingResult: json.decode(),
    );
  }
}
