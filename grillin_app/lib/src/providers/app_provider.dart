// Flutter imports:
import 'package:flutter/material.dart';

import '../models/board_data_model.dart';

class AppProvider with ChangeNotifier {
  static final AppProvider _instance = AppProvider._constructor();

  factory AppProvider() {
    return _instance;
  }

  AppProvider._constructor();

  BoardDataModel? boardDataModel;

  init() async {}
}
