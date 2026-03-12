import 'package:flutter/material.dart';
import 'login_page.dart';
import 'role_selection_page.dart';
import 'google_auth_service.dart'; // Import Service Google

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Background Gradient Dekorasi
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 400,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF9966), Color(0xFFFF5E62)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(100)),
              ),
            ),
          ),

          // 2. Konten Utama
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // Logo / Icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 10)
                      ],
                    ),
                    child: const Icon(Icons.school,
                        size: 50, color: Color(0xFFFF5E62)),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Cari Guru Les\nJadi Lebih Mudah",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Belajar privat dengan guru terbaik di sekitarmu.",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),

                  const Spacer(), // Mendorong tombol ke bawah

                  // --- TOMBOL GOOGLE (LOGIKA UTAMA) ---
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        // 1. Panggil Service Google
                        final googleService = GoogleAuthService();
                        final user = await googleService.signInWithGoogle();

                        // 2. Cek Hasil Login
                        if (user != null) {
                          // Cek apakah widget masih aktif sebelum navigasi
                          if (context.mounted) {
                            // BERHASIL -> Pindah ke Pilih Role
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RoleSelectionPage()),
                            );
                          }
                        } else {
                          // GAGAL / BATAL
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Login Google Gagal / Dibatalkan"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: const Icon(Icons.g_mobiledata,
                          size: 32, color: Colors.blue),
                      label: const Text("Masuk dengan Google",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- LINK EMAIL ---
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Masuk ke Login Email Manual
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text(
                        "Atau masuk dengan Email",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
