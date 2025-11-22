import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService({FirebaseAuth? firebaseAuth}) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  User? get getUser => _firebaseAuth.currentUser;
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  Future<User?> signUp(String email, String password) async {
    final cred = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return cred.user;
  }

  Future<User?> signIn(String email, String password) async {
    final cred = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return cred.user;
  }

  Future<void> signOut() => _firebaseAuth.signOut();
}
