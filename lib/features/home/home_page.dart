import 'package:flutter/material.dart';
import '../auth/login_page.dart'; // Import halaman login buat tombol logout

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LesIn Home"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // Tombol Logout di pojok kanan atas
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Logika Logout: Kembali ke halaman Login
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified_user, size: 80, color: Colors.green),
            SizedBox(height: 16),
            Text(
              "Login Berhasil!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text("Selamat datang di Dashboard LesIn"),
          ],
        ),
      ),
    );
  }
}
