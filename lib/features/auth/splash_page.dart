import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_controller.dart';
import 'login_page.dart';
import '../home/home_page.dart';

// Pakai ConsumerStatefulWidget karena kita butuh 'initState' (Dijalankan saat halaman baru dibuka)
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Langsung jalankan pengecekan saat halaman dibuka
    _checkAuth();
  }

  void _checkAuth() async {
    // 1. Simulasi delay sebentar biar Logo-nya sempat kelihatan (Aesthetic ✨)
    await Future.delayed(const Duration(seconds: 2));

    // 2. Minta Controller cek brankas
    // Kita pakai 'read' karena cuma butuh panggil fungsi sekali, gak butuh dipantau terus
    final isUserLoggedIn =
        await ref.read(authControllerProvider.notifier).checkLoginStatus();

    // 3. Tentukan Arah Navigasi
    if (mounted) {
      // Cek apakah halaman masih ada (biar gak error)
      if (isUserLoggedIn) {
        // Kalau Login -> Ke Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // Kalau Belum -> Ke Login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Aplikasi
            Icon(Icons.school, size: 100, color: Colors.blue),
            SizedBox(height: 24),
            // Loading Muter
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
