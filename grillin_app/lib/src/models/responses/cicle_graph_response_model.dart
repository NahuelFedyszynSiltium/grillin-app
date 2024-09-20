// ignore_for_file: library_private_types_in_public_api

import '../../enums/category_enum.dart';
import '../concept_model.dart';

class CicleGraphResponseModel {
  late int cicleId;
  late double totalExpenses;
  late double totalSaves;
  late double totalIncome;
  late _CicleCategoriesModel savingsTotal;
  late _CicleCategoriesModel personalsTotal;
  late _CicleCategoriesModel dailysTotal;
  late _CicleCategoriesModel achievemntsTotal;
  late CicleGraphResponseModel? comparisonCicle;
  late DateTime from;
  late DateTime? to;

  bool get isActualCicle => to == null;

  CicleGraphResponseModel.fromJson(Map<String, dynamic> json) {
    cicleId = json["cicleId"];
    totalIncome = json["totalIncome"];
    totalExpenses = json["totalExpenses"];
    totalSaves = json["totalSaves"];
    savingsTotal = _CicleCategoriesModel.fromJson(json["savingsTotal"]);
    personalsTotal = _CicleCategoriesModel.fromJson(json["personalsTotal"]);
    dailysTotal = _CicleCategoriesModel.fromJson(json["dailysTotal"]);
    achievemntsTotal = _CicleCategoriesModel.fromJson(json["achievemntsTotal"]);
    comparisonCicle = json["comparisonCicle"] != null
        ? CicleGraphResponseModel.fromJson(json["comparisonCicle"])
        : null;
    from = DateTime.parse(json["from"]);
    to = DateTime.tryParse(json["to"]);
  }
}

class _CicleCategoriesModel {
  late int cicleCategoriesId;
  late CategoryEnum categoryEnum;
  late double total;
  late List<_CategoriesConceptsModel> categoriesConcepts;

  _CicleCategoriesModel.fromJson(Map<String, dynamic> json) {
    cicleCategoriesId = json["cicleCategoriesId"];
    categoryEnum = CategoryEnum.values
        .firstWhere((element) => element.value == json["categoryId"]);
    total = json["total"];
    if (json["categoriesConcepts"].length > 0) {
      categoriesConcepts = List<_CategoriesConceptsModel>.from(
          json["categoriesConcepts"]
              .map((e) => _CategoriesConceptsModel.fromJson(e)));
    } else {
      categoriesConcepts = [];
    }
  }
}

class _CategoriesConceptsModel {
  late int categoriesConceptId;
  late double total;
  late ConceptModel concept;

  _CategoriesConceptsModel.fromJson(Map<String, dynamic> json) {
    categoriesConceptId = json["categoriesConceptId"];
    total = json["total"];
    concept = ConceptModel.fromJson(json["concept"]);
  }
}
