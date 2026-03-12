import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_controller.dart';
import '../auth/login_page.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HEADER (Foto Profil Melayang) ---
            Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      height: 160,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFF9966), Color(0xFFFF5E62)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
                Positioned(
                  top: 40,
                  child: const Text("Profil",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit, color: Colors.white)),
                ),
                Positioned(
                  bottom: 0,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: const CircleAvatar(
                          radius: 45,
                          backgroundImage:
                              NetworkImage("https://i.pravatar.cc/150?img=12"),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5E62),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text("Siswa",
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            const Text(
              "Muhamad Zidan Fathul Ghomam",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Text("| @Milky01", style: TextStyle(color: Colors.grey)),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // CARD KONTAK
                  _buildSectionCard([
                    _buildInfoRow(Icons.phone_android, "+62895412421362",
                        hasVerifiedIcon: true),
                    const Divider(),
                    _buildInfoRow(Icons.email, "zdnfathul@gmail.com",
                        hasWarningIcon: true),
                    const Divider(),
                    _buildInfoRow(Icons.chat, "62895411697187"),
                  ]),

                  const SizedBox(height: 20),

                  // CARD BIODATA (Tanpa Sekolah/Ortu)
                  _buildSectionCard([
                    _buildInfoRow(Icons.cake, "02 April 2009",
                        label: "Tanggal Lahir"),
                    const Divider(),
                    _buildInfoRow(Icons.male, "Laki - Laki",
                        label: "Jenis Kelamin"),
                    const Divider(),
                    _buildInfoRow(
                        Icons.location_on, "Perum Griya Utama Banjardowo...",
                        label: "Alamat"),
                  ]),

                  const SizedBox(height: 20),

                  // AKTIVITAS FAVORIT
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("AKTIVITAS FAVORIT",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]))),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildChip("Music"),
                      _buildChip("Social Media"),
                      _buildChip("Gaming"),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // LOGOUT
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(authControllerProvider.notifier).logout();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text("Keluar Aplikasi"),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(IconData icon, String value,
      {String? label,
      bool hasVerifiedIcon = false,
      bool hasWarningIcon = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (label != null)
                  Text(label,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value,
                    style:
                        const TextStyle(fontSize: 14, color: Colors.black87)),
              ],
            ),
          ),
          if (hasVerifiedIcon)
            const Icon(Icons.verified, color: Colors.blue, size: 18),
          if (hasWarningIcon)
            const Icon(Icons.error, color: Colors.orange, size: 18),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Chip(
      label: Text(label,
          style: const TextStyle(color: Colors.white, fontSize: 12)),
      backgroundColor: const Color(0xFFFF9966),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), side: BorderSide.none),
    );
  }
}
