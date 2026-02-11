import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../core/storage/storage_service.dart'; // <--- IMPORT BARU

class AuthController extends StateNotifier<AsyncValue<void>> {
  final Dio _dio;
  final StorageService _storage; // <--- Tambah Variable Storage

  // Constructor terima Dio DAN Storage
  AuthController(this._dio, this._storage) : super(const AsyncData(null));

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();

    try {
      if (email.isEmpty || password.isEmpty) {
        throw Exception("Email dan Password tidak boleh kosong!");
      }

      await Future.delayed(const Duration(seconds: 2));

      if (email == "siswa@lesin.com" && password == "123456") {
        // --- SIMULASI DAPAT TOKEN DARI SERVER ---
        // Ceritanya server Laravel ngasih token ini:
        String fakeToken = "abc.123.token_rahasia_dari_laravel";

        // --- SIMPAN KE BRANKAS ---
        await _storage.saveToken(fakeToken);

        state = const AsyncData(null);
      } else {
        throw Exception("Email atau Password salah!");
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<bool> checkLoginStatus() async {
    state = const AsyncLoading(); // Mulai loading

    // 1. Buka Brankas, ambil token
    final token = await _storage.getToken();

    // 2. Cek Tokennya
    if (token != null && token.isNotEmpty) {
      // Kalau ada, kita anggap dia SUKSES LOGIN
      state = const AsyncData(null);
      return true; // Beri tahu UI: "User Valid"
    } else {
      // Kalau kosong, berarti belum login
      state = const AsyncData(null); // State normal
      return false; // Beri tahu UI: "User Belum Login"
    }
  }
}

// --- UPDATE PROVIDER ---
final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  final dio = ref.watch(apiClientProvider);
  final storage =
      ref.watch(storageServiceProvider); // <--- Ambil Storage Service

  return AuthController(dio, storage); // <--- Masukkan keduanya
});
