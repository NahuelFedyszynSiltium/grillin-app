import '../enums/category_enum.dart';

class ConceptModel {
  int? conceptId;
  late CategoryEnum category;
  late String name;
  DateTime? createdAt;

  ConceptModel({
    required this.category,
    required this.name,
    this.createdAt,
  });

  ConceptModel.fromJson(Map<String, dynamic> json) {
    category = CategoryEnum.values.firstWhere(
      (element) => json["categoryId"] == element.value,
      orElse: () => CategoryEnum.personals,
    );
    name = json["name"];
    createdAt = DateTime.tryParse(json["createdAt"]) ?? DateTime.now();
    conceptId = json["conceptId"];
  }

  Map<String, dynamic> toJson() => {
        "categoryId": category.value,
        "name": name,
        "createdAt": createdAt,
      };
}
