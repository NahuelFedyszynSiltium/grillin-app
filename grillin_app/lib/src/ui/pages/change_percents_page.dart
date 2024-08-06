import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../../values/k_colors.dart';
import '../../../values/k_strings.dart';
import '../../../values/k_styles.dart';
import '../../../values/k_values.dart';
import '../../enums/category_enum.dart';
import '../../support/futuristic.dart';
import '../../utils/page_args.dart';
import '../components/button_component.dart';
import '../components/simple_components.dart';
import '../page_controllers/change_percents_page_controller.dart';

class ChangePercentsPage extends StatefulWidget {
  final PageArgs? args;
  const ChangePercentsPage(this.args, {super.key});

  @override
  ChangePercentsPageState createState() => ChangePercentsPageState();
}

class ChangePercentsPageState extends StateMVC<ChangePercentsPage> {
  late ChangePercentsPageController _con;
  PageArgs? args;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  ChangePercentsPageState() : super(ChangePercentsPageController()) {
    _con = ChangePercentsPageController.con;
  }

  @override
  void initState() {
    _con.initPage(arguments: widget.args);
    super.initState();
  }

  @override
  void dispose() {
    _con.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: _con.onPopInvoked,
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: KColors.primary,
          appBar: SimpleComponents.menuAppBar(key: _key),
          drawer: SimpleComponents().getDrawer(key: _key),
          body: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.02),
            child: Futuristic(
              futureBuilder: _con.getPercentValues,
              autoStart: true,
              busyBuilder: (context) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: KColors.primaryL1,
                  ),
                );
              },
              dataBuilder: (p0, p1) => _dataBuilder(),
              errorBuilder: (p0, p1, p2) => _placeholder(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Center(
      child: Text(
        KStrings.errorFailedToGetPercents,
        textAlign: TextAlign.center,
        style: KStyles.errorViewPlaceholderTextStyle,
      ),
    );
  }

  Widget _dataBuilder() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height: MediaQuery.of(context).size.width * 0.05),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _categoryButton(
              category: CategoryEnum.dailys,
            ),
            const SizedBox(width: 5),
            _categoryButton(
              category: CategoryEnum.personals,
            ),
            const SizedBox(width: 5),
            _categoryButton(
              category: CategoryEnum.achievemnts,
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.width * 0.05),
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _percentButton(percent: 0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .04,
                  ),
                  _percentButton(percent: 5),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .04,
                  ),
                  _percentButton(percent: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .04,
                  ),
                  _percentButton(percent: 15),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * .04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _percentButton(percent: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .04,
                  ),
                  _percentButton(percent: 25),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .04,
                  ),
                  _percentButton(percent: 30),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .04,
                  ),
                  _percentButton(percent: 35),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * .04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _percentButton(percent: 40),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .04,
                  ),
                  _percentButton(percent: 45),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .04,
                  ),
                  _percentButton(percent: 50),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .04,
                  ),
                  _percentButton(percent: 55),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * .04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _percentButton(percent: 60),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .04,
                  ),
                  _percentButton(percent: 65),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .04,
                  ),
                  _percentButton(percent: 70),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .04,
                  ),
                  _percentButton(percent: 75),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * .04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _percentButton(percent: 80),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .04,
                  ),
                  _percentButton(percent: 85),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .04,
                  ),
                  _percentButton(percent: 90),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .04,
                  ),
                  _percentButton(percent: 95),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * .04,
              ),
              _percentButton(percent: 100, isFinite: false),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * .04,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width *
                  KValues.horizontalWidthScreenMultiplier),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    "${KStrings.selectedTotalPercent}: ",
                    style: TextStyle(
                      color: _con.isValidPercent ? KColors.white : Colors.red,
                      fontSize: KValues.fontSizeMedium,
                    ),
                  ),
                ),
                Text(
                  _con.percentsMap.values
                      .reduce(
                        (value, element) => value + element,
                      )
                      .toString(),
                  style: TextStyle(
                    color: _con.isValidPercent ? KColors.white : KColors.redL1,
                    fontSize: KValues.fontSizeLargeXL,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * .04,
        ),
        ButtonComponent(
          onAccept: _con.onAccept,
          isEnabled: _con.isValidPercent,
          color: KColors.primaryL1,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * .04,
        ),
      ],
    );
  }

  _percentButton({required int percent, bool isFinite = true}) {
    return InkWell(
      onTap: () {
        _con.onPercentButtonTap(percent);
      },
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.width * .2,
            width: isFinite
                ? MediaQuery.of(context).size.width * .2
                : double.infinity,
            decoration: BoxDecoration(
              gradient: _con.getGradient(percent),
              boxShadow: [_con.getShadow(percent)],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                percent.toString(),
                textAlign: TextAlign.center,
                maxLines: 1,
                style: const TextStyle(
                  color: KColors.white,
                  fontSize: KValues.fontSizeLargeXL,
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.width * .2,
            width: isFinite
                ? MediaQuery.of(context).size.width * .2
                : double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  KColors.white.withOpacity(.1),
                  Colors.transparent,
                ],
                transform: const GradientRotation(pi * .25),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          )
        ],
      ),
    );
  }

  Widget _categoryButton({required CategoryEnum category}) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        _con.onCategoryTap(category);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: MediaQuery.of(context).size.width * .15,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width *
              (category == _con.selectedCategory ? .1 : .05),
        ),
        decoration: BoxDecoration(
            color: category.categoryColor(),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: category == _con.selectedCategory
                    ? KColors.white
                    : Colors.transparent),
            boxShadow: _con.selectedCategory == category
                ? [
                    BoxShadow(
                      color: KColors.white.withOpacity(0.1),
                      blurRadius: 2,
                      spreadRadius: 5,
                    ),
                  ]
                : null),
        child: Text(
          category.categoryName(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: KColors.white,
            fontSize: KValues.fontSizeMedium,
          ),
        ),
      ),
    );
  }
}
