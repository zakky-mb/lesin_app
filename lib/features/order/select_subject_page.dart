import 'package:flutter/material.dart';
import 'order_confirmation_page.dart'; // Kita buat setelah ini

class SelectSubjectPage extends StatelessWidget {
  const SelectSubjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy mata pelajaran beserta tarif dasarnya
    final List<Map<String, dynamic>> subjects = [
      {
        "name": "Matematika",
        "icon": Icons.calculate,
        "price": 50000,
        "color": Colors.orange
      },
      {
        "name": "Bahasa Inggris",
        "icon": Icons.language,
        "price": 45000,
        "color": Colors.blue
      },
      {
        "name": "Fisika",
        "icon": Icons.science,
        "price": 60000,
        "color": Colors.red
      },
      {
        "name": "Coding (IT)",
        "icon": Icons.code,
        "price": 75000,
        "color": Colors.black
      },
      {
        "name": "Mengaji",
        "icon": Icons.menu_book,
        "price": 40000,
        "color": Colors.teal
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Pilih Mata Pelajaran",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final subject = subjects[index];
          return Card(
            elevation: 0,
            color: Colors.grey[50],
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (subject['color'] as Color).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(subject['icon'], color: subject['color']),
              ),
              title: Text(subject['name'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Text("Mulai dari Rp ${subject['price']}/jam"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Lanjut ke Konfirmasi Order bawa data Mapel
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderConfirmationPage(
                      subjectName: subject['name'],
                      basePrice: subject['price'],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
