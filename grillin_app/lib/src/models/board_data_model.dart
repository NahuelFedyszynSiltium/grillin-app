import 'percents_category_response_model.dart';

class BoardDataModel {
  double dailyRemainingAmount;
  double achievemtnRemainingAmount;
  double personalRemainingAmount;
  double savesAmount;
  PercentsCategoryResponseModel percentsCategoryResponseModel;

  BoardDataModel({
    required this.percentsCategoryResponseModel,
    required this.achievemtnRemainingAmount,
    required this.dailyRemainingAmount,
    required this.personalRemainingAmount,
    required this.savesAmount,
  });
}
