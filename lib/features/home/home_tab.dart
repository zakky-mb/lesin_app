import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tutor_controller.dart';
import 'models/tutor_model.dart';
import '../order/select_subject_page.dart'; // Arahkan tombol pesan ke sini

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTutors = ref.watch(tutorListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. BACKGROUND GRADIENT (Header Besar)
          Container(
            height: 300,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF9966), Color(0xFFFF5E62)],
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: const Text("Lesin",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFFFF5E62))),
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.notifications_outlined,
                                  color: Colors.white)),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.settings_outlined,
                                  color: Colors.white)),
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
                              NetworkImage("https://i.pravatar.cc/150?img=12")),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Siswa",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                          const Text("Muhamad Zidan Fathul...",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Container(
                              height: 4,
                              width: 60,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(5)))
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20)),
                        child: const Row(
                          children: [
                            Icon(Icons.monetization_on,
                                color: Colors.yellow, size: 16),
                            SizedBox(width: 4),
                            Text("150 Rb",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 3. BODY MELENGKUNG (Menu & Konten Bawah)
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.only(top: 30, bottom: 80),
                      children: [
                        // --- DUA MENU UTAMA (PESAN & HISTORY) ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildMainMenu(
                              context,
                              title: "Pesan",
                              icon: Icons.electric_scooter, // Ikon ala Gojek
                              color: const Color(0xFFFF5E62),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SelectSubjectPage()));
                              },
                            ),
                            _buildMainMenu(
                              context,
                              title: "History",
                              icon: Icons.history,
                              color: Colors.blue,
                              onTap: () {
                                // Aksi history (Bisa dikosongkan karena sudah ada di tab bawah)
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // --- PROMO BANNER (BARU!) ---
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text("Promo Spesial Buat Kamu! 🎁",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 12),
                        _buildPromoBanners(),

                        const SizedBox(height: 30),

                        // --- GURU REKOMENDASI ---
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text("Guru Rekomendasi",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 12),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: asyncTutors.when(
                            data: (tutors) => Column(
                              children: tutors
                                  .map((tutor) =>
                                      _buildTutorCard(context, tutor))
                                  .toList(),
                            ),
                            error: (err, _) =>
                                const Text("Gagal memuat data guru."),
                            loading: () => const Center(
                                child: CircularProgressIndicator(
                                    color: Color(0xFFFF5E62))),
                          ),
                        ),
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

  // WIDGET: Menu Utama Bulat
  Widget _buildMainMenu(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 65,
            width: 65,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: color),
          ),
          const SizedBox(height: 8),
          Text(title,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // WIDGET BARU: Promo Banner (Bisa di-scroll ke samping)
  Widget _buildPromoBanners() {
    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _promoCard(
            title: "Diskon 50% Matematika",
            subtitle: "Gunakan kode: MATH50",
            color1: const Color(0xFFFF9966),
            color2: const Color(0xFFFF5E62),
            icon: Icons.calculate,
          ),
          _promoCard(
            title: "Gratis Biaya Jarak!",
            subtitle: "Khusus Les Bahasa Inggris",
            color1: Colors.blue.shade400,
            color2: Colors.blue.shade700,
            icon: Icons.language,
          ),
        ],
      ),
    );
  }

  // WIDGET HELPER: Desain Kartu Promo
  Widget _promoCard(
      {required String title,
      required String subtitle,
      required Color color1,
      required Color color2,
      required IconData icon}) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [color1, color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(subtitle,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          Icon(icon, size: 50, color: Colors.white.withOpacity(0.5)),
        ],
      ),
    );
  }

  // WIDGET: Kartu Guru Rekomendasi
  Widget _buildTutorCard(BuildContext context, Tutor tutor) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
            radius: 25, backgroundImage: NetworkImage(tutor.imageUrl)),
        title: Text(tutor.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tutor.subject),
            Row(children: [
              const Icon(Icons.star, color: Colors.orange, size: 14),
              Text(" ${tutor.rating}",
                  style: const TextStyle(fontWeight: FontWeight.bold))
            ]),
          ],
        ),
        trailing: TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SelectSubjectPage()));
          },
          child: const Text("Pesan",
              style: TextStyle(
                  color: Color(0xFFFF5E62), fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
