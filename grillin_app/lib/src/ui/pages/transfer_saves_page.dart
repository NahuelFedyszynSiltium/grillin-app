import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../../values/k_colors.dart';
import '../../../values/k_icons.dart';
import '../../../values/k_strings.dart';
import '../../../values/k_styles.dart';
import '../../../values/k_values.dart';
import '../../enums/category_enum.dart';
import '../../utils/page_args.dart';
import '../components/button_component.dart';
import '../components/simple_components.dart';
import '../page_controllers/transfer_saves_page_controller.dart';

class TransferSavesPage extends StatefulWidget {
  final PageArgs? args;
  const TransferSavesPage(this.args, {super.key});

  @override
  TransferSavesPageState createState() => TransferSavesPageState();
}

class TransferSavesPageState extends StateMVC<TransferSavesPage> {
  late TransferSavesPageController _con;
  PageArgs? args;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  TransferSavesPageState() : super(TransferSavesPageController()) {
    _con = TransferSavesPageController.con;
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
          drawer: SimpleComponents().getDrawer(key: _key),
          appBar: SimpleComponents.menuAppBar(key: _key),
          backgroundColor: KColors.primary,
          resizeToAvoidBottomInset: false,
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Transform.translate(
                  offset: Offset(0, -MediaQuery.of(context).size.height * .1),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * .1),
                    child: Image.asset(
                      KIcons.cricketHead,
                      scale: 2,
                      fit: BoxFit.cover,
                      color: KColors.black.withOpacity(0.1),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width *
                        KValues.horizontalWidthScreenMultiplier,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      .025),
                              Text(
                                KStrings.totalSaves,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: KColors.white,
                                  fontSize: KValues.fontSizeLargeXL,
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      .025),
                              Text(
                                "\$ ${_con.getTotalSaves}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: KColors.white,
                                  fontSize: KValues.fontSizeLargeXXL,
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      .025),
                              Text(
                                "${KStrings.trasnferTo}:",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: KColors.white,
                                  fontSize: KValues.fontSizeLargeXL,
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      .025),
                              _categoryButton(category: CategoryEnum.dailys),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              _categoryButton(category: CategoryEnum.personals),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              _categoryButton(
                                  category: CategoryEnum.achievemnts),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .05),
                              const Text(
                                "${KStrings.importValue}:",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: KColors.white,
                                  fontSize: KValues.fontSizeLargeXL,
                                ),
                              ),
                              _amountInput(),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .025),
                      ButtonComponent(
                        onAccept: _con.onAccept,
                        color: CategoryEnum.saves.categoryColorBright(),
                        isEnabled: _con.isEnabled,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .025),
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _amountInput() {
    return TextField(
      controller: _con.amountController,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
        TextInputFormatter.withFunction((oldValue, newValue) {
          final text = newValue.text;
          return text.isEmpty
              ? newValue
              : double.tryParse(text) == null
                  ? oldValue
                  : newValue;
        }),
      ],
      onChanged: (value) {
        setState(() {});
      },
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      autocorrect: false,
      autofocus: false,
      cursorColor: KColors.white,
      style: KStyles.homeCardBodyTextStyle,
      maxLines: 1,
      textAlignVertical: TextAlignVertical.center,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.zero,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: KColors.white,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: KColors.white,
          ),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: KColors.white,
          ),
        ),
        prefixIcon: Icon(
          Icons.attach_money_sharp,
          color: KColors.white,
          size: KValues.fontSizeLargeXXL,
        ),
      ),
    );
  }

  Widget _categoryButton({required CategoryEnum category}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () {
          _con.onCategoryTap(category);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height *
                  (_con.selectedCategory == category ? 0.025 : 0.015)),
          decoration: BoxDecoration(
              color: category.categoryColor(),
              borderRadius: BorderRadius.circular(10),
              boxShadow: _con.selectedCategory == category
                  ? [
                      BoxShadow(
                        color: KColors.white.withOpacity(0.25),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ]
                  : null),
          child: Text(
            category.categoryName(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: KColors.white,
              fontSize: KValues.fontSizeLarge,
            ),
          ),
        ),
      ),
    );
  }
}
