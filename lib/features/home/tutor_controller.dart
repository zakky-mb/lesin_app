import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/tutor_model.dart';
import 'models/tutor_model.dart';

// Provider ini tugasnya mengambil data (seolah-olah dari API)
final tutorListProvider = FutureProvider<List<Tutor>>((ref) async {
  // 1. Simulasi Loading (Tunggu 2 detik)
  await Future.delayed(const Duration(seconds: 2));

  // 2. Kembalikan Data Guru
  return [
    Tutor(
      name: "Pak Budi",
      subject: "Matematika Dasar",
      imageUrl: "https://i.pravatar.cc/150?img=11",
      rating: 4.8,
      price: "Rp 50.000/jam",
    ),
    Tutor(
      name: "Bu Siti",
      subject: "Bahasa Inggris",
      imageUrl: "https://i.pravatar.cc/150?img=5",
      rating: 4.9,
      price: "Rp 75.000/jam",
    ),
    Tutor(
      name: "Kak Jojo",
      subject: "Fisika Quantum",
      imageUrl: "https://i.pravatar.cc/150?img=3",
      rating: 4.5,
      price: "Rp 120.000/jam",
    ),
    Tutor(
      name: "Mbak Rina",
      subject: "Kimia",
      imageUrl: "https://i.pravatar.cc/150?img=9",
      rating: 4.7,
      price: "Rp 60.000/jam",
    ),
  ];
});
