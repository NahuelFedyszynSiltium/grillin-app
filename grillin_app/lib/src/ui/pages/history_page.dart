import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../utils/page_args.dart';
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
          body: Container(),
        ),
      ),
    );
  }
}

 