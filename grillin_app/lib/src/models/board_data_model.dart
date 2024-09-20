class BoardDataModel {
  late double dailyRemainingAmount;
  late double achievementRemainingAmount;
  late double personalRemainingAmount;
  late int dailyPercent;
  late int achievementPercent;
  late int personalPercent;
  late double savesAmount;

  BoardDataModel({
    required this.achievementRemainingAmount,
    required this.dailyRemainingAmount,
    required this.personalRemainingAmount,
    required this.achievementPercent,
    required this.dailyPercent,
    required this.personalPercent,
    required this.savesAmount,
  });
}
