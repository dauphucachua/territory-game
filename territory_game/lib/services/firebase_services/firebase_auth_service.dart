import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:territory_game/model/game_user.dart";

/// A service class that allows access to Firebase authorization functionality.
/// 
/// It also updates the Firestore database with authorization-related changes. 
class FirebaseAuthService extends ChangeNotifier {
  final firebaseAuth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  // Identifies the active user of the application.
  GameUser? activeUser;

  FirebaseAuthService({
    this.activeUser,
  });

  /// Logs a user in with email and password and updates the activeUser field with their details.
  Future<void> login(String email, String password) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email, 
      password: password
    );
    
    final userDoc = await db.collection("users").doc(credential.user!.uid).get();
    final userData = userDoc.data() as Map<String, dynamic>;

    activeUser = GameUser.fromJson(userData);
  }

  /// Registers a new user with email and password and updates the Firestore "users" collection with their details.
  Future<void> register(String email, String password) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password
    );

    final newUser = GameUser.fromFirebaseCredential(credential);
    db.collection("users").doc(newUser.id).set(newUser.toJson());
  }

  /// Logs out the active user.
  Future<void> logout() async {
    await firebaseAuth.signOut();
    activeUser = null;
  }
}
