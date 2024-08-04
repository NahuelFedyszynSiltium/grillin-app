class DataManager {
  static final DataManager _instance = DataManager._constructor();

  factory DataManager() {
    return _instance;
  }

  DataManager._constructor();

  init() async {}

  void cleanData() {}
}
