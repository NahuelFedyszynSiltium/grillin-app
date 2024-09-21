class CicleModel {
  late int? cicleId;
  late DateTime createdAt;
  DateTime? endedAt;
  late num fixedIncome;

  CicleModel({
    required this.createdAt,
    required this.fixedIncome,
    this.endedAt,
  });

  CicleModel.fromJson(Map<String, dynamic> json) {
    createdAt =
        DateTime.tryParse(json["createdAt"].toString()) ?? DateTime.now();
    // expenses = json["expenses"] != null
    //     ? List<ExpenseModel>.from(
    //         json["expenses"].map((e) => ExpenseModel.fromJson(e)))
    //     : [];
    fixedIncome = json["fixedIncome"];
    cicleId = json["cicleId"];
    endedAt = DateTime.tryParse(json["endedAt"].toString());
  }

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt.toString(),
        // "expenses": expenses.isNotEmpty
        //     ? expenses
        //         .map(
        //           (e) => e.toJson(),
        //         )
        //         .toList()
        //     : [],
        "fixedIncome": fixedIncome,
        "endedAt": endedAt.toString(),
      };
}
