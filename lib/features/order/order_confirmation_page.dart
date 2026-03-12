import 'package:flutter/material.dart';
import 'order_map_page.dart'; // PASTIKAN FILE INI SUDAH DIBUAT YA!

class OrderConfirmationPage extends StatefulWidget {
  final String subjectName;
  final int basePrice;

  const OrderConfirmationPage({
    super.key,
    required this.subjectName,
    required this.basePrice,
  });

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  // Simulasi Jarak & Harga
  final double distanceKm = 2.5; // Anggap jarak ke guru terdekat 2.5 km
  final int pricePerKm = 2000; // Rp 2.000 per KM

  late int distancePrice;
  late int totalPrice;

  @override
  void initState() {
    super.initState();
    // Rumus Menghitung Total Harga
    distancePrice = (distanceKm * pricePerKm).toInt();
    totalPrice = widget.basePrice + distancePrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Konfirmasi Pesanan"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- INFO MAPEL & LOKASI ---
            const Text("Detail Belajar",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.menu_book, color: Colors.blue),
                      const SizedBox(width: 12),
                      Text("Mapel: ${widget.subjectName}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const Divider(height: 24),
                  const Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red),
                      SizedBox(width: 12),
                      Expanded(
                          child: Text("Lokasi Kamu: Jl. Merdeka No.45, Jakarta",
                              style: TextStyle(color: Colors.grey))),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // --- RINCIAN BIAYA ---
            const Text("Rincian Biaya",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildPriceRow(
                "Tarif ${widget.subjectName}", "Rp ${widget.basePrice}"),
            const SizedBox(height: 8),
            _buildPriceRow(
                "Biaya Perjalanan ($distanceKm km)", "Rp $distancePrice"),
            const Divider(height: 32, thickness: 1),
            _buildPriceRow("Total Pembayaran", "Rp $totalPrice", isTotal: true),

            const Spacer(),

            // --- TOMBOL PESAN SEKARANG ---
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // MASUK KE RADAR GOOGLE MAPS CARI GURU!
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OrderMapPage()),
                  );
                },
                // INI YANG DIPERBAIKI (Jurus Anti Merah)
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFFFF5E62)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                child: const Text("Pesan Sekarang",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget Helper biar rapi
  Widget _buildPriceRow(String label, String price, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: isTotal ? 16 : 14,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isTotal ? Colors.black : Colors.grey[700])),
        Text(price,
            style: TextStyle(
                fontSize: isTotal ? 18 : 14,
                fontWeight: FontWeight.bold,
                color: isTotal ? const Color(0xFFFF5E62) : Colors.black)),
      ],
    );
  }
}
