import '../enums/category_enum.dart';

class ConceptModel {
  int? id;
  CategoryEnum category;
  String name;
  DateTime? createdAt;

  ConceptModel({
    required this.category,
    required this.name,
    this.createdAt,
    this.id,
  });
}
