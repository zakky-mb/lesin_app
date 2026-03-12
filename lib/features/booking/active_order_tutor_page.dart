import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'booking_controller.dart';

class ActiveOrderTutorPage extends ConsumerStatefulWidget {
  final String bookingId;
  final String initialStatus; // 'accepted' (Otw) atau 'ongoing' (Sedang ngajar)

  const ActiveOrderTutorPage({
    super.key,
    required this.bookingId,
    required this.initialStatus,
  });

  @override
  ConsumerState<ActiveOrderTutorPage> createState() =>
      _ActiveOrderTutorPageState();
}

class _ActiveOrderTutorPageState extends ConsumerState<ActiveOrderTutorPage> {
  late String currentStatus;
  int? remainingPayment; // Untuk simpan tagihan dari backend

  @override
  void initState() {
    super.initState();
    currentStatus = widget.initialStatus;
  }

  // Fungsi dinamis saat tombol diklik
  Future<void> _handleUpdateStatus(String newStatus) async {
    final result = await ref
        .read(bookingControllerProvider.notifier)
        .updateTracking(widget.bookingId, newStatus);

    if (result != null && mounted) {
      setState(() {
        currentStatus = newStatus; // Update status di layar

        // Simulasi nangkep response dari Laravel: { "remaining_payment": 50000 }
        // Kalau pakai API asli, un-comment baris di bawah ini:
        // remainingPayment = result['remaining_payment'];

        // MOCKING SEMENTARA (Anggap aja backend ngirim sisa bayar Rp 55.000):
        if (newStatus == 'completed') {
          remainingPayment = 55000; // Coba ubah ke 0 untuk tes Lunas
        }
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Gagal update status!"),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(bookingControllerProvider).isLoading;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text("Pekerjaan Aktif")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 1. KARTU INFO MURID
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: const Row(
                children: [
                  CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          NetworkImage("https://i.pravatar.cc/150?img=33")),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Budi Santoso (SMA)",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("Matematika Dasar",
                            style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 8),
                        Text("📍 Jl. Merdeka No.45 (2.5 km)",
                            style: TextStyle(color: Colors.blue, fontSize: 12)),
                      ],
                    ),
                  ),
                  Icon(Icons.directions_car, color: Colors.blue, size: 30),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 2. STATUS TRACKING
            const Text("Status Saat Ini:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              currentStatus.toUpperCase(),
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: currentStatus == 'completed'
                      ? Colors.green
                      : Colors.orange),
            ),

            const SizedBox(height: 30),

            // 3. TAMPILAN HARGA / TAGIHAN (MUNCUL KALAU COMPLETED)
            if (currentStatus == 'completed' && remainingPayment != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color:
                      remainingPayment! > 0 ? Colors.red[50] : Colors.green[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: remainingPayment! > 0 ? Colors.red : Colors.green),
                ),
                child: Column(
                  children: [
                    Icon(
                        remainingPayment! > 0
                            ? Icons.warning_amber_rounded
                            : Icons.check_circle,
                        color:
                            remainingPayment! > 0 ? Colors.red : Colors.green,
                        size: 40),
                    const SizedBox(height: 12),
                    if (remainingPayment! > 0) ...[
                      const Text("TAGIH TUNAI KE MURID",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      Text("Rp ${remainingPayment!}",
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 32,
                              fontWeight: FontWeight.bold)),
                    ] else ...[
                      const Text("PEMBAYARAN LUNAS (DIGITAL)",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      const Text("Tidak perlu menagih tunai",
                          style: TextStyle(color: Colors.green)),
                    ]
                  ],
                ),
              ),

            const Spacer(),

            // 4. TOMBOL AKSI DINAMIS
            if (currentStatus != 'completed')
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          // Logic Tombol:
                          // Jika 'accepted' -> klik -> jadi 'arrived' (ongoing)
                          // Jika 'ongoing' -> klik -> jadi 'completed'
                          if (currentStatus == 'accepted') {
                            _handleUpdateStatus(
                                'arrived'); // Di backend mungkin 'arrived' otomatis mengubah order jadi ongoing
                          } else if (currentStatus == 'arrived' ||
                              currentStatus == 'ongoing') {
                            _handleUpdateStatus('completed');
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentStatus == 'accepted'
                        ? Colors.blue
                        : Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          currentStatus == 'accepted'
                              ? "Saya Sudah Sampai"
                              : "Selesai Mengajar",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
