import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/splash_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: LesInApp(),
    ),
  );
}

class LesInApp extends StatelessWidget {
  const LesInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LesIn',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF5E62)),
        useMaterial3: true,
      ),
      // MULAILAH DARI SPLASH SCREEN
      home: const SplashPage(),
    );
  }
}
