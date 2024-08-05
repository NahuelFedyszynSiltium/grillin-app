// Package imports:
import 'package:flutter/services.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

// Project imports:
import '../../../src/managers/page_manager.dart';
import '../../../values/k_values.dart';
import '../../interfaces/i_view_controller.dart';
import '../../managers/data_manager.dart';
import '../../providers/app_provider.dart';
import '../../utils/page_args.dart';

class InitPageController extends ControllerMVC implements IViewController {
  static late InitPageController _this;

  factory InitPageController(PageArgs? args) {
    _this = InitPageController._(args);
    return _this;
  }

  static InitPageController get con => _this;
  PageArgs? args;
  InitPageController._(this.args);

  @override
  void initPage({PageArgs? arguments}) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    args = arguments;
  }

  @override
  disposePage() {}

  initApp() async {
    await Future.delayed(KValues.splashDuration);
    await DataManager().init();
    await AppProvider().init();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    PageManager().goHomePage();
  }
}
