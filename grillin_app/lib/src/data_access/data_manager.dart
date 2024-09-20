// ignore_for_file: avoid_function_literals_in_foreach_calls, constant_identifier_names

import 'package:collection/collection.dart';
import 'package:sqflite/sqflite.dart';

import '../enums/category_enum.dart';
import '../models/board_data_model.dart';
import '../models/cicle_model.dart';
import '../models/concept_model.dart';
import '../models/expense_model.dart';
import '../models/responses/category_response_model.dart';
import '../models/responses/total_expenses_by_category_response_model.dart';
import 'sqlite_helper.dart';

enum _TableNames {
  categories("categories"),
  cicles("cicles"),
  concepts("concepts"),
  expenses("expenses");

  final String tableName;

  const _TableNames(this.tableName);
}

enum OrderCriteria {
  ASC,
  DESC,
}

class FilterModel {
  OrderCriteria orderCriteria = OrderCriteria.DESC;
  String? columnName;
  String? filter;

  String? getOrderBy() {
    if (columnName != null) {
      return "$columnName $orderCriteria";
    } else {
      return null;
    }
  }

  String? getLike() {
    if (filter != null) {
      return "LIKE %$filter%";
    } else {
      return null;
    }
  }
}

Database get _database => SqliteHelper().database;

class DataManager {
  static final DataManager _instance = DataManager._constructor();

  factory DataManager() {
    return _instance;
  }

  DataManager._constructor();

  Future<void> init() async {
    await SqliteHelper().init();
  }

  Future closeCicle({required int cicleId}) async {
    await _database.update(
      _TableNames.cicles.tableName,
      {
        "endedAt": DateTime.now().toString(),
      },
      where: "cicleId = $cicleId",
    );
  }

  Future<BoardDataModel?> getBoardData() async {
    List<CategoryResponseModel> categories = await getCategories();
    CicleModel? cicleModel = await getCurrentCicle();
    if (categories.isNotEmpty && cicleModel?.cicleId != null) {
      List<TotalExpensesByCategoryResponseModel> totalPerCategory =
          await getTotalExpensesByCategory(cicleId: cicleModel!.cicleId!);

      num dailysExpenses = totalPerCategory.isNotEmpty
          ? (totalPerCategory
                  .firstWhereOrNull(
                      (element) => element.categoryEnum == CategoryEnum.dailys)
                  ?.amount ??
              0)
          : 0;
      num personalsExpenses = totalPerCategory.isNotEmpty
          ? (totalPerCategory
                  .firstWhereOrNull((element) =>
                      element.categoryEnum == CategoryEnum.personals)
                  ?.amount ??
              0)
          : 0;
      num achievementsExpenses = totalPerCategory.isNotEmpty
          ? (totalPerCategory
                  .firstWhereOrNull((element) =>
                      element.categoryEnum == CategoryEnum.achievements)
                  ?.amount ??
              0)
          : 0;
      num saves = totalPerCategory.isNotEmpty
          ? (totalPerCategory
                  .firstWhereOrNull(
                      (element) => element.categoryEnum == CategoryEnum.saves)
                  ?.amount ??
              0)
          : 0;

      num remainingDailys = (cicleModel.fixedIncome *
              ((categories
                      .firstWhereOrNull((element) =>
                          element.categoryEnum == CategoryEnum.dailys)
                      ?.percentValue ??
                  0)) /
              100) -
          dailysExpenses +
          (categories
                  .firstWhereOrNull(
                      (element) => element.categoryEnum == CategoryEnum.dailys)
                  ?.addFromSavings ??
              0);
      num remainingPersonals = (cicleModel.fixedIncome *
              ((categories
                      .firstWhereOrNull((element) =>
                          element.categoryEnum == CategoryEnum.personals)
                      ?.percentValue ??
                  0)) /
              100) -
          personalsExpenses +
          (categories
                  .firstWhereOrNull((element) =>
                      element.categoryEnum == CategoryEnum.personals)
                  ?.addFromSavings ??
              0);
      num remainingAchievements = (cicleModel.fixedIncome *
              ((categories
                      .firstWhereOrNull((element) =>
                          element.categoryEnum == CategoryEnum.achievements)
                      ?.percentValue ??
                  0)) /
              100) -
          achievementsExpenses +
          (categories
                  .firstWhereOrNull((element) =>
                      element.categoryEnum == CategoryEnum.achievements)
                  ?.addFromSavings ??
              0);

      return BoardDataModel(
        achievementRemainingAmount: remainingAchievements,
        dailyRemainingAmount: remainingDailys,
        personalRemainingAmount: remainingPersonals,
        achievementPercent: (categories
                .firstWhereOrNull((element) =>
                    element.categoryEnum == CategoryEnum.achievements)
                ?.percentValue ??
            0),
        dailyPercent: (categories
                .firstWhereOrNull(
                    (element) => element.categoryEnum == CategoryEnum.dailys)
                ?.percentValue ??
            0),
        personalPercent: (categories
                .firstWhereOrNull(
                    (element) => element.categoryEnum == CategoryEnum.personals)
                ?.percentValue ??
            0),
        savesAmount: saves,
      );
    } else {
      return null;
    }
  }

