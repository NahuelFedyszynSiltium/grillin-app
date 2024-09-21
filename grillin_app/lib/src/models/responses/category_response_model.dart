import '../../enums/category_enum.dart';

class CategoryResponseModel {
  late int categoryId;
  late int percentValue;
  late String categoryName;
  late num addFromSavings;

  CategoryResponseModel.fromJson(Map<String, dynamic> json) {
    categoryId = json["categoryId"];
    percentValue = json["percentValue"] ?? 0;
    categoryName = json["categoryName"];
    addFromSavings = json["addFromSavings"] ?? 0;
  }

  CategoryEnum get categoryEnum => CategoryEnum.values.firstWhere(
        (element) => element.value == categoryId,
      );
}
