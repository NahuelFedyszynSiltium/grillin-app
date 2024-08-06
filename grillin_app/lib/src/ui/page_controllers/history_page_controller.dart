import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../enums/category_enum.dart';
import '../../interfaces/i_view_controller.dart';
import '../../managers/data_manager.dart';
import '../../managers/page_manager.dart';
import '../../models/expense_model.dart';
import '../../utils/page_args.dart';

class HistoryPageController extends ControllerMVC implements IViewController {
  static late HistoryPageController _this;

  factory HistoryPageController() {
    _this = HistoryPageController._();
    return _this;
  }

  static HistoryPageController get con => _this;
  HistoryPageController._();

  PageArgs? args;
  Map<CategoryEnum, bool> selectedCateogries = {
    CategoryEnum.achievemnts: true,
    CategoryEnum.dailys: true,
    CategoryEnum.saves: true,
    CategoryEnum.personals: true,
  };

  bool get allCategoriesSelected =>
      selectedCateogries.values.every((element) => element);

  List<ExpenseModel> expenseList = [];
  int pageCounter = 0;
  bool forceUpdate = false;

  @override
  void initPage({PageArgs? arguments}) {
    forceUpdate = false;
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  disposePage() {}

  void onPopInvoked(didPop) {
    if (didPop) return;
    PageManager().goHomePage();
  }

  void onCategoryTap(CategoryEnum? category) {
    setState(() {
      forceUpdate = true;

      if (category == null) {
        selectedCateogries.updateAll((key, value) => true);
      } else {
        selectedCateogries[category] = !selectedCateogries[category]!;
      }
    });
  }

  Future<void> getExpenseHistory() async {
    forceUpdate = false;
    if (selectedCateogries.values.every(
      (element) => !element,
    )) {
      expenseList = [];
    } else {
      List<CategoryEnum> aux = [];
      for (CategoryEnum element in selectedCateogries.keys) {
        if (selectedCateogries[element]!) {
          aux.add(element);
        }
      }
      expenseList = await DataManager().getExpensesHistory(
        categories: aux,
        page: pageCounter,
      );
    }
  }
}
