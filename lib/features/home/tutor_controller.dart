import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart'; // Import Dio client kita
import 'models/tutor_model.dart';

// Provider ini akan memanggil API Laravel untuk mengambil daftar guru
final tutorListProvider = FutureProvider<List<Tutor>>((ref) async {
  // 1. Ambil "Mesin" API kita (Dio)
  final dio = ref.watch(apiClientProvider);

  try {
    // 2. Tembak Endpoint Backend teman kamu
    // (Asumsi endpointnya: GET /api/v1/tutors)
    final response = await dio.get('/v1/tutors');

    // 3. Ambil List JSON dari response (biasanya dibungkus dalam 'data')
    final List<dynamic> rawData = response.data['data'] ?? [];

    // 4. Ubah List JSON menjadi List Object Tutor menggunakan fromJson
    List<Tutor> tutors = rawData.map((json) => Tutor.fromJson(json)).toList();

    return tutors;
  } catch (e) {
    print("❌ GAGAL MENGAMBIL DATA GURU: $e");

    // MOCKING DATA (Penyelamat UI)
    // Kalau backend teman kamu belum nyala atau error, UI tetep jalan pakai data ini
    return [
      Tutor(
          id: 1,
          name: "Pak Budi (Mock)",
          subject: "Matematika Dasar",
          imageUrl: "https://i.pravatar.cc/150?img=11",
          rating: 4.8,
          price: "Rp 50.000/jam"),
      Tutor(
          id: 2,
          name: "Bu Siti (Mock)",
          subject: "Bahasa Inggris",
          imageUrl: "https://i.pravatar.cc/150?img=5",
          rating: 4.9,
          price: "Rp 75.000/jam"),
      Tutor(
          id: 3,
          name: "Kak Jojo (Mock)",
          subject: "Fisika Quantum",
          imageUrl: "https://i.pravatar.cc/150?img=3",
          rating: 4.5,
          price: "Rp 120.000/jam"),
    ];
  }
});
