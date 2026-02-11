import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Ganti IP sesuai emulator:
// Android Emulator: 10.0.2.2
// iOS Simulator: 127.0.0.1
// HP Fisik/Web: IP Laptop (misal 192.168.1.x)
const String kBaseUrl = 'http://10.0.2.2:8000/api';

final apiClientProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: kBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );
  return dio;
});
