import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'api_service.dart';

/// Auth state manager — wraps Firebase Auth with role management.
///
/// On web: uses signInWithPopup.  On mobile: uses GoogleSignIn package.
/// In dev mode: falls back to X-Dev-UID header via signInDev.
class AuthService extends ChangeNotifier {
  // Singleton
  static final AuthService _instance = AuthService._();
  factory AuthService() => _instance;
  AuthService._() {
    // Mirror Firebase Auth state into this service
    FirebaseAuth.instance.authStateChanges().listen(_onFirebaseAuthChanged);
  }

  String? _uid;
  String? _displayName;
  String? _role;
  bool _firebaseSignedIn = false;

  String? get uid => _uid;
  String? get displayName => _displayName;
  String? get role => _role;
  bool get isLoggedIn => _uid != null;
  bool get firebaseSignedIn => _firebaseSignedIn;

  /// Dev fallback UID (matches the seeded Firestore document).
  static const String devUid = 'O7819DECnkbhkk0tlC1kZfpYdBg2';

  // ─── Firebase Auth state listener ─────────────────────────────────────────

  Future<void> _onFirebaseAuthChanged(User? user) async {
    if (user != null) {
      _uid = user.uid;
      _displayName = user.displayName ?? user.email ?? 'User';
      _firebaseSignedIn = true;
      final token = await user.getIdToken();
      ApiService().setToken(token!);
      ApiService().setUid(_uid!);

      // Ensure user exists in DB
      try {
        final profile = await ApiService().getProfile();
        if (profile == null || profile.name.isEmpty) {
          await ApiService().upsertProfile({
            'name': _displayName,
            'email': user.email ?? '',
            'photo_url': user.photoURL ?? '',
            'uid': _uid,
          });
        } else {
          _displayName = profile.name;
        }
      } catch (_) {}

      notifyListeners();
    }
  }

  // ─── Google Sign-In ────────────────────────────────────────────────────────

  /// Sign in with Google (real Firebase Auth).
  /// Returns the signed-in [User] or throws on failure.
  Future<User> signInWithGoogle() async {
    UserCredential cred;

    if (kIsWeb) {
      final provider = GoogleAuthProvider()
        ..setCustomParameters({'prompt': 'select_account'});
      cred = await FirebaseAuth.instance.signInWithPopup(provider);
    } else {
      // Mobile path via google_sign_in package
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) throw Exception('Google sign-in cancelled');
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      cred = await FirebaseAuth.instance.signInWithCredential(credential);
    }

    final user = cred.user!;
    _uid = user.uid;
    _displayName = user.displayName ?? user.email ?? 'User';
    _firebaseSignedIn = true;

    final token = await user.getIdToken();
    ApiService().setToken(token!);
    ApiService().setUid(_uid!);

    // Upsert user profile in Firestore via backend
    try {
      await ApiService().upsertProfile({
        'name': _displayName,
        'email': user.email ?? '',
        'photo_url': user.photoURL ?? '',
        'uid': _uid,
      });
    } catch (_) {
      // Backend might be initialising; not fatal
    }

    notifyListeners();
    return user;
  }

  // ─── Role selection ────────────────────────────────────────────────────────

  void setRole(String role) {
    _role = role;
    notifyListeners();
  }

  // ─── Dev bypass (prototype / testing) ─────────────────────────────────────

  /// Quick sign-in without Firebase Auth — uses X-Dev-UID header.
  Future<void> signInDev({required String role, String? uid}) async {
    _uid = uid ?? devUid;
    _role = role;
    _displayName = 'Dev User';
    _firebaseSignedIn = false;

    ApiService().setUid(_uid!);

    try {
      final profile = await ApiService().getProfile();
      if (profile != null && profile.name.isNotEmpty) {
        _displayName = profile.name;
      } else {
        // User not in DB — auto-create
        final created = await ApiService().upsertProfile({
          'name': 'Dev User',
          'email': 'dev@kitahack.app',
          'uid': _uid,
          'role': role,
        });
        if (created.name.isNotEmpty) {
          _displayName = created.name;
        }
      }
    } catch (_) {}

    notifyListeners();
  }

  // ─── Sign-out ──────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    if (!kIsWeb) await GoogleSignIn().signOut();
    _uid = null;
    _displayName = null;
    _role = null;
    _firebaseSignedIn = false;
    ApiService().clearUid();
    notifyListeners();
  }

  // ─── Token refresh ─────────────────────────────────────────────────────────

  Future<void> refreshToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final token = await user.getIdToken(true);
      ApiService().setToken(token!);
    }
  }
}

