import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider untuk simulasi tarik data dari Laravel (Endpoint GET /api/v1/history)
final historyListProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  // Simulasi nunggu server balas 1.5 detik
  await Future.delayed(const Duration(milliseconds: 1500));

  // Data JSON bohongan dari backend
  return [
    {
      "title": "Matematika - Pak Budi",
      "date": "12 Feb 2026 • Selesai",
      "price": "Rp 50.000",
      "status": "success"
    },
    {
      "title": "B. Inggris - Bu Siti",
      "date": "10 Feb 2026 • Selesai",
      "price": "Rp 75.000",
      "status": "success"
    },
    {
      "title": "Fisika - Kak Jojo",
      "date": "05 Feb 2026 • Dibatalkan",
      "price": "Rp 0",
      "status": "cancelled"
    },
  ];
});

class HistoryTab extends ConsumerWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pantau provider
    final asyncHistory = ref.watch(historyListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Riwayat Pesanan",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      // Gunakan .when untuk memisahkan Loading, Error, dan Data
      body: asyncHistory.when(
        loading: () => const Center(
            child: CircularProgressIndicator(
                color: Color(0xFFFF5E62))), // Loading Pink
        error: (err, stack) =>
            Center(child: Text("Gagal memuat riwayat: $err")),
        data: (history) {
          if (history.isEmpty) {
            return const Center(
                child: Text("Kamu belum pernah memesan guru les.",
                    style: TextStyle(color: Colors.grey)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              final isCancelled = item['status'] == 'cancelled';

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 0,
                color: const Color(0xFFF5F6F8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isCancelled
                          ? Colors.red.withOpacity(0.1)
                          : Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(isCancelled ? Icons.cancel : Icons.check_circle,
                        color: isCancelled ? Colors.red : Colors.green),
                  ),
                  title: Text(item['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(item['date']),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(isCancelled ? "Batal" : "Selesai",
                          style: TextStyle(
                              color: isCancelled ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(item['price'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            // Kalau batal, harganya dicoret
                            decoration:
                                isCancelled ? TextDecoration.lineThrough : null,
                          )),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
