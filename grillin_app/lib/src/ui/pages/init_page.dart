// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, no_logic_in_create_state

import 'dart:math' as math;

import 'package:flutter/material.dart';

// Package imports:
import 'package:mvc_pattern/mvc_pattern.dart';

// Project imports:
import '../../../values/k_colors.dart';
import '../../../values/k_icons.dart';
import '../../utils/page_args.dart';
import '../page_controllers/init_page_controller.dart';

class InitPage extends StatefulWidget {
  final PageArgs? args;
  const InitPage(this.args, {Key? key}) : super(key: key);
  @override
  _InitPageState createState() => _InitPageState(args);
}

class _InitPageState extends StateMVC<InitPage> {
  late InitPageController _con;
  PageArgs? args;
  _InitPageState(PageArgs? arguments) : super(InitPageController(arguments)) {
    _con = InitPageController.con;
    args = arguments;
  }
  @override
  void initState() {
    _con.initPage(arguments: args);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _con.initApp(),
      builder: (context, snapshot) => _splash(),
    );
  }

  Widget _splash() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: KColors.primary,
      ),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              KIcons.splash,
              fit: BoxFit.cover,
              color: KColors.primaryL1.withOpacity(0.7),
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  KColors.white.withOpacity(0.1),
                  Colors.transparent,
                  KColors.white.withOpacity(0.1),
                ],
                transform: const GradientRotation(math.pi * .25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
