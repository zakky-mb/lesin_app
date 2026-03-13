import 'package:flutter/material.dart';
import 'order_map_page.dart';

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
  final double distanceKm = 2.5;
  final int pricePerKm = 2000;

  late int distancePrice;
  late int totalPrice;

  // State untuk Metode Pembayaran
  String selectedPayment = "Tunai (Cash)";
  IconData paymentIcon = Icons.money;

  @override
  void initState() {
    super.initState();
    distancePrice = (distanceKm * pricePerKm).toInt();
    totalPrice = widget.basePrice + distancePrice;
  }

  // Fungsi memunculkan Bottom Sheet Pembayaran
  void _showPaymentSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Pilih Metode Pembayaran",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // Opsi 1: Tunai
              ListTile(
                leading: const Icon(Icons.money, color: Colors.green),
                title: const Text("Tunai (Cash)"),
                trailing: selectedPayment == "Tunai (Cash)"
                    ? const Icon(Icons.check_circle, color: Color(0xFFFF5E62))
                    : null,
                onTap: () {
                  setState(() {
                    selectedPayment = "Tunai (Cash)";
                    paymentIcon = Icons.money;
                  });
                  Navigator.pop(context);
                },
              ),
              const Divider(),

              // Opsi 2: Saldo LesPay
              ListTile(
                leading: const Icon(Icons.account_balance_wallet,
                    color: Colors.blue),
                title: const Text("LesPay (Saldo Digital)"),
                subtitle: const Text("Saldo: Rp 150.000"),
                trailing: selectedPayment == "LesPay"
                    ? const Icon(Icons.check_circle, color: Color(0xFFFF5E62))
                    : null,
                onTap: () {
                  setState(() {
                    selectedPayment = "LesPay";
                    paymentIcon = Icons.account_balance_wallet;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
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
            const Text("Detail Belajar",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200)),
              child: Column(
                children: [
                  Row(children: [
                    const Icon(Icons.menu_book, color: Colors.blue),
                    const SizedBox(width: 12),
                    Text("Mapel: ${widget.subjectName}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16))
                  ]),
                  const Divider(height: 24),
                  const Row(children: [
                    Icon(Icons.location_on, color: Colors.red),
                    SizedBox(width: 12),
                    Expanded(
                        child: Text("Lokasi: Jl. Merdeka No.45",
                            style: TextStyle(color: Colors.grey)))
                  ]),
                ],
              ),
            ),

            const SizedBox(height: 32),
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

            // --- WIDGET PILIH PEMBAYARAN BARU ---
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(paymentIcon,
                      color: selectedPayment == "LesPay"
                          ? Colors.blue
                          : Colors.green),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Metode Pembayaran",
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text(selectedPayment,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _showPaymentSelector,
                    child: const Text("Ubah",
                        style: TextStyle(
                            color: Color(0xFFFF5E62),
                            fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- TOMBOL PESAN ---
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OrderMapPage()));
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFFFF5E62)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16))),
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
