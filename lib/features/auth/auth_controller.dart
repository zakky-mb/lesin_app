import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../core/storage/storage_service.dart';

class AuthController extends StateNotifier<AsyncValue<void>> {
  final Dio _dio;
  final StorageService _storage;

  AuthController(this._dio, this._storage) : super(const AsyncData(null));

  // --- FUNGSI LOGIN ---
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();

    try {
      if (email.isEmpty || password.isEmpty) {
        throw Exception("Email dan Password tidak boleh kosong!");
      }

      await Future.delayed(const Duration(seconds: 2));

      if (email == "siswa@lesin.com" && password == "123456") {
        String fakeToken = "abc.123.token_rahasia_dari_laravel";
        await _storage.saveToken(fakeToken);
        state = const AsyncData(null);
      } else {
        throw Exception("Email atau Password salah!");
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  // --- FUNGSI CEK STATUS LOGIN (Buat Splash Screen) ---
  Future<bool> checkLoginStatus() async {
    state = const AsyncLoading();
    final token = await _storage.getToken();
    if (token != null && token.isNotEmpty) {
      state = const AsyncData(null);
      return true;
    } else {
      state = const AsyncData(null);
      return false;
    }
  }

  // --- FUNGSI LOGOUT (INI YANG HILANG TADI) ---
  Future<void> logout() async {
    // 1. Hapus token dari brankas
    await _storage.deleteToken();
    // 2. Reset state (opsional)
    state = const AsyncData(null);
  }
} // <--- Tutup Class AuthController

// --- PROVIDER ---
final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  final dio = ref.watch(apiClientProvider);
  final storage = ref.watch(storageServiceProvider);
  return AuthController(dio, storage);
});
