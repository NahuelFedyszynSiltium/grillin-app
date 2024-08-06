// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';

// Project imports:
import '../enums/page_names.dart';
import '../ui/pages/change_percents_page.dart';
import '../ui/pages/home_page.dart';
import '../ui/pages/set_income_page.dart';
import '../ui/pages/transfer_saves_page.dart';
import '../utils/page_args.dart';

class PageManager {
  static final PageManager _instance = PageManager._constructor();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  PageNames? currentPage;
  List<String> stackPages = [];

  BuildContext get currentContext => navigatorKey.currentContext!;

  factory PageManager() {
    return _instance;
  }

  PageNames? getPageNameEnum(String? pageName) {
    try {
      return PageNames.values.where((x) => x.toString() == pageName).single;
    } catch (e) {
      throw Exception(e);
    }
  }

  PageManager._constructor();

  MaterialPageRoute? getRoute(RouteSettings settings) {
    PageArgs? arguments;

    if (settings.arguments != null) {
      arguments = settings.arguments as PageArgs;
    }

    PageNames? page = getPageNameEnum(settings.name);

    currentPage = page;
    switch (page) {
      case PageNames.changePercents:
        return MaterialPageRoute(
            builder: (context) => ChangePercentsPage(arguments));
      case PageNames.home:
        return MaterialPageRoute(builder: (context) => HomePage(arguments));
      case PageNames.setIncome:
        return MaterialPageRoute(
            builder: (context) => SetIncomePage(arguments));
      case PageNames.transferSaves:
        return MaterialPageRoute(
            builder: (context) => TransferSavesPage(arguments));
      default:
        return throw Exception("No existe página con este PageName");
    }
  }

  _goPage(String pageName,
      {PageArgs? args,
      Function(PageArgs? args)? actionBack,
      bool makeRootPage = false}) {
    if (stackPages.isEmpty || pageName.toString() != stackPages.last) {
      if (!makeRootPage) {
        stackPages.add(pageName);
        return navigatorKey.currentState!
            .pushNamed(pageName, arguments: args)
            .then((value) {
          if (actionBack != null) {
            actionBack(value != null ? (value as PageArgs) : null);
          }
        });
      } else {
        navigatorKey.currentState!.pushNamedAndRemoveUntil(
            pageName, (route) => false,
            arguments: args);
        stackPages.clear();
        stackPages.add(pageName);
      }
    }
  }

  void goBack({PageArgs? args, PageNames? specificPage}) {
    if (specificPage != null) {
      navigatorKey.currentState!
          .popAndPushNamed(specificPage.toString(), arguments: args);
      stackPages.removeLast();
      stackPages.add(specificPage.toString());
    } else {
      Navigator.pop(navigatorKey.currentState!.overlay!.context, args);
      stackPages.removeLast();
    }
    if (stackPages.isEmpty) {
      try {
        Navigator.of(currentContext).maybePop();
        // ignore: empty_catches
      } catch (er) {}
      FlutterExitApp.exitApp();
    }
  }

  ///Quita paginas de la pila de navegacion hasta llegar a la vista especificada. Lanza una excepcion si esta vista no se encuentra en la pila de navegacion actual.
  ///[specificPage] indica la vista a la que se quiere volver.
  ///Adicionalmente, [thenGo] da la posibilidad de navegar a una nueva vista luego de hacer el goBack.
  void goBackToSpecificPage({
    required PageNames specificPage,
    PageArgs? args,
    PageNames? thenGo,
    Function(PageArgs?)? actionBack,
  }) {
    if (!stackPages
        .map((e) => e.toLowerCase())
        .contains(specificPage.toString().toLowerCase())) {
      throw Exception(
          "La vista especificada no existe en la pila de navegación actual");
    }
    Navigator.popUntil(
      navigatorKey.currentContext!,
      (route) {
        if (stackPages.last == specificPage.toString() ||
            stackPages.length == 1) {
          return true;
        } else {
          stackPages.removeLast();
          return false;
        }
      },
    );
    if (thenGo != null) {
      _goPage(
        thenGo.toString(),
        args: args,
        actionBack: actionBack,
      );
    }
  }

  goChangePercentsPage({PageArgs? args, Function(PageArgs? args)? actionBack}) {
    _goPage(PageNames.changePercents.toString(),
        args: args, actionBack: actionBack, makeRootPage: true);
  }

  goHomePage({PageArgs? args, Function(PageArgs? args)? actionBack}) {
    _goPage(PageNames.home.toString(),
        args: args, actionBack: actionBack, makeRootPage: true);
  }

  goTransferSavesPage({PageArgs? args, Function(PageArgs? args)? actionBack}) {
    _goPage(PageNames.transferSaves.toString(),
        args: args, actionBack: actionBack, makeRootPage: true);
  }

  goSetIncomePage({PageArgs? args, Function(PageArgs? args)? actionBack}) {
    _goPage(PageNames.setIncome.toString(),
        args: args, actionBack: actionBack, makeRootPage: true);
  }
}
