import 'expense_model.dart';

class CicleModel {
  late int id;
  late List<ExpenseModel> expenses;
  late DateTime createdAt;
  late DateTime? endedAt;
  late double fixedIncome;

  CicleModel({
    required this.createdAt,
    required this.expenses,
    required this.fixedIncome,
    required this.id,
    this.endedAt,
  });

  CicleModel.fromJson(Map<String, dynamic> json) {
    createdAt = DateTime.tryParse(json["createdAt"]) ?? DateTime.now();
    expenses = json["expenses"] != null
        ? List<ExpenseModel>.from(
            json["expenses"].map((e) => ExpenseModel.fromJson(e)))
        : [];
    fixedIncome = json["fixedIncome"];
    id = json["id"];
    endedAt = DateTime.tryParse(json["endedAt"]);
  }

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt,
        "expenses": expenses.isNotEmpty
            ? expenses
                .map(
                  (e) => e.toJson(),
                )
                .toList()
            : [],
        "fixedIncome": fixedIncome,
        "id": id,
        "endedAt": endedAt,
      };
}
