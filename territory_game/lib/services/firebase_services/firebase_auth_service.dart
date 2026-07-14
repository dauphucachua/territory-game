import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:territory_game/model/game_user.dart";

class FirebaseAuthService extends ChangeNotifier {
  final firebaseAuth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  GameUser? activeUser;

  Future<void> login(String email, String password) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email, 
      password: password
    );
    activeUser = GameUser.fromFirebaseCredential(credential);
  }

  Future<void> register(String email, String password) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password
    );
    final newUser = GameUser.fromFirebaseCredential(credential);
    db.collection("users").add(newUser.toJson());
  }

  Future<void> logout() async {
    await firebaseAuth.signOut();
    activeUser = null;
  }
}
