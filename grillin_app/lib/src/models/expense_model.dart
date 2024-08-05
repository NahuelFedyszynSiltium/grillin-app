import '../enums/category_enum.dart';
import 'concept_model.dart';

class ExpenseModel {
  int? id;
  CategoryEnum category;
  ConceptModel conceptModel;
  DateTime? createdAt;
  double amount;

  ExpenseModel({
    required this.conceptModel,
    required this.amount,
    required this.category,
    this.id,
    this.createdAt,
  });
}
