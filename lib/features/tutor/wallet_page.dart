import 'package:flutter/material.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Dompet Saya",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFFF9966),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // --- KARTU SALDO UTAMA ---
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(left: 24, right: 24, bottom: 40, top: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF9966), Color(0xFFFF5E62)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
            ),
            child: Column(
              children: [
                const Text("Total Saldo Tersedia",
                    style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 8),
                const Text("Rp 1.550.000",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),

                // TOMBOL TARIK DANA
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Fitur Tarik Dana segera hadir!")));
                  },
                  icon: const Icon(Icons.account_balance,
                      color: Color(0xFFFF5E62)),
                  label: const Text("Tarik Dana (Withdraw)",
                      style: TextStyle(
                          color: Color(0xFFFF5E62),
                          fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 24),

          // --- RIWAYAT TRANSAKSI ---
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
                  const Text("Riwayat Transaksi",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildTransactionItem("Selesai Mengajar (Matematika)",
                            "ORD-10293", "+ Rp 55.000", true, "12 Feb 2026"),
                        _buildTransactionItem("Tarik Dana ke BCA", "WD-99882",
                            "- Rp 500.000", false, "10 Feb 2026"),
                        _buildTransactionItem("Selesai Mengajar (Fisika)",
                            "ORD-10200", "+ Rp 75.000", true, "09 Feb 2026"),
                        _buildTransactionItem("Selesai Mengajar (B. Inggris)",
                            "ORD-10150", "+ Rp 60.000", true, "08 Feb 2026"),
                      ],
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

  Widget _buildTransactionItem(String title, String subtitle, String amount,
      bool isIncome, String date) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: isIncome ? Colors.green[50] : Colors.red[50],
          child: Icon(isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: isIncome ? Colors.green : Colors.red),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle:
            Text("$date • $subtitle", style: const TextStyle(fontSize: 12)),
        trailing: Text(amount,
            style: TextStyle(
                color: isIncome ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
      ),
    );
  }
}
