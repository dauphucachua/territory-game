import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:territory_game/model/game_user.dart";

class FirebaseAuthService extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GameUser? activeUser;

  Future<void> login(String email, String password) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email, 
      password: password
    );
    activeUser = GameUser.fromFirebaseCredential(credential);
  }

  Future<void> register(BuildContext context, String email, String password) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Account registered successfully for $email. Login now."),
            duration: Duration(
              seconds: 3
            )
          )
        );
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            duration: Duration(
              seconds: 3
            ),
          ),
        );
      } 
    }
  }

  Future<void> logout() async {
    await firebaseAuth.signOut();
    activeUser = null;
  }
}
