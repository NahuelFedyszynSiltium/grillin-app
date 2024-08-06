import '../enums/category_enum.dart';
import '../models/board_data_model.dart';
import '../models/concept_model.dart';
import '../models/expense_model.dart';
import '../models/percents_category_response_model.dart';

class DataManager {
  static final DataManager _instance = DataManager._constructor();

  factory DataManager() {
    return _instance;
  }

  DataManager._constructor();

  init() async {}

  void cleanData() {}

  // REGION GET

  Future<BoardDataModel> getBoardData() async {
    //TODO: DATABASE GET
    await Future.delayed(const Duration(seconds: 2));
    return BoardDataModel(
      percentsCategoryResponseModel: PercentsCategoryResponseModel(
          achievemntsPercent: 20, dailysPercent: 50, personalsPercent: 30),
      achievemtnRemainingAmount: 1000.58,
      dailyRemainingAmount: 987,
      personalRemainingAmount: 123.781,
      savesAmount: 13513.115371523,
    );
  }

  Future<List<ConceptModel>> getCategoryConcepts(
      {required CategoryEnum category}) async {
    //TODO: DATABASE GET
    await Future.delayed(const Duration(seconds: 2));
    return [];
  }

  Future<PercentsCategoryResponseModel> getPercentsPerCategory() async {
    //TODO: DATABASE GET
    await Future.delayed(const Duration(seconds: 2));
    return PercentsCategoryResponseModel(
      achievemntsPercent: 20,
      dailysPercent: 50,
      personalsPercent: 30,
    );
  }

  // END REGION GET

  // REGION POST

  Future<void> postAddNewExpense({required ExpenseModel expenseModel}) async {
    await Future.delayed(const Duration(seconds: 2));
    //TODO: DATABASE ADD
  }

  Future<void> postSetFixedIncome({required double income}) async {
    await Future.delayed(const Duration(seconds: 2));
    //TODO: DATABASE ADD
  }

  // END REGION POST

  // REGION PUT

  Future<void> putUpdatePercents(
      {required PercentsCategoryResponseModel
          percentsCategoryREsponseModel}) async {
    //TODO: DATABASE UPDATE
    await Future.delayed(const Duration(seconds: 2));
  }

  // END REGION PUT

  // REGION DELETE

  // END REGION DELETE
}
