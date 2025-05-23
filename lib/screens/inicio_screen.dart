// main.dart
import 'package:flutter/material.dart';
import '../routes.dart';

void main() {
  runApp(const InicioScreen());
}

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sala Mágica',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}