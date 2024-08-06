// Flutter imports:
import 'dart:math' as math;
import 'package:flutter/material.dart';

// Package imports:
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shimmer/shimmer.dart';

// Project imports:
import '../../../values/k_colors.dart';
import '../../../values/k_styles.dart';
import '../../../values/k_values.dart';
import '../../enums/category_enum.dart';
import '../../support/futuristic.dart';
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
  final GlobalKey<ScaffoldState> _key = GlobalKey();

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
          appBar: SimpleComponents.menuAppBar(key: _key),
          resizeToAvoidBottomInset: false,
          drawer: SimpleComponents().getDrawer(key: _key),
          backgroundColor: KColors.primary,
          body: RefreshIndicator(
            onRefresh: _con.onRefreshIndicator,
            color: KColors.primary,
            child: ListView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              children: [
                Stack(
                  children: [
                    Futuristic(
                      autoStart: true,
                      futureBuilder: _con.getBoardData,
                      forceUpdate: _con.forceUpdate,
                      dataBuilder: (p0, p1) => const SizedBox.shrink(),
                      onData: (value) {
                        _con.onGetBoardDataEnd();
                      },
                      onError: (p1, p2) {
                        _con.onGetBoardDataEnd();
                      },
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: KColors.primary,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            _card(
                              category: CategoryEnum.dailys,
                              amount: _con.boardDataModel?.dailyRemainingAmount,
                              percent: _con.boardDataModel
                                  ?.percentsCategoryResponseModel.dailysPercent,
                            ),
                            SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    0.0125),
                            _card(
                              category: CategoryEnum.personals,
                              amount:
                                  _con.boardDataModel?.personalRemainingAmount,
                              percent: _con
                                  .boardDataModel
                                  ?.percentsCategoryResponseModel
                                  .personalsPercent,
                            ),
                            SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    0.0125),
                            _card(
                              category: CategoryEnum.achievemnts,
                              amount: _con
                                  .boardDataModel?.achievemtnRemainingAmount,
                              percent: _con
                                  .boardDataModel
                                  ?.percentsCategoryResponseModel
                                  .achievemntsPercent,
                            ),
                            SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    0.0125),
                            _card(
                              category: CategoryEnum.saves,
                              amount: _con.boardDataModel?.savesAmount,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _card({
    required CategoryEnum category,
    required double? amount,
    int? percent,
  }) {
    return GestureDetector(
      onTap: () {
        _con.onCategoryTap(category: category);
      },
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .2,
            width: double.infinity,
            decoration: BoxDecoration(
              color: category.categoryColor(),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Visibility(
              visible: category != CategoryEnum.saves && percent != null,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  "$percent ",
                  style: TextStyle(
                    color: KColors.white.withOpacity(0.125),
                    fontSize: MediaQuery.of(context).size.width * .4,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * .2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  KColors.white.withOpacity(0.2),
                  Colors.transparent,
                  KColors.white.withOpacity(0.1),
                  Colors.transparent,
                  KColors.white.withOpacity(0.2),
                ],
                transform: const GradientRotation(math.pi / 3),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * .025,
                horizontal: 15,
              ),
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
                      child: _con.isLoading
                          ? Shimmer.fromColors(
                              baseColor: category.categoryColor(),
                              highlightColor: KColors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      category.categoryColor().withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                width: double.infinity,
                                height: KValues.fontSizeLarge,
                              ),
                            )
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "\$ ${amount != null ? currencyFormat(amount) : "- "}",
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
