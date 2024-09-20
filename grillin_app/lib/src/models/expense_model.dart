import '../enums/category_enum.dart';
import 'concept_model.dart';

class ExpenseModel {
  int? expenseId;
  int? cicleId;
  late CategoryEnum category;
  late ConceptModel conceptModel;
  DateTime? createdAt;
  late num amount;

  ExpenseModel({
    required this.conceptModel,
    required this.amount,
    required this.category,
    this.expenseId,
    this.createdAt,
  });

  ExpenseModel.fromJson(Map<String, dynamic> json) {
    conceptModel = ConceptModel.fromJson(json["conceptModel"]);
    amount = json["amount"];
    category = CategoryEnum.values.firstWhere(
      (element) => json["categoryId"] == element.value,
      orElse: () => CategoryEnum.personals,
    );
    expenseId = json["expenseId"];
    cicleId = json["cicleId"];
    createdAt =
        DateTime.tryParse(json["createdAt"].toString()) ?? DateTime.now();
  }

  Map<String, dynamic> toJson() => {
        "conceptModel": conceptModel,
        "amount": amount,
        "categoryId": category.value,
        "cicleId": cicleId,
        "createdAt": createdAt.toString(),
      };
}