  Future<List<CategoryResponseModel>> getCategories() async {
    List<Map<String, dynamic>> result =
        await _database.query(_TableNames.categories.tableName);
    if (result.isNotEmpty) {
      return List<CategoryResponseModel>.from(
          result.map((e) => CategoryResponseModel.fromJson(e)));
    } else {
      return [];
    }
  }

  Future<CicleModel?> getCicle({required int cicleId}) async {
    List<Map<String, dynamic>> result = await _database.query(
      _TableNames.cicles.tableName,
      where: "cicleId",
      limit: 1,
    );
    if (result.isNotEmpty) {
      return List<CicleModel>.from(result.map((e) => CicleModel.fromJson(e)))
          .first;
    } else {
      return null;
    }
  }

  Future<List<CicleModel>> getCicles() async {
    List<Map<String, dynamic>> result = await _database.query(
      _TableNames.cicles.tableName,
    );
    if (result.isNotEmpty) {
      return List<CicleModel>.from(result.map((e) => CicleModel.fromJson(e)));
    } else {
      return [];
    }
  }

  Future<List<ConceptModel>> getConceptsByCategory(
      {required CategoryEnum categoryEnum}) async {
    List<Map<String, dynamic>> result = await _database.query(
        _TableNames.concepts.tableName,
        where: "categoryId = ${categoryEnum.value}");
    if (result.isNotEmpty) {
      return List<ConceptModel>.from(
          result.map((element) => ConceptModel.fromJson(element)));
    } else {
      return [];
    }
  }

  Future<CicleModel?> getCurrentCicle() async {
    List<Map<String, dynamic>> result = await _database.query(
      _TableNames.cicles.tableName,
      orderBy: "cicleId DESC",
      limit: 1,
    );
    if (result.isNotEmpty) {
      return List<CicleModel>.from(result.map((e) => CicleModel.fromJson(e)))
          .first;
    } else {
      return null;
    }
  }

  Future<List<ExpenseModel>> getExpensesPerCicle({
    required int cicleId,
    List<CategoryEnum>? categories,
    FilterModel? filterModel,
  }) async {
    String buildWhere() {
      String result = "cicleId = $cicleId";
      if ((categories ?? []).isNotEmpty) {
        String aux = "";
        for (CategoryEnum category in categories!) {
          aux += "OR categoryId=${category.value} ";
        }
        aux.substring(2);
        result += " AND $aux";
      }
      if (filterModel?.getLike() != null) {
        result += filterModel!.getLike()!;
      }
      return result;
    }

    List<Map<String, dynamic>> result = await _database.query(
      _TableNames.expenses.tableName,
      where: buildWhere(),
      orderBy: filterModel?.getOrderBy(),
    );
    if (result.isNotEmpty) {
      return List<ExpenseModel>.from(
          result.map((element) => ExpenseModel.fromJson(element)));
    } else {
      return [];
    }
  }

  Future<List<TotalExpensesByCategoryResponseModel>> getTotalExpensesByCategory(
      {required int cicleId}) async {
    List<Map<String, dynamic>> result = await _database.rawQuery(
        "SELECT categoryId, SUM(amount) AS amount from expenses c WHERE cicleId = $cicleId GROUP BY categoryId ;");
    if (result.isNotEmpty) {
      return List<TotalExpensesByCategoryResponseModel>.from(result.map(
        (e) => TotalExpensesByCategoryResponseModel.fromJson(e),
      ));
    } else {
      return [];
    }
  }

  Future<void> insertConcept({required ConceptModel conceptModel}) async {
    conceptModel.createdAt = DateTime.now();
    await _database.insert(
        _TableNames.concepts.tableName, conceptModel.toJson());
  }

  Future<void> insertExpense({required ExpenseModel expenseModel}) async {
    if (expenseModel.conceptModel.conceptId == null) {
      await insertConcept(conceptModel: expenseModel.conceptModel);
    }
    expenseModel.createdAt = DateTime.now();
    await _database.insert(
      _TableNames.expenses.tableName,
      expenseModel.toJson(),
    );
  }

  Future<CicleModel> startNewCicle({required num fixedIncome}) async {
    try {
      CicleModel? currentCicle = await getCurrentCicle();
      if (currentCicle?.cicleId != null) {
        await closeCicle(cicleId: currentCicle!.cicleId!);
      }
      int result = await _database.insert(
          _TableNames.cicles.tableName,
          CicleModel(
            createdAt: DateTime.now(),
            expenses: [],
            fixedIncome: fixedIncome,
          ).toJson());
      return (await getCicle(cicleId: result))!;
    } catch (err) {
      rethrow;
    }
  }

  Future<void> transferSavings() async {}
}
