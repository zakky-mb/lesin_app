import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'booking_controller.dart';

class BookingDetailPage extends ConsumerStatefulWidget {
  final String bookingId;
  final String status; // Misal: 'pending', 'ongoing', 'completed'

  const BookingDetailPage({
    super.key,
    required this.bookingId,
    required this.status,
  });

  @override
  ConsumerState<BookingDetailPage> createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends ConsumerState<BookingDetailPage> {
  // Fungsi memunculkan Pop-up Alasan (Modal Bottom Sheet)
  void _showCancelModal() {
    final reasonController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Biar modal bisa naik kalau keyboard muncul
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(context).viewInsets.bottom, // Hindari keyboard
            left: 24, right: 24, top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Batalkan Pesanan",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Beritahu kami alasanmu membatalkan pesanan ini."),
              const SizedBox(height: 16),

              // Input Alasan
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: "Contoh: Guru terlalu lama / Berubah pikiran",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Tombol Konfirmasi Cancel
              SizedBox(
                width: double.infinity,
                child: Consumer(builder: (context, ref, child) {
                  final isLoading =
                      ref.watch(bookingControllerProvider).isLoading;

                  return ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (reasonController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Alasan wajib diisi!")));
                              return;
                            }

                            // Panggil API Cancel
                            final success = await ref
                                .read(bookingControllerProvider.notifier)
                                .cancelOrder(
                                    widget.bookingId, reasonController.text);

                            if (success && context.mounted) {
                              Navigator.pop(context); // Tutup Modal
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Pesanan dibatalkan. Dana DP akan direfund."),
                                    backgroundColor: Colors.green),
                              );
                              // TODO: Refresh halaman / kembali ke Home
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Konfirmasi Batal"),
                  );
                }),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // LOGIC TAMPILAN TOMBOL BATAL DARI BACKEND
    final canCancel = ['pending', 'accepted', 'paid'].contains(widget.status);

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Pesanan")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order ID: ${widget.bookingId}",
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text("Status: ${widget.status.toUpperCase()}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 40),

            // Rincian Pesanan (Dummy)
            const Text("Guru: Pak Budi (Matematika)"),
            const Text("Total: Rp 55.000"),

            const Spacer(),

            // TOMBOL BATAL (HANYA MUNCUL JIKA MEMENUHI SYARAT)
            if (canCancel)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _showCancelModal,
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  label: const Text("Batalkan Pesanan",
                      style: TextStyle(color: Colors.red)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
