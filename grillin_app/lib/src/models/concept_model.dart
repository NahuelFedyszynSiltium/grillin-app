import '../enums/category_enum.dart';

class ConceptModel {
  int? conceptId;
  late CategoryEnum category;
  late String conceptName;
  DateTime? createdAt;

  ConceptModel({
    required this.category,
    required this.conceptName,
    this.createdAt,
  });

  ConceptModel.fromJson(Map<String, dynamic> json) {
    category = CategoryEnum.values.firstWhere(
      (element) => json["categoryId"] == element.value,
      orElse: () => CategoryEnum.personals,
    );
    conceptName = json["conceptName"];
    createdAt =
        DateTime.tryParse(json["createdAt"].toString()) ?? DateTime.now();
    conceptId = json["conceptId"];
  }

  Map<String, dynamic> toJson() => {
        "categoryId": category.value,
        "conceptName": conceptName,
        "createdAt": createdAt.toString(),
      };
}
