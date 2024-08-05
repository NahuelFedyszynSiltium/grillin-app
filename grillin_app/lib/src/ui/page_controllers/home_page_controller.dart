// Flutter imports:
import 'dart:developer';

import 'package:flutter/material.dart';

// Package imports:
import 'package:mvc_pattern/mvc_pattern.dart';

// Project imports:
import '../../enums/category_enum.dart';
import '../../interfaces/i_view_controller.dart';
import '../../managers/page_manager.dart';
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

  @override
  void initPage({PageArgs? arguments}) {
    controller = TextEditingController();
  }

  void onBack(bool didPop, BuildContext context) {
    if (didPop) return;
    PageManager().goBack();
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
