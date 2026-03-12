import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. BACKGROUND GRADIENT (Header Besar)
          Container(
            height: 300, // Header agak tinggi sesuai screenshot
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF9966), Color(0xFFFF5E62)], // Peach ke Pink
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // 2. KONTEN
          SafeArea(
            child: Column(
              children: [
                // --- TOP BAR (Logo & Notif) ---
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Label Aplikasi
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "Lesin",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      // Icon Notif & Setting
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.notifications_outlined,
                                color: Colors.white),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.settings_outlined,
                                color: Colors.white),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                // --- USER INFO ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            NetworkImage("https://i.pravatar.cc/150?img=12"),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Siswa",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                          const Text(
                            "Muhamad Zidan Fathul...",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          // Label Putih kecil di bawah nama (sesuai screenshot)
                          Container(
                            height: 10,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          )
                        ],
                      ),
                      const Spacer(),
                      // Toggle Switch (Dummy)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.monetization_on,
                                color: Colors.yellow, size: 16),
                            SizedBox(width: 4),
                            Text("0", style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                // Tanggal
                const Padding(
                  padding: EdgeInsets.only(right: 20, top: 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Kamis, 12 Februari 2026",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 3. BODY MELENGKUNG (Menu Utama)
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        // --- DUA MENU UTAMA (PESAN & HISTORY) ---
                        // Ini akan jadi trigger flow "Gojek"
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildMainMenu(
                              context,
                              title: "Pesan",
                              icon: Icons.edit_document,
                              onTap: () {
                                // TODO: MASUK KE HALAMAN PILIH MAPEL (STEP SELANJUTNYA)
                                print("Masuk ke Pilih Mapel");
                              },
                            ),
                            _buildMainMenu(
                              context,
                              title: "History",
                              icon: Icons.history,
                              onTap: () {
                                // TODO: Masuk ke Tab History
                                print("Masuk ke History");
                              },
                            ),
                          ],
                        ),

                        // Area kosong di bawah (bisa diisi promo/news nanti)
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget Tombol Menu Besar
  Widget _buildMainMenu(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Icon(icon, size: 30, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
