import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tutor_status_controller.dart';
import '../auth/auth_controller.dart';
import '../auth/welcome_page.dart';
import 'incoming_order_page.dart'; // Import halaman order masuk

class TutorDashboardPage extends ConsumerWidget {
  const TutorDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pantau status Online/Offline
    final isOnline = ref.watch(tutorStatusProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Beranda Mitra Guru",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        // --- BAGIAN INI YANG TADI ERROR (SUDAH DIPERBAIKI) ---
        actions: [
          // Tombol Rahasia buat ngetes layar Order Masuk
          IconButton(
            icon: const Icon(Icons.notifications_active, color: Colors.blue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const IncomingOrderPage()),
              );
            },
          ),
          // Tombol Logout
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomePage()),
                (route) => false,
              );
            },
          )
        ],
      ), // <--- Jangan lupa kurung tutup AppBar
      // ---------------------------------------------------

      body: Column(
        children: [
          // --- HEADER PROFIL GURU ---
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      NetworkImage("https://i.pravatar.cc/150?img=11"),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Pak Budi",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text("Spesialis Matematika",
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),
                // Bintang Rating
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(20)),
                  child: const Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 18),
                      SizedBox(width: 4),
                      Text("4.8",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // --- TOMBOL TOGGLE STATUS BESAR ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                // Ubah status saat diklik
                ref.read(tutorStatusProvider.notifier).toggleStatus();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: isOnline ? Colors.green : Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    if (isOnline)
                      BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5))
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      isOnline ? Icons.radar : Icons.power_settings_new,
                      color: isOnline ? Colors.white : Colors.grey[600],
                      size: 40,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isOnline
                          ? "Status: AKTIF / MENUNGGU ORDER"
                          : "Status: TIDAK AKTIF / LIBUR",
                      style: TextStyle(
                        color: isOnline ? Colors.white : Colors.grey[700],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isOnline)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text("Lokasi GPS dibagikan...",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12)),
                      )
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // --- SUMMARY PENDAPATAN ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                    child: _buildSummaryCard(
                        "Pendapatan Hari Ini",
                        "Rp 150.000",
                        Icons.account_balance_wallet,
                        Colors.blue)),
                const SizedBox(width: 16),
                Expanded(
                    child: _buildSummaryCard("Selesai", "3 Order",
                        Icons.check_circle, Colors.green)),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // --- RIWAYAT MENGAJAR ---
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Riwayat Hari Ini",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const CircleAvatar(
                              backgroundColor: Color(0xFFE8F5E9),
                              child: Icon(Icons.school, color: Colors.green)),
                          title: const Text("Muhamad Zidan (SMA)",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: const Text("14:00 - Selesai"),
                          trailing: const Text("+ Rp 50.000",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold)),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Widget Helper untuk Kartu Summary
  Widget _buildSummaryCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 4),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}
