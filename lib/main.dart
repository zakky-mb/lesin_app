import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_core/firebase_core.dart'; // Nanti di-uncomment kalau Firebase udah disetup di console
import 'features/auth/splash_page.dart';

// KUNCI SAKTI: Untuk pindah halaman otomatis saat ada notifikasi masuk
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: INISIALISASI FIREBASE (Uncomment kalau sudah daftar Firebase)
  // await Firebase.initializeApp();

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
      // Pasang Kunci Sakti di sini
      navigatorKey: navigatorKey,

      debugShowCheckedModeBanner: false,
      title: 'LesIn',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF5E62)),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}
