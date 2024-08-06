import '../enums/category_enum.dart';

class ConceptModel {
  late int? id;
  late CategoryEnum category;
  late String name;
  late DateTime? createdAt;

  ConceptModel({
    required this.category,
    required this.name,
    this.createdAt,
    this.id,
  });

  ConceptModel.fromJson(Map<String, dynamic> json) {
    category = CategoryEnum.values.firstWhere(
      (element) => json["categoryId"] == element.value,
      orElse: () => CategoryEnum.personals,
    );
    name = json["name"];
    createdAt = DateTime.tryParse(json["createdAt"]) ?? DateTime.now();
    id = json["id"];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "categoryId": category.value,
        "name": name,
        "createdAt": createdAt,
      };
}
