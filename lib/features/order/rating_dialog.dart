import 'package:flutter/material.dart';

class RatingDialog extends StatefulWidget {
  final String tutorName;
  final String subject;

  const RatingDialog(
      {super.key, required this.tutorName, required this.subject});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _selectedStar = 0; // Simpan jumlah bintang yang dipilih
  final TextEditingController _reviewController = TextEditingController();
  bool _isLoading = false;

  void _submitReview() async {
    if (_selectedStar == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Pilih bintang dulu ya!"),
            backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulasi kirim data ke API Laravel
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.pop(context); // Tutup dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Terima kasih atas ulasanmu!"),
            backgroundColor: Colors.green),
      );
      // Nanti di sini bisa diarahkan kembali ke Halaman Home
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon & Judul
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.orange[50], shape: BoxShape.circle),
              child: const Icon(Icons.star, color: Colors.orange, size: 40),
            ),
            const SizedBox(height: 16),
            const Text("Sesi Les Selesai!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              "Bagaimana pengalaman belajarmu dengan ${widget.tutorName} untuk mapel ${widget.subject}?",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Bintang 1 - 5 (Bisa diklik)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _selectedStar ? Icons.star : Icons.star_border,
                    color: Colors.orange,
                    size: 36,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedStar = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 16),

            // Kolom Komentar
            TextField(
              controller: _reviewController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Tulis ulasanmu di sini (opsional)...",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Kirim
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitReview,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color(0xFFFF5E62)), // Pink
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Kirim Ulasan",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
