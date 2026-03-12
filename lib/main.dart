import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import halaman Welcome yang baru kita buat
import 'features/auth/welcome_page.dart';

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
        // Ubah tema jadi Pink Salmon (sesuai desain baru)
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF5E62)),
        useMaterial3: true,
      ),
      // Pintu masuk diarahkan ke WelcomePage (Login/Register Flow)
      home: const WelcomePage(),
    );
  }
}
