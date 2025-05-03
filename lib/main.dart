import 'package:flutter/material.dart';
import 'screens/inicio_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const SalaMagicaApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class SalaMagicaApp extends StatelessWidget {
  const SalaMagicaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Sala Mágica',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.isDarkMode ? _darkTheme : _lightTheme,
      home: const InicioScreen(),
    );
  }

  static final ThemeData _lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    useMaterial3: true,
    brightness: Brightness.light,
  );

  static final ThemeData _darkTheme = ThemeData(
    primarySwatch: Colors.blueGrey,
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.grey[900],
    cardTheme: CardTheme(
      color: Colors.grey[800],
    ),
  );
}

/*
------------------------------------------

INSTALAR DEPENDENCIA EM "PUBSPEC.YAML"

dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5
  
------------------------------------------

INSTALAR CÓDIGO NO "WIDGET_TEST.DART"

  await tester.pumpWidget(const SalaMagicaApp());

------------------------------------------
*/