import '../../enums/category_enum.dart';

class TransferSavingsRequestModel {
  CategoryEnum category;
  num amount;
  TransferSavingsRequestModel({
    required this.amount,
    required this.category,
  });
}
