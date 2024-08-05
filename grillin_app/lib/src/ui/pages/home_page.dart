// Flutter imports:
import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';

// Package imports:
import 'package:mvc_pattern/mvc_pattern.dart';

// Project imports:
import '../../../values/k_colors.dart';
import '../../../values/k_styles.dart';
import '../../enums/category_enum.dart';
import '../../utils/functions_utils.dart';
import '../../utils/page_args.dart';
import '../components/simple_components.dart';
import '../page_controllers/home_page_controller.dart';

class HomePage extends StatefulWidget {
  final PageArgs? args;
  const HomePage(this.args, {Key? key}) : super(key: key);

  @override
  HomePagePageState createState() => HomePagePageState();
}

class HomePagePageState extends StateMVC<HomePage> {
  late HomePageController _con;
  PageArgs? args;

  HomePagePageState() : super(HomePageController()) {
    _con = HomePageController.con;
  }

  @override
  void initState() {
    _con.initPage(arguments: widget.args);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => _con.onBack(didPop, context),
      child: SafeArea(
        child: Scaffold(
          appBar: SimpleComponents.menuAppBar,
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: const BoxDecoration(
              color: KColors.primary,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: _card(
                      category: CategoryEnum.dailys,
                      amount: 123.54,
                    ),
                  ),
                  Expanded(
                    child: _card(
                      category: CategoryEnum.personals,
                      amount: 16413567641651351.54,
                    ),
                  ),
                  Expanded(
                    child: _card(
                      category: CategoryEnum.achievemnts,
                      amount: 123.54,
                    ),
                  ),
                  Expanded(
                    child: _card(
                      category: CategoryEnum.saves,
                      showTransferButton: true,
                      amount: 123.54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _card({
    required CategoryEnum category,
    required double amount,
    bool showTransferButton = false,
  }) {
    return GestureDetector(
      onTap: () {
        _con.onCategoryTap(category: category);
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: category.categoryColor(),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  KColors.white.withOpacity(0.5),
                  Colors.transparent,
                  KColors.white.withOpacity(0.5),
                ],
                transform: const GradientRotation(math.pi / 3),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 40,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        category.homeCardName(),
                        style: KStyles.homeCardTitleTextStyle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "\$ ${currencyFormat(amount)}",
                          style: KStyles.homeCardBodyTextStyle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}