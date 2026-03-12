import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';

class BookingService {
  final Dio _dio;

  BookingService(this._dio);

  // 1. API CALL: Cancel Booking (Student)
  Future<void> cancelBooking(String bookingId, String reason) async {
    try {
      // POST /api/v1/bookings/{id}/cancel
      await _dio.post(
        '/v1/bookings/$bookingId/cancel',
        data: {
          "reason": reason, // Body sesuai request backend
        },
      );
    } catch (e) {
      throw Exception("Gagal membatalkan pesanan: $e");
    }
  }

  // 2. API CALL: Update Tracking Guru (Tutor View)
  Future<Map<String, dynamic>> updateTrackingStatus(
      String bookingId, String status) async {
    try {
      final response = await _dio.patch(
        '/v1/bookings/$bookingId/tracking',
        data: {
          "status": status, // isinya: "arrived" atau "completed"
        },
      );

      return response.data as Map<String, dynamic>? ?? {};
    } catch (e) {
      throw Exception("Gagal update status: $e");
    }
  }

  // 3. API CALL: Ambil Daftar Pesan Chat (GET)
  Future<List<dynamic>> getChats(String bookingId) async {
    try {
      // Endpoint: GET /api/v1/bookings/{id}/chat
      final response = await _dio.get('/v1/bookings/$bookingId/chat');

      // Asumsi backend mereturn json { "data":[ ... ] }
      return response.data['data'] ?? [];
    } catch (e) {
      print("Error get chat: $e");
      // MOCKING DATA SEMENTARA (Biar UI bisa dites walau API backend belum nyala)
      return [
        {"id": 1, "message": "Halo kak, posisinya di mana?", "is_me": false},
        {
          "id": 2,
          "message": "Saya sudah di depan pagar warna hitam ya.",
          "is_me": true
        },
      ];
    }
  }

  // 4. API CALL: Kirim Pesan Chat (POST)
  Future<void> sendMessage(String bookingId, String message) async {
    try {
      // Endpoint: POST /api/v1/bookings/{id}/chat
      await _dio.post(
        '/v1/bookings/$bookingId/chat',
        data: {
          "message": message,
        },
      );
    } catch (e) {
      throw Exception("Gagal mengirim pesan: $e");
    }
  }
} // <--- PENUTUP CLASS BookingService YANG BENAR PINDAH KE SINI

// Provider untuk Booking Service (Diletakkan di luar class)
final bookingServiceProvider = Provider<BookingService>((ref) {
  final dio = ref.watch(apiClientProvider);
  return BookingService(dio);
});
