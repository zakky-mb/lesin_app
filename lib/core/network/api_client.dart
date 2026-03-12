import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/storage_service.dart'; // Import brankas

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

  // --- DIO INTERCEPTOR (SATPAM API) ---
  // Tugasnya menyadap setiap request sebelum terbang ke Laravel
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 1. Ambil token dari brankas
        final storage = ref.read(storageServiceProvider);
        final token = await storage.getToken();

        // 2. Kalau token ada, suntikkan ke Header (Bearer Token)
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        // 3. Print log biar gampang debugging
        print("➡️ MENGIRIM[${options.method}] KE: ${options.uri}");
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print(
            "✅ SUKSES [${response.statusCode}] DARI: ${response.requestOptions.uri}");
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print(
            "❌ ERROR [${e.response?.statusCode}] DARI: ${e.requestOptions.uri}");
        print("PESAN: ${e.message}");
        return handler.next(e);
      },
    ),
  );

  return dio;
});
