import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../values/k_colors.dart';
import '../../../values/k_strings.dart';
import '../../../values/k_styles.dart';
import '../../../values/k_values.dart';
import '../../enums/category_enum.dart';
import '../../managers/data_manager.dart';
import '../../models/concept_model.dart';
import '../../models/expense_model.dart';
import '../../support/futuristic.dart';
import '../../utils/functions_utils.dart';
import '../components/button_component.dart';
import 'loading_popup.dart';

class AddExpensePopup extends StatefulWidget {
  const AddExpensePopup({
    super.key,
    required this.category,
  });

  @override
  State<StatefulWidget> createState() => AddExpensePopupState();

  final CategoryEnum category;
}

class AddExpensePopupState extends State<AddExpensePopup>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fadeAnimation;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _conceptController = TextEditingController();

  bool _addNewConceptSwitchValue = true;

  ConceptModel? _selectedConcept;

  List<ConceptModel> _conceptList = [];

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    fadeAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                margin:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                decoration: BoxDecoration(
                  color: widget.category.categoryColor(),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [KStyles().overlayShadow],
                ),
              ),
              Container(
                height: double.infinity,
                width: double.infinity,
                margin:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                decoration: BoxDecoration(
                  color: KColors.black.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              Container(
                height: double.infinity,
                width: double.infinity,
                margin:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      KColors.white.withOpacity(0.1),
                      Colors.transparent,
                      KColors.white.withOpacity(0.1),
                    ],
                    transform: const GradientRotation(pi * 0.25),
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .1,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .025,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.category.categoryName(),
                          textAlign: TextAlign.center,
                          style: KStyles.homeCardBodyTextStyle,
                        ),
                      ),
                      Visibility(
                        visible: widget.category == CategoryEnum.saves,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .01,
                          ),
                          child: const Text(
                            "${KStrings.savesExpenseHint}:",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: KValues.fontSizeSmall,
                              color: KColors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .025,
                      ),
                      const Text(
                        "${KStrings.importValue}:",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: KValues.fontSizeLarge,
                          color: KColors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .01,
                      ),
                      _amountInput(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .025,
                      ),
                      const Text(
                        "${KStrings.concept}:",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: KValues.fontSizeLarge,
                          color: KColors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .01,
                      ),
                      Expanded(
                        child: _conceptBody(),
                      ),
                      _button(),
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .025,
                      ),
                    ],
                  ),
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
      controller: _amountController,
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
      textInputAction: TextInputAction.next,
      autocorrect: false,
      autofocus: true,
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

  Widget _conceptBody() {
    return Futuristic(
      futureBuilder: _getConcepts,
      autoStart: true,
      busyBuilder: (context) {
        return Center(
          child: CircularProgressIndicator(
            color: widget.category.categoryColorBright(),
          ),
        );
      },
      dataBuilder: (context, snapshot) {
        if (_conceptList.isNotEmpty) {
          _addNewConceptSwitchValue = false;
        }
        return Column(
          children: [
            Visibility(
              visible: _conceptList.isNotEmpty,
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      KStrings.addNewConcept,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: KValues.fontSizeMedium,
                        color: KColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: KValues.fontSizeMedium,
                    child: Switch(
                      value: _addNewConceptSwitchValue,
                      onChanged: _onSwitchChange,
                      activeTrackColor: widget.category.categoryColor(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .01,
            ),
            _conceptInput(),
            SizedBox(
              height: MediaQuery.of(context).size.height * .025,
            ),
            Visibility(
              visible: _conceptList.isNotEmpty,
              child: Expanded(child: _conceptsList()),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .025,
            ),
          ],
        );
      },
      errorBuilder: (context, snapshot, err) {
        _addNewConceptSwitchValue = true;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _conceptInput(),
            SizedBox(
              height: MediaQuery.of(context).size.height * .025,
            ),
          ],
        );
      },
    );
  }

  Widget _conceptInput() {
    return Visibility(
      visible: _addNewConceptSwitchValue,
      child: TextField(
        controller: _conceptController,
        onChanged: (value) {
          setState(() {});
        },
        textCapitalization: TextCapitalization.sentences,
        autocorrect: true,
        cursorColor: KColors.white,
        style: KStyles.homeCardBodyTextStyle,
        maxLines: 1,
        textAlignVertical: TextAlignVertical.center,
        enabled: _addNewConceptSwitchValue,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: KColors.white,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: KColors.white,
            ),
          ),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: KColors.white,
            ),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: KColors.white.withOpacity(0.5),
            ),
          ),
          prefixIcon: Icon(
            Icons.edit,
            color:
                KColors.white.withOpacity(_addNewConceptSwitchValue ? 1 : .5),
            size: KValues.fontSizeLargeXXL,
          ),
        ),
      ),
    );
  }

  Widget _conceptsList() {
    return Visibility(
      visible: !_addNewConceptSwitchValue,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.category.categoryColor(),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: _buildWraps(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _button() {
    return ButtonComponent(
      isEnabled: _isEnabled,
      onAccept: _onAccept,
      color: widget.category.categoryColorBright(),
    );
  }

  List<Widget> _buildWraps() {
    List<Widget> result = [];
    if (_conceptList.isNotEmpty) {
      for (ConceptModel element in _conceptList) {
        if (element.id != null && element.name.isNotEmpty) {
          result.add(_chip(concept: element));
        }
      }
    }
    return result;
  }

  Widget _chip({required ConceptModel concept}) {
    return GestureDetector(
      onTap: () {
        _onConceptTap(concept);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: concept.id == _selectedConcept?.id
              ? widget.category.categoryColor()
              : Colors.transparent,
          border: Border.all(
            color: widget.category.categoryColorBright(),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          child: Text(
            concept.name,
            style: const TextStyle(
              color: KColors.white,
              fontSize: KValues.fontSizeMedium,
            ),
          ),
        ),
      ),
    );
  }

  void _onSwitchChange(bool value) {
    setState(() {
      _addNewConceptSwitchValue = !_addNewConceptSwitchValue;
    });
  }

  Future<void> _onAccept() async {
    LoadingPopup(
      context: context,
      onLoading: _onAcceptLoading(),
      onResult: (data) {
        _onAcceptSuccess(data);
      },
      onError: (err) {
        _onAcceptFailure(err);
      },
    ).show();
  }

  Future<void> _onAcceptLoading() async {
    late ExpenseModel newExpense;
    if (_addNewConceptSwitchValue) {
      ConceptModel newConcept = ConceptModel(
        name: _conceptController.text,
        category: widget.category,
      );
      newExpense = ExpenseModel(
        conceptModel: newConcept,
        amount: double.parse(_amountController.text.trim()),
        category: widget.category,
      );
    } else {
      newExpense = ExpenseModel(
        conceptModel: _selectedConcept!,
        amount: double.parse(_amountController.text.trim()),
        category: widget.category,
      );
    }

    return await DataManager().postAddNewExpense(expenseModel: newExpense);
  }

  void _onAcceptSuccess(data) {
    Navigator.pop(context, true);
  }

  void _onAcceptFailure(err) {
    showToast(
      message: KStrings.addExpenseFailure,
    );
  }

  void _onConceptTap(ConceptModel concept) {
    setState(() {
      _selectedConcept = concept;
    });
  }

  bool get _isEnabled {
    if (_addNewConceptSwitchValue) {
      return _conceptController.text.trim().isNotEmpty &&
          _amountController.text.isNotEmpty &&
          double.tryParse(_amountController.text) != null;
    } else {
      return _selectedConcept != null &&
          _amountController.text.isNotEmpty &&
          double.tryParse(_amountController.text) != null;
    }
  }

  Future<void> _getConcepts() async {
    _conceptList =
        await DataManager().getCategoryConcepts(category: widget.category);

    _conceptList.removeWhere((element) =>
        element.id == null || element.name.toString().trim().isEmpty);
  }
}
