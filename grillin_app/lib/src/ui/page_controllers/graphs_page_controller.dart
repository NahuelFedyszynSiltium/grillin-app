import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../../values/k_strings.dart';
import '../../interfaces/i_view_controller.dart';
import '../../managers/page_manager.dart';
import '../../models/cicle_model.dart';
import '../../models/responses/cicle_graph_response_model.dart';
import '../../utils/functions_utils.dart';
import '../../utils/page_args.dart';

class GraphsPageController extends ControllerMVC implements IViewController {
  static late GraphsPageController _this;

  factory GraphsPageController() {
    _this = GraphsPageController._();
    return _this;
  }

  static GraphsPageController get con => _this;
  GraphsPageController._();

  PageArgs? args;
  bool historicSelected = false;
  List<CicleModel> ciclesList = [];
  CicleModel? selectedCicle;

  CicleGraphResponseModel? model;

  bool historicForceUpdate = false;
  bool cicleForceUpdate = false;

  String get differenceString {
    if (model != null) {
      return model!.isActualCicle
          ? KStrings.graphsPageDifferencePrevious
          : KStrings.graphsPageDifferenceActual;
    } else {
      return "";
    }
  }

  IconData? get getIncomeDifferenceIcon {
    return Icons.arrow_drop_down;
    // if (model != null) {
    //   if(model!.isActualCicle){
    //     if(model.)
    //   }
    // } else {
    //   return Icons.arrow_drop_down;
    // }
  }

  IconData? get getTotalExpensesDifferenceIcon => null;
  IconData? get getSavesDifferenceIcon => null;
  IconData? get getPersonalsDifferenceIcon => null;
  IconData? get getDailysDifferenceIcon => null;
  IconData? get getAchievemntsDifferenceIcon => null;

  @override
  void initPage({PageArgs? arguments}) {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  disposePage() {}

  void onPopInvoked(bool didPop, data) {
    if (didPop) return;
    PageManager().goHomePage();
  }

  Future<void> getHistory() async {
    // model = await DataManager().getCicleHistoricData();
  }

  Future<void> getCicleData() async {
    if (selectedCicle?.cicleId != null) {
      // model = await DataManager().getCicleData(cicleId: selectedCicle!.cicleId!);
    } else {
      showToast(message: KStrings.graphsPagePleaseSelectCicle);
    }
  }

  void onCicleTap() {
    setState(() {
      historicSelected = false;
    });
  }

  void onHistoricTap() {
    setState(() {
      historicSelected = true;
    });
  }
}
