import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'screens/perfil_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const SalaMagicaApp(),
    ),
  );
}

class SalaMagicaApp extends StatelessWidget {
  const SalaMagicaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: const PerfilScreen(), // Ou sua tela inicial
    );
  }
}