import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:territory_game/model/game_user.dart";
import "package:territory_game/repositories/user_repository.dart";

/// A service class that allows access to Firebase authorization functionality.
///
/// It also updates the Firestore database with authorization-related changes.
class FirebaseAuthService extends ChangeNotifier {
  final firebaseAuth = FirebaseAuth.instance;
  final UserRepository userRepository;
  // Identifies the active user of the application.
  GameUser? activeUser;

  FirebaseAuthService({this.activeUser, required this.userRepository});

  /// Logs a user in with email and password and updates the activeUser field with their details.
  Future<void> login(String email, String password) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUser = credential.user;
    if (firebaseUser == null) {
      throw StateError("Firebase sign-in completed without a user.");
    }
    
    activeUser = await userRepository.loadUser(firebaseUser.uid);
    notifyListeners();
  }

  /// Registers a new user with email and password and updates the Firestore "users" collection with their details.
  Future<void> register(String email, String password) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUser = credential.user;
    if (firebaseUser == null) {
      throw StateError("Firebase registration completed without a user.");
    }

    final newUser = GameUser(
      id: firebaseUser.uid,
      email: email,
    );
    await userRepository.saveUser(newUser);
  }

  /// Logs out the active user.
  Future<void> logout() async {
    await firebaseAuth.signOut();
    activeUser = null;
    notifyListeners();
  }
}
