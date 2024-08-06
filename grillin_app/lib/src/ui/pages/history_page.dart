import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../../values/k_colors.dart';
import '../../../values/k_strings.dart';
import '../../../values/k_styles.dart';
import '../../../values/k_values.dart';
import '../../enums/category_enum.dart';
import '../../models/expense_model.dart';
import '../../support/futuristic.dart';
import '../../utils/functions_utils.dart';
import '../../utils/page_args.dart';
import '../components/loading_component.dart';
import '../components/simple_components.dart';
import '../page_controllers/history_page_controller.dart';

class HistoryPage extends StatefulWidget {
  final PageArgs? args;
  const HistoryPage(this.args, {super.key});

  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends StateMVC<HistoryPage> {
  late HistoryPageController _con;
  PageArgs? args;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  HistoryPageState() : super(HistoryPageController()) {
    _con = HistoryPageController.con;
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
          resizeToAvoidBottomInset: true,
          appBar: SimpleComponents.menuAppBar(key: _key),
          drawer: SimpleComponents().getDrawer(key: _key),
          backgroundColor: KColors.primary,
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width *
                  KValues.horizontalWidthScreenMultiplier,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: _categoryButton(
                        category: CategoryEnum.dailys,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.025,
                    ),
                    Expanded(
                      child: _categoryButton(
                        category: CategoryEnum.saves,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.025,
                    ),
                    Expanded(
                      child: _categoryButton(
                        category: CategoryEnum.achievemnts,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .025),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: _categoryButton(
                        category: CategoryEnum.personals,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.025,
                    ),
                    Expanded(
                      child: _categoryButton(
                        category: null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .025),
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(3),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(2),
                  },
                  children: const [
                    TableRow(
                      children: [
                        Text(
                          KStrings.historyTableHeaderCicle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: KColors.white,
                            fontSize: KValues.fontSizeMedium,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          KStrings.historyTableHeaderConcept,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: KColors.white,
                            fontSize: KValues.fontSizeMedium,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          KStrings.historyTableHeaderAmount,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: KColors.white,
                            fontSize: KValues.fontSizeMedium,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          KStrings.historyTableHeaderDate,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: KColors.white,
                            fontSize: KValues.fontSizeMedium,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .0125),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: KColors.primaryT1,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: KColors.primaryT1,
                          blurRadius: 15,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Futuristic(
                      forceUpdate: _con.forceUpdate,
                      autoStart: true,
                      futureBuilder: _con.getExpenseHistory,
                      busyBuilder: (context) => loadingComponent(true),
                      errorBuilder: (p0, p1, p2) => _placeholder(),
                      dataBuilder: (p0, p1) => _dataBuilder(),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .025),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryButton({required CategoryEnum? category}) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        _con.onCategoryTap(category);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: MediaQuery.of(context).size.width * .15,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: category?.categoryColor() ?? KColors.red,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: (_con.selectedCateogries[category] ??
                    _con.allCategoriesSelected)
                ? KColors.white
                : Colors.transparent,
          ),
          boxShadow:
              _con.selectedCateogries[category] ?? _con.allCategoriesSelected
                  ? [
                      BoxShadow(
                        color: KColors.white.withOpacity(0.1),
                        blurRadius: 2,
                        spreadRadius: 5,
                      ),
                    ]
                  : null,
        ),
        child: Text(
          category?.categoryName() ?? KStrings.all,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: KColors.white,
            fontSize: KValues.fontSizeMedium,
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Center(
      child: Text(
        KStrings.errorFailedToGetExpensesHistory,
        style: KStyles.errorViewPlaceholderTextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _dataBuilder() {
    if (_con.expenseList.isEmpty) {
      return Center(
        child: Text(
          KStrings.errorFailedEmptyExpensesHistory,
          style: KStyles.errorViewPlaceholderTextStyle,
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.0125),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(3),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(2),
            },
            children: _buildTableRows(),
          ),
        ),
      );
    }
  }

  List<TableRow> _buildTableRows() {
    List<TableRow> result = [];
    for (ExpenseModel element in _con.expenseList) {
      result.add(
        TableRow(
          children: [
            Text(
              "${element.cicleId ?? "-"}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: KColors.white,
                fontSize: KValues.fontSizeSmallXL,
              ),
            ),
            Text(
              element.conceptModel.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: element.category.categoryColorBright(),
                fontSize: KValues.fontSizeSmallXL,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "${element.category != CategoryEnum.saves ? "-" : "+"}\$ ${currencyFormat(element.amount)}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: element.category != CategoryEnum.saves
                    ? KColors.white
                    : KColors.greenL1,
                fontSize: KValues.fontSizeSmallXL,
              ),
            ),
            Text(
              element.createdAt != null
                  ? DateFormat("dd/MM/yy").format(element.createdAt!)
                  : "-",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: KColors.white,
                fontSize: KValues.fontSizeSmallXL,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
      result.add(
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Divider(),
            ),
          ],
        ),
      );
    }
    return result;
  }
}
