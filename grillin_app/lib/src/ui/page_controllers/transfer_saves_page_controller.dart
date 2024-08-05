import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../enums/category_enum.dart';
import '../../interfaces/i_view_controller.dart';
import '../../managers/page_manager.dart';
import '../../utils/functions_utils.dart';
import '../../utils/page_args.dart';

class TransferSavesPageController extends ControllerMVC
    implements IViewController {
  static late TransferSavesPageController _this;

  double totalSaves = 123456789.12;

  bool get isEnabled {
    return amountController.text.trim().isNotEmpty &&
        double.tryParse(amountController.text.trim()) != null &&
        (double.tryParse(amountController.text.trim()) ?? 0) < totalSaves;
  }

  factory TransferSavesPageController() {
    _this = TransferSavesPageController._();
    return _this;
  }

  static TransferSavesPageController get con => _this;
  TransferSavesPageController._();

  PageArgs? args;

  CategoryEnum selectedCategory = CategoryEnum.personals;

  String get getTotalSaves {
    return currencyFormat(totalSaves);
  }

  final TextEditingController amountController = TextEditingController();

  @override
  void initPage({PageArgs? arguments}) {}

  @override
  disposePage() {}

  void onPopInvoked(didPop) {
    if (didPop) return;
    // ADD CODE >>>>>>
    PageManager().goHomePage();
    // <<<<<<<<<<<<<<<
  }

  void onAccept() {
    return;
  }

  void onCategoryTap(CategoryEnum category) {
    setState(() {
      selectedCategory = category;
    });
  }
}
