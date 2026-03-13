import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart'; // Library GPS
import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';

// Controller untuk mengatur status Aktif/Libur dan Pemancar GPS
class TutorStatusController extends StateNotifier<bool> {
  final Dio _dio;

  // Variabel untuk menyimpan "Streaming" data lokasi
  StreamSubscription<Position>? _positionStream;

  TutorStatusController(this._dio) : super(false); // Default: Offline

  Future<void> toggleStatus() async {
    bool isGoingOnline =
        !state; // Jika sekarang false, berarti mau true (Online)

    if (isGoingOnline) {
      // 1. Minta Izin GPS Sebelum Online
      bool hasPermission = await _checkLocationPermission();
      if (!hasPermission) {
        print("❌ Gagal Online: Izin GPS ditolak!");
        return; // Batal jadi Online kalau GPS ga diizinkan
      }

      state = true;
      print("🟢 GURU ONLINE! Mengaktifkan Radar GPS...");

      // 2. Kirim status ke Laravel
      // _dio.patch('/v1/tutors/status', data: {"is_active": true});

      // 3. Nyalakan Pemancar Lokasi
      _startLiveTracking();
    } else {
      // MAU OFFLINE
      state = false;
      print("🔴 GURU OFFLINE! Mematikan Radar GPS...");

      // 1. Kirim status ke Laravel
      // _dio.patch('/v1/tutors/status', data: {"is_active": false});

      // 2. Matikan Pemancar Lokasi
      _stopLiveTracking();
    }
  }

  // Fungsi: Meminta izin GPS HP
  Future<bool> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    return true;
  }

  // Fungsi: Mulai memancarkan titik koordinat
  void _startLiveTracking() {
    // Kita set: Pancarkan data tiap kali guru bergeser 10 meter
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high, // Akurasi tinggi
        distanceFilter: 10, // Update tiap 10 meter
      ),
    ).listen((Position position) {
      // Kode ini akan terpanggil otomatis berkali-kali selama guru jalan-jalan
      print(
          "📍 [LIVE TRACKING] Lokasi: Lat ${position.latitude}, Lng ${position.longitude}");

      // TODO: Tembak titik koordinat ini ke API Laravel agar Murid bisa lihat
      // _dio.post('/v1/tutors/live-location', data: {
      //   "latitude": position.latitude,
      //   "longitude": position.longitude
      // });
    });
  }

  // Fungsi: Hentikan pemancaran koordinat
  void _stopLiveTracking() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  @override
  void dispose() {
    // Pastikan GPS dimatikan kalau aplikasi di-close
    _stopLiveTracking();
    super.dispose();
  }
}

// Provider yang sudah disuntik Dio
final tutorStatusProvider =
    StateNotifierProvider<TutorStatusController, bool>((ref) {
  final dio = ref.watch(apiClientProvider);
  return TutorStatusController(dio);
});
