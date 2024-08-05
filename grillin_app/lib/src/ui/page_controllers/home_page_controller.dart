// Flutter imports:
import 'dart:developer';

import 'package:flutter/material.dart';

// Package imports:
import 'package:mvc_pattern/mvc_pattern.dart';

// Project imports:
import '../../../values/k_strings.dart';
import '../../enums/category_enum.dart';
import '../../interfaces/i_view_controller.dart';
import '../../managers/page_manager.dart';
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

  bool isLoading = false;
  TextEditingController controller = TextEditingController();

  bool _availableToClose = false;

  @override
  void initPage({PageArgs? arguments}) {
    controller = TextEditingController();
  }

  void onBack(bool didPop, BuildContext context) {
    if (didPop) return;
    if (_availableToClose) {
      return PageManager().goBack();
    } else {
      _availableToClose = true;
      showToast(
          message: KStrings.tapAgainToExit,
          context: PageManager().currentContext,
          duration: const Duration(seconds: 2));
      Future.delayed(const Duration(seconds: 2)).then((value) {
        _availableToClose = false;
      });
      return;
    }
  }

  Future<void> onCategoryTap({required CategoryEnum category}) async {
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

  void _refresh() {
    log("REFRESH");
    setState(() {});
  }

  @override
  disposePage() {}
}
