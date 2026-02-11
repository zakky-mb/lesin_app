import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Wajib import ini
import '../home/home_page.dart';
import 'auth_controller.dart'; // Import controller yang baru dibuat

// 1. Ganti StatelessWidget jadi ConsumerWidget
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  // 2. Tambahkan parameter 'WidgetRef ref' (Ini remote control Riverpod)
  Widget build(BuildContext context, WidgetRef ref) {
    // 3. Pantau Status Login (Loading/Error/Sukses)
    final authState = ref.watch(authControllerProvider);

    // 4. LISTEN (Dengar): Kalau ada Error atau Sukses, lakukan sesuatu
    ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
      // Jika Error, munculkan SnackBar merah
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
      // Jika Sukses, pindah ke Home
      if (next is AsyncData && !next.isLoading && previous is! AsyncData) {
        // Cek biar gak double nav
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    });

    // Kita butuh controller text untuk mengambil input user
    // (Cara cepat tanpa bikin stateful widget, kita taruh di build sementara ini)
    final emailController = TextEditingController(text: "siswa@lesin.com");
    final passwordController = TextEditingController(text: "123456");

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.school, size: 80, color: Colors.blue),
              const SizedBox(height: 16),
              const Text(
                "Selamat Datang di LesIn 👋",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              const SizedBox(height: 32),

              // INPUT EMAIL
              TextFormField(
                controller: emailController, // Pasang controller
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),

              // INPUT PASSWORD
              TextFormField(
                controller: passwordController, // Pasang controller
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),

              // TOMBOL LOGIN (PINTAR)
              ElevatedButton(
                onPressed: authState.isLoading
                    ? null // Matikan tombol kalau lagi loading
                    : () {
                        // Panggil fungsi login di Controller
                        ref.read(authControllerProvider.notifier).login(
                              emailController.text,
                              passwordController.text,
                            );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                // Kalau loading tampilkan putaran, kalau tidak tampilkan teks
                child: authState.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : const Text("Masuk Sekarang",
                        style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
