// Ini adalah "Cetakan" data Guru
class Tutor {
  final String name;
  final String subject; // Mata pelajaran
  final String imageUrl; // Foto profil
  final double rating;
  final String price; // Harga per sesi

  Tutor({
    required this.name,
    required this.subject,
    required this.imageUrl,
    required this.rating,
    required this.price,
  });
}
