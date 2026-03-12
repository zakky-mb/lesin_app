import 'package:flutter/material.dart';
import 'models/tutor_model.dart'; // Import model biar kenal tipe data Tutor

class BookingPage extends StatefulWidget {
  // Kita butuh data Guru yang dipilih
  final Tutor tutor;

  const BookingPage({super.key, required this.tutor});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  // Variable untuk simpan tanggal yang dipilih
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form Pemesanan"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. INFO GURU YANG DIPILIH
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(widget.tutor.imageUrl),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.tutor.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(widget.tutor.subject),
                      Text(
                        widget.tutor.price,
                        style: const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 2. PILIH TANGGAL (DatePicker)
            const Text("Pilih Tanggal Les",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                // Munculkan Kalender Bawaan Android
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(), // Gak boleh pilih tanggal lampau
                  lastDate: DateTime(2026),
                );

                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate == null
                          ? "Klik untuk pilih tanggal"
                          : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.calendar_today, color: Colors.blue),
                  ],
                ),
              ),
            ),

            const Spacer(), // Dorong tombol ke paling bawah

            // 3. TOMBOL KONFIRMASI
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Pilih tanggal dulu ya!"),
                          backgroundColor: Colors.red),
                    );
                    return;
                  }

                  // Tampilkan Dialog Sukses
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Pesanan Berhasil!"),
                      content: Text(
                          "Kamu akan belajar ${widget.tutor.subject} bareng ${widget.tutor.name}."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Tutup Dialog
                            Navigator.pop(context); // Kembali ke Home
                          },
                          child: const Text("OK"),
                        )
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Konfirmasi Pesanan",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
