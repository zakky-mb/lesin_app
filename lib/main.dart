import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. IMPORT INI
import 'features/auth/login_page.dart';
import 'features/auth/splash_page.dart';

void main() {
  // 2. BUNGKUS APLIKASI DENGAN ProviderScope
  // Ini wajib hukumnya kalau pakai Riverpod!
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}
