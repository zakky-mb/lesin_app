import 'package:flutter/material.dart';
import 'features/auth/login_page.dart'; // Import halaman login

void main() {
  runApp(const LesInApp());
}

class LesInApp extends StatelessWidget {
  const LesInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hilangkan pita debug merah
      title: 'LesIn',
      theme: ThemeData(
        // Mengatur warna utama aplikasi jadi Biru
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginPage(), // Arahkan ke halaman login
    );
  }
}
