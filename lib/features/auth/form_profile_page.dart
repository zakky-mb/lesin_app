import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/storage_service.dart';
import '../home/home_page.dart'; // Beranda Murid
import '../tutor/tutor_dashboard_page.dart'; // Beranda Guru

class FormProfilePage extends ConsumerStatefulWidget {
  final String role; // 'student' atau 'tutor'

  const FormProfilePage({super.key, required this.role});

  @override
  ConsumerState<FormProfilePage> createState() => _FormProfilePageState();
}

class _FormProfilePageState extends ConsumerState<FormProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final bioController = TextEditingController();
  final priceController = TextEditingController();

  String? selectedJenjang;
  final List<String> jenjangOptions = ["SD", "SMP", "SMA", "Umum"];

  // Logic Simpan
  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      // 1. Simpan Token & Role ke Brankas (Simulasi Register Sukses)
      final storage = ref.read(storageServiceProvider);
      await storage.saveToken("dummy_token_baru_register");
      await storage.saveRole(widget.role); // Simpan 'student' atau 'tutor'

      // 2. Arahkan ke Halaman yang Benar
      if (mounted) {
        if (widget.role == 'tutor') {
          // Masuk ke Dashboard Guru
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const TutorDashboardPage()),
            (route) => false,
          );
        } else {
          // Masuk ke Dashboard Murid
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isTutor = widget.role == 'tutor';

    return Scaffold(
      appBar: AppBar(title: Text(isTutor ? "Profil Guru" : "Profil Murid")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text("Lengkapi datamu dulu ya!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                  labelText: "Nama Lengkap",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person)),
              validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  labelText: "Nomor WhatsApp",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone)),
              validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
            ),
            const SizedBox(height: 16),
            if (!isTutor)
              DropdownButtonFormField<String>(
                value: selectedJenjang,
                items: jenjangOptions
                    .map((String value) => DropdownMenuItem<String>(
                        value: value, child: Text(value)))
                    .toList(),
                onChanged: (newValue) =>
                    setState(() => selectedJenjang = newValue),
                decoration: const InputDecoration(
                    labelText: "Jenjang Sekolah",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.school)),
              ),
            if (isTutor) ...[
              TextFormField(
                controller: bioController,
                maxLines: 3,
                decoration: const InputDecoration(
                    labelText: "Bio Singkat / Pengalaman",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.history_edu),
                    alignLabelWithHint: true),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: "Tarif Dasar (Per Jam)",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.monetization_on),
                    prefixText: "Rp "),
              ),
            ],
            const SizedBox(height: 40),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5E62),
                    foregroundColor: Colors.white),
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
