import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../../values/k_strings.dart';
import '../../data_access/data_manager.dart';
import '../../enums/category_enum.dart';
import '../../interfaces/i_view_controller.dart';
import '../../managers/page_manager.dart';
import '../../models/requests/transfer_savings_request_model.dart';
import '../../providers/app_provider.dart';
import '../../utils/functions_utils.dart';
import '../../utils/page_args.dart';
import '../popups/loading_popup.dart';

class TransferSavesPageController extends ControllerMVC
    implements IViewController {
  static late TransferSavesPageController _this;

  num get totalSaves => AppProvider().boardDataModel?.savesAmount ?? 0;

  bool get isEnabled {
    return totalSaves > 0 &&
        amountController.text.trim().isNotEmpty &&
        num.tryParse(amountController.text.trim()) != null &&
        (num.tryParse(amountController.text.trim()) ?? 0) <= totalSaves;
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

  void onPopInvoked(bool didPop, data) {
    if (didPop) return;
    // ADD CODE >>>>>>
    PageManager().goHomePage();
    // <<<<<<<<<<<<<<<
  }

  Future<void> onAccept() async {
    await LoadingPopup(
      context: PageManager().currentContext,
      onLoading: _onAcceptLoading(),
      onResult: (data) {
        _onAcceptSuccess();
      },
      onError: (err) {
        _onAcceptFailure();
      },
    ).show();
  }

  Future<void> _onAcceptLoading() async {
    await DataManager().transferSavings(
        transferSavingsRequestModel: TransferSavingsRequestModel(
      amount: num.parse(amountController.text),
      category: selectedCategory,
    ));
    return;
  }

  void _onAcceptFailure() {
    showToast(message: KStrings.transferSavingsErrorTransfer);
  }

  void _onAcceptSuccess() {
    showToast(message: KStrings.transferSavingsSuccessTransfer);
    PageManager().goHomePage();
  }

  void onCategoryTap(CategoryEnum category) {
    setState(() {
      selectedCategory = category;
    });
  }
}
