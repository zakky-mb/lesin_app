import 'dart:async';
import 'package:flutter/material.dart';

// 👇 INI DIA KUNCI JAWABANNYA (Wajib di-import biar gak merah) 👇
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../booking/chat_page.dart';
import '../home/home_page.dart';

class ActiveOrderStudentPage extends StatefulWidget {
  final String tutorName;
  final String bookingId;

  const ActiveOrderStudentPage({
    super.key,
    required this.tutorName,
    required this.bookingId,
  });

  @override
  State<ActiveOrderStudentPage> createState() => _ActiveOrderStudentPageState();
}

class _ActiveOrderStudentPageState extends State<ActiveOrderStudentPage> {
  final Completer<GoogleMapController> _controller = Completer();

  // Posisi dummy (Pura-puranya ini rumah murid)
  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(-6.200000, 106.816666),
    zoom: 15.5,
  );

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _setMarkers();
  }

  void _setMarkers() {
    // Marker Murid (Rumah)
    _markers.add(
      const Marker(
        markerId: MarkerId('student'),
        position: LatLng(-6.200000, 106.816666),
        infoWindow: InfoWindow(title: 'Lokasi Saya'),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    // Marker Guru (Pura-puranya lagi OTW)
    _markers.add(
      Marker(
        markerId: const MarkerId('tutor'),
        position: const LatLng(-6.195000, 106.810000),
        infoWindow: InfoWindow(
            title: widget.tutorName, snippet: 'Sedang menuju lokasimu'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
  }

  // Fungsi Batal Order (Pura-pura)
  void _cancelOrder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Batalkan Pesanan?"),
        content: const Text(
            "Apakah kamu yakin ingin membatalkan guru yang sedang menuju ke lokasimu?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("TIDAK", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              // Tutup dialog, lalu kembali ke Home
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Pesanan Dibatalkan"),
                    backgroundColor: Colors.red),
              );
            },
            child: const Text("YA, BATALKAN",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. PETA FULL SCREEN
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kInitialPosition,
            markers: _markers,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),

          // 2. TOMBOL BACK (Di kiri atas)
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // 3. STATUS BAR (Di atas, tengah)
          Positioned(
            top: 50,
            left: 70,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10)
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Color(0xFFFF5E62)),
                  ),
                  const SizedBox(width: 12),
                  Text("${widget.tutorName} OTW Lokasimu (5 mnt)",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),

          // 4. BOTTOM SHEET (Info Guru & Action)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 20, spreadRadius: 5)
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Info Guru
                  Row(
                    children: [
                      const CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              NetworkImage("https://i.pravatar.cc/150?img=11")),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.tutorName,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const Text("Matematika • B 1234 XYZ",
                                style: TextStyle(color: Colors.grey)),
                            const Row(
                              children: [
                                Icon(Icons.star,
                                    color: Colors.orange, size: 16),
                                Text(" 4.8",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange)),
                              ],
                            )
                          ],
                        ),
                      ),
                      // Ikon Telepon
                      CircleAvatar(
                        backgroundColor: Colors.green[50],
                        child: IconButton(
                          icon: const Icon(Icons.phone, color: Colors.green),
                          onPressed: () {},
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Tombol Chat & Batal
                  Row(
                    children: [
                      // Tombol Batal
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: _cancelOrder,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text("Batal",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Tombol Chat
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  bookingId: widget.bookingId,
                                  peerName: widget.tutorName,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.chat),
                          label: const Text("Chat Guru",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF5E62),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
