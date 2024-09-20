import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../../values/k_colors.dart';
import '../../../values/k_strings.dart';
import '../../../values/k_styles.dart';
import '../../../values/k_values.dart';
import '../../support/futuristic.dart';
import '../../utils/functions_utils.dart';
import '../../utils/page_args.dart';
import '../components/loading_component.dart';
import '../components/simple_components.dart';
import '../page_controllers/graphs_page_controller.dart';

class GraphsPage extends StatefulWidget {
  final PageArgs? args;
  const GraphsPage(this.args, {super.key});

  @override
  GraphsPageState createState() => GraphsPageState();
}

class GraphsPageState extends StateMVC<GraphsPage> {
  late GraphsPageController _con;
  PageArgs? args;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  GraphsPageState() : super(GraphsPageController()) {
    _con = GraphsPageController.con;
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
      onPopInvokedWithResult: _con.onPopInvoked,
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          appBar: SimpleComponents.menuAppBar(key: _key),
          drawer: SimpleComponents().getDrawer(key: _key),
          backgroundColor: KColors.primary,
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width *
                  KValues.horizontalWidthScreenMultiplier,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width *
                            KValues.horizontalWidthScreenMultiplier),
                    Expanded(
                      child: _tabButton(
                        label: KStrings.graphsPageCicle,
                        selected: !_con.historicSelected,
                        onTap: _con.onCicleTap,
                      ),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width *
                            KValues.horizontalWidthScreenMultiplier),
                    Expanded(
                      child: _tabButton(
                        label: KStrings.graphsPageHistory,
                        selected: _con.historicSelected,
                        onTap: _con.onHistoricTap,
                      ),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width *
                            KValues.horizontalWidthScreenMultiplier),
                  ],
                ),
                Expanded(
                  child: _cicleDataBuilder(),
                  // child: _con.historicSelected ? _historicBody() : _cicleBody(),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .025,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabButton({
    required String label,
    Function()? onTap,
    bool selected = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * .0125),
        decoration: BoxDecoration(
          color: KColors.primaryL1,
          borderRadius: BorderRadius.circular(10),
          border: selected ? Border.all(color: KColors.white) : null,
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: KColors.white.withOpacity(0.1),
                    blurRadius: 2,
                    spreadRadius: 5,
                  )
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: KColors.white,
                fontSize: KValues.fontSizeLarge,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _historicBody() {
    return Futuristic(
      futureBuilder: _con.getHistory,
      autoStart: true,
      forceUpdate: _con.historicForceUpdate,
      busyBuilder: (context) => loadingComponent(true),
      dataBuilder: (p0, p1) => _historicDataBuilder(),
      errorBuilder: (p0, p1, p2) => _errorBuilder(),
    );
  }

  Widget _historicDataBuilder() {
    if (_con.model != null) {
      return ListView();
    } else {
      return _emptyDataBuilder();
    }
  }

  Widget _cicleBody() {
    return Futuristic(
      futureBuilder: _con.getCicleData,
      autoStart: true,
      forceUpdate: _con.cicleForceUpdate,
      busyBuilder: (context) => loadingComponent(true),
      dataBuilder: (p0, p1) => _cicleDataBuilder(),
      errorBuilder: (p0, p1, p2) => _errorBuilder(),
    );
  }

  Widget _cicleDataBuilder() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        _cicleTotalInfo(),
      ],
    );
    if (_con.model != null) {
      return ListView();
    } else {
      return _emptyDataBuilder();
    }
  }

  Widget _errorBuilder() {
    return const Center(
      child: Text(
        KStrings.graphsPageErrorFailedToGetData,
        style: KStyles.errorViewPlaceholderTextStyle,
      ),
    );
  }

  Widget _emptyDataBuilder() {
    return const Center(
      child: Text(
        KStrings.graphsPageErrorEmptyData,
        style: KStyles.errorViewPlaceholderTextStyle,
      ),
    );
  }

  Widget _cicleTotalInfo() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                "${KStrings.graphsPageTotalIncome}: ",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: KColors.white,
                  fontSize: KValues.fontSizeLarge,
                ),
              ),
            ),
            Text(
              currencyFormat(1234567.89),
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: KColors.white,
                fontSize: KValues.fontSizeLarge,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(
                    _con.getIncomeDifferenceIcon,
                    color: KColors.white,
                    size: KValues.fontSizeLarge,
                  ),
                  Text(
                    _con.differenceString,

                    // "${KStrings.graphsPageTotalExpenses}: ",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: KColors.white,
                      fontSize: KValues.fontSizeLarge,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              currencyFormat(1234567.89),
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: KColors.white,
                fontSize: KValues.fontSizeLarge,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                "${KStrings.graphsPageTotalExpenses}: ",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: KColors.white,
                  fontSize: KValues.fontSizeLarge,
                ),
              ),
            ),
            Text(
              currencyFormat(1234567.89),
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: KColors.white,
                fontSize: KValues.fontSizeLarge,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
