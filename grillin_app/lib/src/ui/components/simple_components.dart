import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../values/k_colors.dart';
import '../../managers/page_manager.dart';

class SimpleComponents {
  static AppBar menuAppBar = AppBar(
    backgroundColor: KColors.primary,
    automaticallyImplyLeading: false,
    leading: GestureDetector(
      onTap: () {
        log("ON MENU TAP");
      },
      child: const SizedBox(
        height: 50,
        width: 50,
        child: Icon(
          Icons.menu,
          color: KColors.white,
        ),
      ),
    ),
  );

  static AppBar backAppBar({Function()? onBack}) => AppBar(
        backgroundColor: KColors.primary,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: onBack ?? PageManager().goBack,
          child: const SizedBox(
            height: 50,
            width: 50,
            child: Icon(
              Icons.menu,
              color: KColors.white,
            ),
          ),
        ),
      );
}
