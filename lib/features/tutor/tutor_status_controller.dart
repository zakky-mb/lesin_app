import 'package:flutter_riverpod/flutter_riverpod.dart';

// Controller untuk mengatur status Aktif/Libur Guru
class TutorStatusController extends StateNotifier<bool> {
  TutorStatusController() : super(false); // Default: Offline (false)

  void toggleStatus() {
    state = !state; // Kebalikan dari status sekarang (true jadi false, dst)

    // TODO: Nanti di sini kita panggil API ke Laravel
    // _dio.patch('/v1/tutors/status', data: {"is_active": state});

    if (state) {
      print("📡 GPS Nyala! Guru siap menerima order...");
    } else {
      print("💤 Guru sedang libur.");
    }
  }
}

// Provider agar bisa dipakai di UI
final tutorStatusProvider =
    StateNotifierProvider<TutorStatusController, bool>((ref) {
  return TutorStatusController();
});
