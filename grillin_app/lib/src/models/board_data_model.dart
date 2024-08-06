import 'percents_category_response_model.dart';

class BoardDataModel {
  late double dailyRemainingAmount;
  late double achievemtnRemainingAmount;
  late double personalRemainingAmount;
  late double savesAmount;
  late PercentsCategoryResponseModel percentsCategoryResponseModel;

  BoardDataModel({
    required this.percentsCategoryResponseModel,
    required this.achievemtnRemainingAmount,
    required this.dailyRemainingAmount,
    required this.personalRemainingAmount,
    required this.savesAmount,
  });

  BoardDataModel.fromJson(Map<String, dynamic> json) {
    dailyRemainingAmount = json["dailyRemainingAmount"];
    achievemtnRemainingAmount = json["achievemtnRemainingAmount"];
    personalRemainingAmount = json["personalRemainingAmount"];
    savesAmount = json["savesAmount"];
    percentsCategoryResponseModel = PercentsCategoryResponseModel.fromJson(
        json["percentsCategoryResponseModel"]);
  }
}
