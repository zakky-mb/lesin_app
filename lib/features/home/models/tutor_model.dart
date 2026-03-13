// Cetakan Data Guru yang siap menerima JSON dari Laravel
class Tutor {
  final int id;
  final String name;
  final String subject;
  final String imageUrl;
  final double rating;
  final String price;

  Tutor({
    required this.id,
    required this.name,
    required this.subject,
    required this.imageUrl,
    required this.rating,
    required this.price,
  });

  // Fungsi ajaib untuk mengubah JSON dari Backend menjadi Object Dart
  factory Tutor.fromJson(Map<String, dynamic> json) {
    return Tutor(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Guru Tanpa Nama',
      subject: json['subject'] ?? 'Mata Pelajaran',
      // Jika backend tidak kirim foto, pakai foto default
      imageUrl: json['image_url'] ?? "https://i.pravatar.cc/150?img=11",
      // Konversi rating agar aman (kadang backend kirim integer, kadang double)
      rating: (json['rating'] ?? 0.0).toDouble(),
      price: json['price'] ?? 'Rp 0',
    );
  }
}
