// ignore_for_file: avoid_function_literals_in_foreach_calls, constant_identifier_names

import 'package:collection/collection.dart';
import 'package:sqflite/sqflite.dart';

import '../enums/category_enum.dart';
import '../models/board_data_model.dart';
import '../models/cicle_model.dart';
import '../models/concept_model.dart';
import '../models/expense_model.dart';
import '../models/requests/transfer_savings_request_model.dart';
import '../models/responses/category_response_model.dart';
import '../models/responses/total_expenses_by_category_response_model.dart';
import '../providers/app_provider.dart';
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
  ASC("ASC"),
  DESC("DESC");

  final String value;

  const OrderCriteria(this.value);
}

class FilterModel {
  OrderCriteria orderCriteria = OrderCriteria.DESC;
  String? columnName;
  String? filter;

  FilterModel({
    this.columnName,
    this.filter,
    this.orderCriteria = OrderCriteria.DESC,
  });

  String? getOrderBy() {
    if (columnName != null) {
      return "$columnName ${orderCriteria.value}";
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

  ///Devuelve la suma de todo lo que sobro. Útil para sumar al campo de saves al iniciar el proximo ciclo
  Future<num> closeCurrentCicle() async {
    CicleModel? currentCicle = await getCurrentCicle();
    if (currentCicle?.cicleId == null) {
      throw Exception("No se puede cerrar un ciclo que no inicio");
    } else {
      BoardDataModel? currentBoardData = await getBoardData();
      num totalSavings = 0;
      totalSavings += (currentBoardData?.achievementRemainingAmount ?? 0);
      totalSavings += (currentBoardData?.personalRemainingAmount ?? 0);
      totalSavings += (currentBoardData?.dailyRemainingAmount ?? 0);
      totalSavings += (currentBoardData?.savesAmount ?? 0);

      _database.update(
          _TableNames.cicles.tableName, {"endedAt": DateTime.now.toString()},
          where: "cicleId = ${currentCicle!.cicleId}");

      return totalSavings;
    }
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

      BoardDataModel result = BoardDataModel(
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
      AppProvider().boardDataModel = result;
      return result;
    } else {
      return null;
    }
  }

  Future<List<CategoryResponseModel>> getCategories() async {
    List<Map<String, dynamic>> result = await _database
        .rawQuery("SELECT * FROM ${_TableNames.categories.tableName}");
    if (result.isNotEmpty) {
      List<CategoryResponseModel> aux = List<CategoryResponseModel>.from(
          result.map((e) => CategoryResponseModel.fromJson(e)));
      return aux;
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
      CicleModel aux =
          List<CicleModel>.from(result.map((e) => CicleModel.fromJson(e)))
              .first;
      return aux;
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

  Future<ConceptModel> getConcept({required int conceptId}) async {
    List<Map<String, dynamic>> result = await _database
        .query(_TableNames.concepts.tableName, where: "conceptId = $conceptId");
    ConceptModel aux =
        List<ConceptModel>.from(result.map((e) => ConceptModel.fromJson(e)))
            .first;
    return aux;
  }

  Future<List<ConceptModel>> getConceptsByCategory(
      {required CategoryEnum categoryEnum}) async {
    List<Map<String, dynamic>> result = await _database.query(
        _TableNames.concepts.tableName,
        where:
            "categoryId = ${categoryEnum.value} AND conceptId != 0 AND conceptId != 1");
    //EL DISTINTO DE CERO ES PARA EVITAR MOSTRAR EL CONCEPTO DE TRANSFERENCIA PARA LA CATEGORIA DE SAVES
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
        aux = aux.substring(2);
        result += " AND ($aux)";
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
      List<ExpenseModel> expenses = List<ExpenseModel>.from(
          result.map((element) => ExpenseModel.fromJson(element)));
      for (ExpenseModel expense in expenses) {
        expense.conceptModel = await getConcept(conceptId: expense.conceptId);
      }
      return expenses;
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

  Future<int> insertConcept({required ConceptModel conceptModel}) async {
    conceptModel.createdAt = DateTime.now();
    return await _database.insert(
        _TableNames.concepts.tableName, conceptModel.toJson());
  }

  Future<int> insertExpense({required ExpenseModel expenseModel}) async {
    if (expenseModel.conceptModel.conceptId == null) {
      int conceptId =
          await insertConcept(conceptModel: expenseModel.conceptModel);
      expenseModel.conceptId = conceptId;
    } else {
      expenseModel.conceptId = expenseModel.conceptModel.conceptId!;
    }
    expenseModel.createdAt = DateTime.now();
    expenseModel.cicleId = (await getCurrentCicle())!.cicleId!;
    return await _database.insert(
      _TableNames.expenses.tableName,
      expenseModel.toJson(),
    );
  }

  Future<CicleModel> startNewCicle({required num fixedIncome}) async {
    CicleModel? currentCicle = await getCurrentCicle();
    num? totalSavings;
    if (currentCicle?.cicleId != null) {
      totalSavings = await closeCurrentCicle();
    }
    int result = await _database.insert(
      _TableNames.cicles.tableName,
      CicleModel(
        createdAt: DateTime.now(),
        fixedIncome: fixedIncome,
      ).toJson(),
    );
    await _database.update(
      _TableNames.categories.tableName,
      {
        "addFromSavings": 0,
      },
    );
    if (totalSavings != null) {
      await _database.insert(
        _TableNames.expenses.tableName,
        {
          "conceptId": 1,
          "amount": totalSavings,
          "categoryId": CategoryEnum.saves.value,
          "cicleId": result,
          "createdAt": DateTime.now().toString(),
        },
      );
    }
    return (await getCicle(cicleId: result))!;
  }

  Future<void> transferSavings(
      {required TransferSavingsRequestModel
          transferSavingsRequestModel}) async {
    CicleModel currentCicle = (await getCurrentCicle())!;
    await _database.update(
        _TableNames.categories.tableName,
        {
          "addFromSavings": transferSavingsRequestModel.amount,
        },
        where: "categoryId = ${transferSavingsRequestModel.category.value}");
    await _database.insert(
      _TableNames.expenses.tableName,
      {
        "conceptId": 0,
        "amount": -transferSavingsRequestModel.amount,
        "categoryId": transferSavingsRequestModel.category.value,
        "cicleId": currentCicle.cicleId!,
        "createdAt": DateTime.now().toString(),
      },
    );
    await _database.insert(
      _TableNames.expenses.tableName,
      {
        "conceptId": 0,
        "amount": -transferSavingsRequestModel.amount,
        "categoryId": 3,
        "cicleId": currentCicle.cicleId!,
        "createdAt": DateTime.now().toString(),
      },
    );
  }

  Future<void> updatePercents(
      {required Map<CategoryEnum, int> percentsMap}) async {
    for (CategoryEnum category in percentsMap.keys) {
      _database.update(
        _TableNames.categories.tableName,
        {
          "percentValue": percentsMap[category],
        },
        where: "categoryId = ${category.value}",
      );
    }
  }
}
