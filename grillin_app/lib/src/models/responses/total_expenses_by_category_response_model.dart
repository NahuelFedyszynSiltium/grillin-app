import '../../enums/category_enum.dart';

class TotalExpensesByCategoryResponseModel {
  late int categoryId;
  late double amount;

  TotalExpensesByCategoryResponseModel.fromJson(Map<String, dynamic> json) {
    categoryId = json["categoryId"];
    amount = json["amount"] ?? 0;
  }

  CategoryEnum get categoryEnum => CategoryEnum.values.firstWhere(
        (element) => element.value == categoryId,
      );
}
