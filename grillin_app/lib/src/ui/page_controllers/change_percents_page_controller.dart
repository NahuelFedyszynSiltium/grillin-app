import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../../values/k_colors.dart';
import '../../../values/k_strings.dart';
import '../../../values/k_styles.dart';
import '../../data_access/data_manager.dart';
import '../../enums/category_enum.dart';
import '../../interfaces/i_view_controller.dart';
import '../../managers/page_manager.dart';
import '../../models/responses/category_response_model.dart';
import '../../utils/functions_utils.dart';
import '../../utils/page_args.dart';
import '../popups/loading_popup.dart';

class ChangePercentsPageController extends ControllerMVC
    implements IViewController {
  static late ChangePercentsPageController _this;

  factory ChangePercentsPageController() {
    _this = ChangePercentsPageController._();
    return _this;
  }

  static ChangePercentsPageController get con => _this;
  ChangePercentsPageController._();

  PageArgs? args;

  CategoryEnum selectedCategory = CategoryEnum.personals;

  Map<CategoryEnum, int> percentsMap = {
    CategoryEnum.dailys: 0,
    CategoryEnum.personals: 0,
    CategoryEnum.achievements: 0,
  };

  bool get isValidPercent =>
      percentsMap.values.reduce((value, element) => value + element) == 100;

  @override
  void initPage({PageArgs? arguments}) {}

  @override
  disposePage() {}

  void onPopInvoked(bool didPop, data) {
    if (didPop) return;
    // ADD CODE >>>>>>
    PageManager().goHomePage();
    // <<<<<<<<<<<<<<<
  }

  void onPercentButtonTap(int percent) {
    switch (selectedCategory) {
      case CategoryEnum.dailys:
        setState(() {
          percentsMap[CategoryEnum.dailys] = percent;
        });
        break;
      case CategoryEnum.personals:
        setState(() {
          percentsMap[CategoryEnum.personals] = percent;
        });
        break;
      case CategoryEnum.achievements:
        setState(() {
          percentsMap[CategoryEnum.achievements] = percent;
        });
        break;
      case CategoryEnum.saves:
        break;
    }
  }

  int getPercentSelectedTimes(int percent) {
    int counter = 0;
    for (int element in percentsMap.values) {
      if (element == percent) {
        counter++;
      }
    }
    return counter;
  }

  Gradient getGradient(int percent) {
    switch (getPercentSelectedTimes(percent)) {
      case 0:
        return const LinearGradient(
          colors: [
            KColors.gray,
            KColors.gray,
          ],
        );
      case 1:
        return LinearGradient(
          colors: [
            CategoryEnum.values
                .firstWhere(
                  (element) =>
                      element ==
                      percentsMap.keys.firstWhere(
                        (element) => percentsMap[element] == percent,
                      ),
                )
                .categoryColor(),
            CategoryEnum.values
                .firstWhere(
                  (element) =>
                      element ==
                      percentsMap.keys.firstWhere(
                        (element) => percentsMap[element] == percent,
                      ),
                )
                .categoryColor(),
          ],
        );
      case 2:
        List<CategoryEnum> aux = [];
        for (CategoryEnum element in percentsMap.keys) {
          if (percentsMap[element] == percent) {
            aux.add(element);
          }
        }
        return LinearGradient(
          transform: const GradientRotation(pi * .25),
          colors: List<Color>.from(
            aux.map(
              (e) => e.categoryColor(),
            ),
          ),
        );
      case 3:
        return LinearGradient(
          transform: const GradientRotation(pi * .25),
          colors: [
            CategoryEnum.dailys.categoryColor(),
            CategoryEnum.personals.categoryColor(),
            CategoryEnum.achievements.categoryColor(),
          ],
          stops: const [.4, .5, .8],
        );
      default:
        return const LinearGradient(
          colors: [
            KColors.gray,
            KColors.gray,
          ],
        );
    }
  }

  BoxShadow getShadow(int percent) {
    if (getPercentSelectedTimes(percent) > 0) {
      return KStyles().percentButtonShadow;
    } else {
      return const BoxShadow(color: Colors.transparent);
    }
  }

  void onCategoryTap(CategoryEnum category) {
    setState(() {
      selectedCategory = category;
    });
  }

  Future<void> onAccept() async {
    await LoadingPopup(
      context: PageManager().currentContext,
      onLoading: _onAcceptLoading(),
      onResult: (data) {
        _onAcceptSuccess();
      },
      onError: (err) {
        _onAcceptFailure();
      },
    ).show();
  }

  Future<void> _onAcceptLoading() async {
    await DataManager().updatePercents(percentsMap: percentsMap);
    return;
  }

  void _onAcceptFailure() {
    showToast(message: KStrings.changePercentsErrorFailedToUpdatePercents);
  }

  void _onAcceptSuccess() {
    showToast(message: KStrings.changePercentsSuccessUpdatedPercents);
    PageManager().goHomePage();
  }

  Future<void> getPercentValues() async {
    List<CategoryResponseModel> response = await DataManager().getCategories();
    percentsMap[CategoryEnum.achievements] = response
            .firstWhereOrNull(
                (element) => element.categoryEnum == CategoryEnum.achievements)
            ?.percentValue ??
        0;
    percentsMap[CategoryEnum.dailys] = response
            .firstWhereOrNull(
                (element) => element.categoryEnum == CategoryEnum.dailys)
            ?.percentValue ??
        0;
    percentsMap[CategoryEnum.personals] = response
            .firstWhereOrNull(
                (element) => element.categoryEnum == CategoryEnum.personals)
            ?.percentValue ??
        0;
  }
}
