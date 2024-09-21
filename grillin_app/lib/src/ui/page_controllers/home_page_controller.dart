// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:mvc_pattern/mvc_pattern.dart';

// Project imports:
import '../../../values/k_strings.dart';
import '../../data_access/data_manager.dart';
import '../../enums/category_enum.dart';
import '../../interfaces/i_view_controller.dart';
import '../../managers/page_manager.dart';
import '../../models/board_data_model.dart';
import '../../utils/functions_utils.dart';
import '../../utils/page_args.dart';
import '../popups/custom_overlay_popup.dart';

class HomePageController extends ControllerMVC implements IViewController {
  static late HomePageController _this;

  factory HomePageController() {
    _this = HomePageController._();
    return _this;
  }

  static HomePageController get con => _this;
  PageArgs? args;
  HomePageController._();

  bool _availableToClose = false;
  bool forceUpdate = false;
  bool isLoading = false;
  BoardDataModel? boardDataModel;

  @override
  void initPage({PageArgs? arguments}) {
    forceUpdate = false;
  }

  void onBack(bool didPop, BuildContext context) {
    if (didPop) return;
    if (_availableToClose) {
      return PageManager().goBack();
    } else {
      _availableToClose = true;
      showToast(
          message: KStrings.tapAgainToExit,
          duration: const Duration(seconds: 2));
      Future.delayed(const Duration(seconds: 2)).then((value) {
        _availableToClose = false;
      });
      return;
    }
  }

  Future<void> onCategoryTap({required CategoryEnum category}) async {
    if (boardDataModel == null) {
      showToast(
          message: KStrings.errorsSetFixedAmountFirst,
          duration: const Duration(seconds: 3));
      return;
    }
    bool? result = await showDialog(
      context: PageManager().currentContext,
      barrierColor: Colors.transparent,
      builder: (context) {
        return AddExpensePopup(
          category: category,
        );
      },
    );
    if (result ?? false) {
      _refresh();
    }
  }

  Future<void> getBoardData() async {
    forceUpdate = false;
    try {
      boardDataModel = await DataManager().getBoardData();
      if (boardDataModel == null) {
        showToast(
            message: KStrings.errorsSetFixedAmountFirst,
            duration: const Duration(seconds: 3));
      }
    } catch (err) {
      showToast(message: KStrings.homeErrorFailedToGetBoardData);
    }

    isLoading = false;

    return;
  }

  void _refresh() {
    setState(() {
      forceUpdate = true;
    });
  }

  Future<void> onRefreshIndicator() async {
    setState(() {
      isLoading = true;
      boardDataModel = null;
      forceUpdate = true;
    });
  }

  @override
  disposePage() {}

  void onGetBoardDataEnd() {
    setState(() {
      isLoading = false;
    });
  }
}
