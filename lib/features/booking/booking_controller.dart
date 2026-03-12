import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'booking_service.dart';

class BookingController extends StateNotifier<AsyncValue<void>> {
  final BookingService _service;

  BookingController(this._service) : super(const AsyncData(null));

  // --- FUNGSI 1: Cancel Order ---
  Future<bool> cancelOrder(String bookingId, String reason) async {
    state = const AsyncLoading(); // Mulai loading
    try {
      // Panggil API
      await _service.cancelBooking(bookingId, reason);
      state = const AsyncData(null); // Sukses
      return true;
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace); // Gagal
      return false;
    }
  }

  // --- FUNGSI 2: Update Tracking (Sekarang sudah di DALAM class) ---
  Future<Map<String, dynamic>?> updateTracking(
      String bookingId, String status) async {
    state = const AsyncLoading(); // Munculkan muter-muter
    try {
      // Panggil service
      final result = await _service.updateTrackingStatus(bookingId, status);
      state = const AsyncData(null); // Sukses
      return result; // Kembalikan data ke UI
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace); // Gagal
      return null;
    }
  }
} // <--- PERHATIKAN: Penutup class-nya ada di sini sekarang

// --- PROVIDER ---
final bookingControllerProvider =
    StateNotifierProvider<BookingController, AsyncValue<void>>((ref) {
  final service = ref.watch(bookingServiceProvider);
  return BookingController(service);
});
