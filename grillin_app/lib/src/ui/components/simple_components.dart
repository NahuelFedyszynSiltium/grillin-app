import 'package:flutter/material.dart';
import '../../../values/k_colors.dart';
import '../../../values/k_strings.dart';
import '../../../values/k_values.dart';
import '../../managers/page_manager.dart';

class SimpleComponents {
  static AppBar menuAppBar({required final GlobalKey<ScaffoldState> key}) =>
      AppBar(
        backgroundColor: KColors.primary,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: key.currentState?.openDrawer,
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

  Drawer getDrawer({required final GlobalKey<ScaffoldState> key}) => Drawer(
        shape: const BeveledRectangleBorder(),
        backgroundColor: KColors.primary,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            SizedBox(
                height:
                    MediaQuery.of(PageManager().currentContext).size.height *
                        .05),
            _drawerItem(
              icon: Icons.dashboard,
              label: KStrings.board,
              onTap: () {
                key.currentState?.closeDrawer();
                PageManager().goHomePage();
              },
            ),
            _drawerItem(
              icon: Icons.transfer_within_a_station_sharp,
              label: KStrings.transferSavings,
              onTap: () {
                key.currentState?.closeDrawer();
                PageManager().goTransferSavesPage();
              },
            ),
            _drawerItem(
              icon: Icons.percent,
              label: KStrings.changePercents,
              onTap: () {
                key.currentState?.closeDrawer();
                PageManager().goChangePercentsPage();
              },
            ),
          ],
        ),
      );

  Widget _drawerItem(
      {required String label,
      required IconData icon,
      required Function() onTap}) {
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
