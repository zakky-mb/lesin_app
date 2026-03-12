import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'booking_service.dart';

// 1. Provider untuk MENGAMBIL data chat (FutureProvider = Auto Loading & Error Handle)
// Pakai .family karena kita butuh melempar parameter 'bookingId'
final chatListProvider =
    FutureProvider.family<List<dynamic>, String>((ref, bookingId) async {
  final service = ref.watch(bookingServiceProvider);
  return await service.getChats(bookingId);
});

// 2. Controller untuk MENGIRIM pesan (StateNotifier)
class ChatSendController extends StateNotifier<AsyncValue<void>> {
  final BookingService _service;
  ChatSendController(this._service) : super(const AsyncData(null));

  Future<bool> send(String bookingId, String message) async {
    state = const AsyncLoading(); // Tombol send jadi muter
    try {
      await _service.sendMessage(bookingId, message);
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

// 3. Provider untuk Controller Kirim Pesan
final chatSendControllerProvider =
    StateNotifierProvider<ChatSendController, AsyncValue<void>>((ref) {
  return ChatSendController(ref.watch(bookingServiceProvider));
});
