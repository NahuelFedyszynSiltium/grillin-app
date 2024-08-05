import '../models/expense_model.dart';

class DataManager {
  static final DataManager _instance = DataManager._constructor();

  factory DataManager() {
    return _instance;
  }

  DataManager._constructor();

  init() async {}

  void cleanData() {}

  Future<void> postAddNewExpense({required ExpenseModel expenseModel}) async {
    //TODO: DATABASE ADD
  }
}
