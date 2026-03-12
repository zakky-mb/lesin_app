import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  // Minta izin akses email & profil
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  // Fungsi Login
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      // 1. Munculkan Pop-up Pilih Akun
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        // 2. Ambil Token (Penting buat Backend nanti)
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        print("=== LOGIN BERHASIL ===");
        print("Nama: ${googleUser.displayName}");
        print("Email: ${googleUser.email}");
        print("ID Token: ${googleAuth.idToken}"); // Ini kuncinya!

        return googleUser;
      }
      return null; // Kalau user batal milih akun
    } catch (error) {
      print("Google Sign In Error: $error");
      return null;
    }
  }

  // Fungsi Logout
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
