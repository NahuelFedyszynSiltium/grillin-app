import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../../values/k_colors.dart';
import '../../../values/k_icons.dart';
import '../../../values/k_strings.dart';
import '../../../values/k_styles.dart';
import '../../../values/k_values.dart';
import '../../utils/page_args.dart';
import '../components/button_component.dart';
import '../components/simple_components.dart';
import '../page_controllers/set_income_page_controller.dart';

class SetIncomePage extends StatefulWidget {
  final PageArgs? args;
  const SetIncomePage(this.args, {super.key});

  @override
  SetIncomePageState createState() => SetIncomePageState();
}

class SetIncomePageState extends StateMVC<SetIncomePage> {
  late SetIncomePageController _con;
  PageArgs? args;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  SetIncomePageState() : super(SetIncomePageController()) {
    _con = SetIncomePageController.con;
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
          body: Stack(
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
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .05,
                            ),
                            Text(
                              KStrings.setFixedIncomePageHint,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: KColors.white,
                                fontSize: KValues.fontSizeMedium,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .05,
                            ),
                            Text(
                              KStrings.setFixedIncome,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: KColors.white,
                                fontSize: KValues.fontSizeLarge,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .05,
                            ),
                            _amountInput(),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .05,
                            ),
                          ],
                        ),
                      ),
                    ),
                    ButtonComponent(
                      label: KStrings.setFixedIncomeButtonString,
                      color: KColors.primaryL1,
                      onAccept: _con.onAccept,
                      isEnabled: _con.isEnabled,
                    ),
                    SizedBox(
                      height: (MediaQuery.of(context).size.height * .05) +
                          MediaQuery.of(context).viewInsets.bottom,
                    ),
                  ],
                ),
              ),
            ],
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
}
