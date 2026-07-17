import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:territory_game/model/game_user.dart";

class FirebaseAuthService extends ChangeNotifier {
  final firebaseAuth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  GameUser? activeUser;

  FirebaseAuthService({
    this.activeUser,
  });

  Future<void> login(String email, String password) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email, 
      password: password
    );

    print("Credential on login: ${credential.user!.uid}");
    
    final userDoc = await db.collection("users").doc(credential.user!.uid).get();
    final userData = userDoc.data() as Map<String, dynamic>;

    activeUser = GameUser.fromJson(userData);
  }

  Future<void> register(String email, String password) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password
    );

   print("Credential on register: ${credential.user!.uid}");

    final newUser = GameUser.fromFirebaseCredential(credential);
    db.collection("users").doc(newUser.id).set(newUser.toJson());
  }

  Future<void> logout() async {
    await firebaseAuth.signOut();
    activeUser = null;
  }
}
