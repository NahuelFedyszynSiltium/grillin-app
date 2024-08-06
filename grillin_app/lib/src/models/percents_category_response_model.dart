class PercentsCategoryResponseModel {
  late int achievemntsPercent;
  late int personalsPercent;
  late int dailysPercent;

  PercentsCategoryResponseModel({
    required this.achievemntsPercent,
    required this.dailysPercent,
    required this.personalsPercent,
  });

  Map<String, dynamic> toJson() => {
        "achievemntsPercent": achievemntsPercent,
        "dailysPercent": dailysPercent,
        "personalsPercent": personalsPercent,
      };

  PercentsCategoryResponseModel.fromJson(Map<String, dynamic> json) {
    achievemntsPercent = json["achievemntsPercent"] ?? 20;
    dailysPercent = json["dailysPercent"] ?? 50;
    personalsPercent = json["personalsPercent"] ?? 30;
  }
}
