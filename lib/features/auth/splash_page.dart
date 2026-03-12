import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/storage_service.dart';
import 'welcome_page.dart';
import '../home/home_page.dart'; // Murid
import '../tutor/tutor_dashboard_page.dart'; // Guru

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkRouting();
  }

  void _checkRouting() async {
    await Future.delayed(
        const Duration(seconds: 2)); // Tahan 2 detik biar logo terlihat

    final storage = ref.read(storageServiceProvider);
    final token = await storage.getToken();
    final role = await storage.getRole();

    if (mounted) {
      if (token != null && token.isNotEmpty) {
        // SUDAH LOGIN -> Cek Role
        if (role == 'tutor') {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const TutorDashboardPage()));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        }
      } else {
        // BELUM LOGIN -> Lempar ke Halaman Welcome
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const WelcomePage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF9966), Color(0xFFFF5E62)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 100, color: Colors.white),
            SizedBox(height: 24),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
