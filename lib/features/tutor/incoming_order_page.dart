import 'dart:async';
import 'package:flutter/material.dart';
import '../booking/active_order_tutor_page.dart'; // Halaman mengajar yang kita buat sebelumnya

class IncomingOrderPage extends StatefulWidget {
  const IncomingOrderPage({super.key});

  @override
  State<IncomingOrderPage> createState() => _IncomingOrderPageState();
}

class _IncomingOrderPageState extends State<IncomingOrderPage> {
  int _timeLeft = 30; // Waktu mundur 30 detik
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        // Waktu Habis! Tolak otomatis dan tutup halaman
        _timer?.cancel();
        _rejectOrder();
      }
    });
  }

  void _rejectOrder() {
    // Tutup pop-up order masuk
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Order dilewati."), backgroundColor: Colors.orange),
    );
  }

  void _acceptOrder() {
    _timer?.cancel(); // Matikan timer
    Navigator.pop(context); // Tutup layar order masuk

    // Pindah ke Halaman Active Order (Sedang Mengajar)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ActiveOrderTutorPage(
          bookingId: "ORD-10293",
          initialStatus: "accepted", // Status OTW ke lokasi murid
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Wajib bersihkan timer kalau halaman ditutup
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Background gelap biar fokus
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- ANIMASI RADAR / ICON ---
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.notifications_active,
                    color: Colors.blueAccent, size: 80),
              ),
              const SizedBox(height: 32),

              const Text("PESANAN BARU MASUK!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5)),
              const SizedBox(height: 40),

              // --- INFO ORDER ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Mata Pelajaran",
                            style: TextStyle(color: Colors.grey)),
                        Text("Matematika (SMA)",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const Divider(height: 32),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Jarak Jemput",
                            style: TextStyle(color: Colors.grey)),
                        Text("2.5 km",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Estimasi Pendapatan",
                            style: TextStyle(color: Colors.grey)),
                        Text("Rp 60.000",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.green[700])),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // --- TIMER MUNDUR ---
              Text(
                "00:${_timeLeft.toString().padLeft(2, '0')}",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: _timeLeft <= 10
                      ? Colors.red
                      : Colors.white, // Merah kalau sisa 10 detik
                ),
              ),
              const SizedBox(height: 10),
              const Text("Segera ambil sebelum waktu habis!",
                  style: TextStyle(color: Colors.white70)),

              const Spacer(),

              // --- TOMBOL TERIMA / TOLAK ---
              Row(
                children: [
                  // Tombol Tolak
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _rejectOrder,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white54, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text("LEWATI",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Tombol Terima
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _acceptOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Warna biru
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 5,
                      ),
                      child: const Text("TERIMA",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
