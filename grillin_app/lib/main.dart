// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

// Project imports:
import '/src/ui/pages/init_page.dart';
import 'src/managers/page_manager.dart';
import 'src/providers/app_provider.dart';
import 'values/k_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: KColors.primary,
  ));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) async {
    MyHomePageState? state = context.findAncestorStateOfType<MyHomePageState>();
    state!.changeLanguage(newLocale);
  }

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyApp> {
  late Locale _locale = const Locale("es", '');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', ''),
        Locale('en', ''),
      ],
      navigatorKey: PageManager().navigatorKey,
      locale: _locale,
      onGenerateRoute: (settings) {
        return PageManager().getRoute(settings);
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scrollbarTheme: ScrollbarThemeData(
          trackColor: WidgetStateProperty.all(Colors.grey),
          thumbColor: WidgetStateProperty.all(Colors.grey),
          trackBorderColor: WidgetStateProperty.all(Colors.grey),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      title: 'Grillin App',
      home: _initPage(),
    );
  }

  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  _initPage() {
    return const InitPage(null);
  }
}
