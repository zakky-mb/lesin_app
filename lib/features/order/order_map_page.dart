import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class OrderMapPage extends StatefulWidget {
  const OrderMapPage({super.key});

  @override
  State<OrderMapPage> createState() => _OrderMapPageState();
}

class _OrderMapPageState extends State<OrderMapPage>
    with SingleTickerProviderStateMixin {
  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _kInitialPosition =
      CameraPosition(target: LatLng(-6.200000, 106.816666), zoom: 14);

  Set<Marker> _markers = {};
  bool _isSearching = true;

  // Controller untuk animasi radar berdenyut
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _getUserLocation();

    // Setup Animasi Denyut (Pulse)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false); // Ulangi terus menerus
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 16),
    ));

    _addDummyTutors(position);
  }

  void _addDummyTutors(Position userPos) {
    setState(() {
      _markers.add(Marker(
          markerId: const MarkerId('guru_1'),
          position: LatLng(userPos.latitude + 0.002, userPos.longitude + 0.002),
          infoWindow: const InfoWindow(title: 'Pak Budi')));

      // Setelah 4 detik mencari, pura-puranya guru ketemu!
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted) setState(() => _isSearching = false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kInitialPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),

          // Tombol Back
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context)),
            ),
          ),

          // PANEL BAWAH (RADAR ANIMATION)
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
                  if (_isSearching) ...[
                    // --- ANIMASI RADAR BERDENYUT ---
                    SizedBox(
                      height: 80,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Container(
                                width: 80 * _animationController.value,
                                height: 80 * _animationController.value,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFFF5E62).withOpacity(
                                      1.0 - _animationController.value),
                                ),
                              );
                            },
                          ),
                          const Icon(Icons.radar,
                              color: Color(0xFFFF5E62), size: 40),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text("Memindai Guru di Sekitarmu...",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const Text("Mohon tunggu sebentar",
                        style: TextStyle(color: Colors.grey)),
                  ] else ...[
                    // --- GURU DITEMUKAN ---
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 50),
                    const SizedBox(height: 12),
                    const Text("Yeay! Guru Ditemukan 🎉",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                    const SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              NetworkImage("https://i.pravatar.cc/150?img=11")),
                      title: const Text("Pak Budi",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text("Matematika • 500m dari sini"),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(12)),
                        child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, color: Colors.orange, size: 16),
                              Text(" 4.8",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange))
                            ]),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Masuk ke halaman Chat / Tracking Order
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5E62),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text("Hubungi Guru",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                    )
                  ]
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
