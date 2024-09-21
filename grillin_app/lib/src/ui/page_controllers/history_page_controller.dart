import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../../values/k_colors.dart';
import '../../data_access/data_manager.dart';
import '../../enums/category_enum.dart';
import '../../interfaces/i_view_controller.dart';
import '../../managers/page_manager.dart';
import '../../models/cicle_model.dart';
import '../../models/expense_model.dart';
import '../../utils/functions_utils.dart';
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
    CategoryEnum.achievements: true,
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

  void onPopInvoked(bool didPop, data) {
    if (didPop) return;
    PageManager().goHomePage();
  }

  void onCategoryTap(CategoryEnum? category) async {
    if (category == null) {
      selectedCateogries.updateAll((key, value) => true);
    } else {
      if (selectedCateogries.values.every(
        (element) => element,
      )) {
        selectedCateogries.updateAll(
          (key, value) => key == category,
        );
      } else {
        selectedCateogries[category] = !selectedCateogries[category]!;
      }
    }

    await getExpenseHistory();
    setState(() {});
  }

  Future<void> getExpenseHistory() async {
    forceUpdate = false;
    CicleModel? currentCicle = await DataManager().getCurrentCicle();
    if (currentCicle?.cicleId != null) {
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
        expenseList = await DataManager().getExpensesPerCicle(
          categories: aux,
          cicleId: currentCicle!.cicleId!,
          filterModel: FilterModel(
            columnName: "createdAt",
            orderCriteria: OrderCriteria.DESC,
          ),
        );
      }
    } else {
      expenseList = [];
    }
  }

  String getAmountPrefix(ExpenseModel element) {
    if (element.category == CategoryEnum.saves) {
      return element.amount < 0 ? "-" : "+";
    } else {
      return element.amount > 0 ? "-" : "+";
    }
  }

  Color getAmountColor(ExpenseModel element) {
    if (element.category == CategoryEnum.saves) {
      return element.amount < 0 ? KColors.white : KColors.greenL1;
    } else {
      return element.amount > 0 ? KColors.white : KColors.greenL1;
    }
  }

  String getAmountString(ExpenseModel element) {
    if (element.amount < 0) {
      return currencyFormat(-element.amount);
    } else {
      return currencyFormat(element.amount);
    }
  }
}
