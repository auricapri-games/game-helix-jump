import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'ds/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const GameHelixJumpApp());
}

class GameHelixJumpApp extends StatelessWidget {
  const GameHelixJumpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Helix Jump',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      locale: const Locale('pt'),
      supportedLocales: const [
        Locale('pt'),
        Locale('en'),
        Locale('es'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(),
    );
  }
}
