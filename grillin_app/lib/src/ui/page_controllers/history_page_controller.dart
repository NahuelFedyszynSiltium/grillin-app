import 'package:mvc_pattern/mvc_pattern.dart';
import '../../interfaces/i_view_controller.dart';
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

  @override
  void initPage({PageArgs? arguments}) {}

  @override
  disposePage() {}

  void onPopInvoked(didPop) {
    if (didPop) return;
    // ADD CODE >>>>>>

    // <<<<<<<<<<<<<<<
  }
}
  