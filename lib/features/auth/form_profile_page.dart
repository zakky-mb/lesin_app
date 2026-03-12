import 'package:flutter/material.dart';
import '../home/home_page.dart'; // Kalau selesai, masuk Home

class FormProfilePage extends StatefulWidget {
  final String role; // 'student' atau 'tutor'

  const FormProfilePage({super.key, required this.role});

  @override
  State<FormProfilePage> createState() => _FormProfilePageState();
}

class _FormProfilePageState extends State<FormProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Controller Form
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final bioController = TextEditingController();
  final priceController = TextEditingController();

  String? selectedJenjang;
  final List<String> jenjangOptions = ["SD", "SMP", "SMA", "Umum"];

  // Logic Simpan
  void _submitData() {
    if (_formKey.currentState!.validate()) {
      // TODO: Simpan data ke API / Riverpod

      // Simulasi Sukses -> Masuk Home
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isTutor = widget.role == 'tutor';

    return Scaffold(
      appBar: AppBar(
        title: Text(isTutor ? "Profil Guru" : "Profil Murid"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text("Lengkapi datamu dulu ya!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),

            // 1. NAMA LENGKAP (Semua Role)
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nama Lengkap",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
            ),
            const SizedBox(height: 16),

            // 2. NOMOR HP (Semua Role)
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Nomor WhatsApp",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
            ),
            const SizedBox(height: 16),

            // 3. KHUSUS MURID (Dropdown Jenjang)
            if (!isTutor)
              DropdownButtonFormField<String>(
                value: selectedJenjang,
                items: jenjangOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedJenjang = newValue;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Jenjang Sekolah",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school),
                ),
              ),

            // 4. KHUSUS GURU (Bio & Tarif)
            if (isTutor) ...[
              TextFormField(
                controller: bioController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Bio Singkat / Pengalaman",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.history_edu),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Tarif Dasar (Per Jam)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.monetization_on),
                  prefixText: "Rp ",
                ),
              ),
              const SizedBox(height: 16),
              // Note: Multi-select Mapel nanti kita buat terpisah biar gak rumit
              const Text("*Mata Pelajaran bisa diatur nanti di menu profil",
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],

            const SizedBox(height: 40),

            // TOMBOL SIMPAN
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5E62),
                  foregroundColor: Colors.white,
                ),
                child: const Text("Simpan & Lanjutkan",
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
