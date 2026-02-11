import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Buat Class Service
class StorageService {
  // Ini Brankas-nya
  final _storage = const FlutterSecureStorage();

  // Kunci rahasia untuk nyari datanya
  static const _tokenKey = 'auth_token';

  // Fungsi: SIMPAN Token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Fungsi: AMBIL Token (Buat cek login otomatis)
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Fungsi: HAPUS Token (Buat Logout)
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}

// 2. Buat Provider biar bisa dipanggil Controller
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});
