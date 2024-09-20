import 'expense_model.dart';

class CicleModel {
  late int? cicleId;
  late List<ExpenseModel> expenses;
  late DateTime createdAt;
  DateTime? endedAt;
  late double fixedIncome;

  CicleModel({
    required this.createdAt,
    required this.expenses,
    required this.fixedIncome,
    this.endedAt,
  });

  CicleModel.fromJson(Map<String, dynamic> json) {
    createdAt = DateTime.tryParse(json["createdAt"]) ?? DateTime.now();
    expenses = json["expenses"] != null
        ? List<ExpenseModel>.from(
            json["expenses"].map((e) => ExpenseModel.fromJson(e)))
        : [];
    fixedIncome = json["fixedIncome"];
    cicleId = json["id"];
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
        "endedAt": endedAt,
      };
}
