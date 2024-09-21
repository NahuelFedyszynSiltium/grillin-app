import 'dart:developer';

import 'package:flutter/material.dart';
import '../../../values/k_colors.dart';
import '../../../values/k_strings.dart';
import '../../../values/k_values.dart';
import '../../managers/page_manager.dart';

class SimpleComponents {
  static AppBar menuAppBar({required BuildContext context}) => AppBar(
        backgroundColor: KColors.primary,
        automaticallyImplyLeading: false,
        leading: Builder(builder: (context) {
          return GestureDetector(
            onTap: () {
              try {
                Scaffold.of(context).openDrawer();
              } catch (err) {
                log(err.toString());
              }
            },
            child: const SizedBox(
              height: 50,
              width: 50,
              child: Icon(
                Icons.menu,
                color: KColors.white,
              ),
            ),
          );
        }),
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

  Drawer getDrawer({required BuildContext context}) => Drawer(
        shape: const BeveledRectangleBorder(),
        backgroundColor: KColors.primary,
        child: Builder(builder: (context) {
          return ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              SizedBox(
                  height:
                      MediaQuery.of(PageManager().currentContext).size.height *
                          .05),
              _drawerItem(
                icon: Icons.dashboard,
                label: KStrings.drawerBoard,
                onTap: () {
                  try {
                    Scaffold.of(context).closeDrawer();
                  } catch (err) {
                    log(err.toString());
                  }
                  PageManager().goHomePage();
                },
              ),
              _drawerItem(
                icon: Icons.monetization_on,
                label: KStrings.drawerStartEndCicle,
                onTap: () {
                  try {
                    Scaffold.of(context).closeDrawer();
                  } catch (err) {
                    log(err.toString());
                  }
                  PageManager().goSetIncomePage();
                },
              ),
              _drawerItem(
                icon: Icons.history,
                label: KStrings.drawerHistory,
                onTap: () {
                  try {
                    Scaffold.of(context).closeDrawer();
                  } catch (err) {
                    log(err.toString());
                  }
                  PageManager().goHistoryPage();
                },
              ),
              _drawerItem(
                icon: Icons.savings,
                label: KStrings.drawerSaves,
                onTap: () {
                  try {
                    Scaffold.of(context).closeDrawer();
                  } catch (err) {
                    log(err.toString());
                  }
                  PageManager().goTransferSavesPage();
                },
              ),
              _drawerItem(
                icon: Icons.percent,
                label: KStrings.drawerPercents,
                onTap: () {
                  try {
                    Scaffold.of(context).closeDrawer();
                  } catch (err) {
                    log(err.toString());
                  }
                  PageManager().goChangePercentsPage();
                },
              ),
              _drawerItem(
                icon: Icons.bar_chart,
                label: KStrings.drawerGraphs,
                onTap: () {
                  try {
                    Scaffold.of(context).closeDrawer();
                  } catch (err) {
                    log(err.toString());
                  }
                  PageManager().goGraphsPage();
                },
              ),
              _drawerItem(
                icon: Icons.list,
                label: KStrings.drawerConcepts,
                onTap: () {
                  try {
                    Scaffold.of(context).closeDrawer();
                  } catch (err) {
                    log(err.toString());
                  }
                },
              ),
            ],
          );
        }),
      );

  Widget _drawerItem({
    required String label,
    required IconData icon,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Row(
            children: [
              Icon(
                icon,
                color: KColors.white,
                size: KValues.fontSizeLargeXL,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(PageManager().currentContext)
                              .size
                              .height *
                          .02),
                  child: Text(
                    label,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        color: KColors.white, fontSize: KValues.fontSizeLarge),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
