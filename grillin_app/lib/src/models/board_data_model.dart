class BoardDataModel {
  late num dailyRemainingAmount;
  late num achievementRemainingAmount;
  late num personalRemainingAmount;
  late int dailyPercent;
  late int achievementPercent;
  late int personalPercent;
  late num savesAmount;

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
