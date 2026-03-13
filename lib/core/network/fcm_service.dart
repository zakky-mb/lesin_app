// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../main.dart'; // Import navigatorKey
import '../../features/tutor/incoming_order_page.dart'; // Halaman order masuk

class FCMService {
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Fungsi untuk inisialisasi saat aplikasi baru buka
  void init() async {
    /* 
    // 1. Minta Izin Notifikasi ke User
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Izin Notifikasi Diberikan!');
      
      // 2. Ambil Token HP ini (Kirim token ini ke teman Backend kamu!)
      String? token = await _firebaseMessaging.getToken();
      print("TOKEN HP INI (FCM): $token");

      // 3. Dengarkan Pesan Masuk saat aplikasi sedang dibuka (Foreground)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("Menerima pesan: ${message.notification?.title}");
        
        // JIKA PESAN BERUPA ORDER BARU -> MUNCULKAN HALAMAN INCOMING ORDER
        if (message.data['type'] == 'new_order') {
          _triggerIncomingOrderScreen();
        }
      });
    }
    */
  }

  // Fungsi ajaib memunculkan layar order
  void _triggerIncomingOrderScreen() {
    // Membuka halaman IncomingOrderPage tanpa butuh BuildContext (Pakai Global Key)
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.push(
        MaterialPageRoute(builder: (context) => const IncomingOrderPage()),
      );
    }
  }

  // --- FUNGSI SIMULASI UNTUK TESTING ---
  // Karena Firebase belum disetup, kita buat fungsi pemicu palsu untuk testing
  void simulateIncomingOrder() {
    print("🔔 SIMULASI: Menerima order dari Backend...");
    _triggerIncomingOrderScreen();
  }
}

// Bikin instance service-nya
final fcmService = FCMService();
