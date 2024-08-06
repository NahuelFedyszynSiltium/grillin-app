import 'package:flutter/material.dart';

import '../../values/k_colors.dart';
import '../../values/k_strings.dart';

enum CategoryEnum {
  dailys(0),
  personals(1),
  achievemnts(2),
  saves(3);

  final int value;

  const CategoryEnum(this.value);
}

extension CategoryEnumExtension on CategoryEnum {
  String categoryName() {
    switch (this) {
      case CategoryEnum.achievemnts:
        return KStrings.categoryNameAchievemnts;
      case CategoryEnum.dailys:
        return KStrings.categoryNameDailys;
      case CategoryEnum.personals:
        return KStrings.categoryNamePersonals;
      case CategoryEnum.saves:
        return KStrings.categoryNameSaves;
    }
  }

  String homeCardName() {
    switch (this) {
      case CategoryEnum.achievemnts:
        return KStrings.homeCardNameAchievemnts;
      case CategoryEnum.dailys:
        return KStrings.homeCardNameDailys;
      case CategoryEnum.personals:
        return KStrings.homeCardNamePersonals;
      case CategoryEnum.saves:
        return KStrings.homeCardNameSaves;
    }
  }

  Color categoryColor() {
    switch (this) {
      case CategoryEnum.achievemnts:
        return KColors.purple;
      case CategoryEnum.dailys:
        return KColors.orange;
      case CategoryEnum.personals:
        return KColors.black;
      case CategoryEnum.saves:
        return KColors.green;
    }
  }

  Color categoryColorBright() {
    switch (this) {
      case CategoryEnum.achievemnts:
        return KColors.purpleL1;
      case CategoryEnum.dailys:
        return KColors.orangeL1;
      case CategoryEnum.personals:
        return KColors.blackL1;
      case CategoryEnum.saves:
        return KColors.greenL1;
    }
  }
}
