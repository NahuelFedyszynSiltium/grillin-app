import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../../values/k_strings.dart';
import '../../data_access/data_manager.dart';
import '../../interfaces/i_view_controller.dart';
import '../../managers/page_manager.dart';
import '../../utils/functions_utils.dart';
import '../../utils/page_args.dart';
import '../popups/loading_popup.dart';

class SetIncomePageController extends ControllerMVC implements IViewController {
  static late SetIncomePageController _this;

  factory SetIncomePageController() {
    _this = SetIncomePageController._();
    return _this;
  }

  static SetIncomePageController get con => _this;
  SetIncomePageController._();

  PageArgs? args;

  final TextEditingController amountController = TextEditingController();

  bool get isEnabled => double.tryParse(amountController.text) != null;

  @override
  void initPage({PageArgs? arguments}) {}

  @override
  disposePage() {}

  void onPopInvoked(bool didPop, data) {
    if (didPop) return;
    PageManager().goHomePage();
  }

  Future<void> onAccept() async {
    await LoadingPopup(
      context: PageManager().currentContext,
      onLoading: DataManager()
          .startNewCicle(fixedIncome: double.parse(amountController.text)),
      onResult: (data) {
        _onAcceptSuccess();
      },
      onError: (err) {
        _onAcceptFailure();
      },
    ).show();
  }

  void _onAcceptSuccess() {
    FocusManager.instance.primaryFocus?.unfocus();
    showToast(message: KStrings.setFixedIncomeSetNewIncomeSuccess);
    PageManager().goHomePage();
  }

  void _onAcceptFailure() {
    FocusManager.instance.primaryFocus?.unfocus();
    showToast(message: KStrings.setFixedIncomeSetNewIncomeError);
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
