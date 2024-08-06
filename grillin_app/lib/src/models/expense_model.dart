import '../enums/category_enum.dart';
import 'concept_model.dart';

class ExpenseModel {
  int? id;
  int? cicleId;
  late CategoryEnum category;
  late ConceptModel conceptModel;
  DateTime? createdAt;
  late double amount;

  ExpenseModel({
    required this.conceptModel,
    required this.amount,
    required this.category,
    this.id,
    this.cicleId,
    this.createdAt,
  });

  ExpenseModel.fromJson(Map<String, dynamic> json) {
    conceptModel = ConceptModel.fromJson(json["conceptModel"]);
    amount = json["amount"];
    category = CategoryEnum.values.firstWhere(
      (element) => json["categoryId"] == element.value,
      orElse: () => CategoryEnum.personals,
    );
    id = json["id"];
    cicleId = json["cicleId"];
    createdAt = DateTime.tryParse(json["createdAt"]) ?? DateTime.now();
  }

  Map<String, dynamic> toJson() => {
        "conceptModel": conceptModel,
        "amount": amount,
        "categoryId": category.value,
        "id": id,
        "cicleId": cicleId,
        "createdAt": createdAt,
      };
}
