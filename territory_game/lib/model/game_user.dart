import 'package:firebase_auth/firebase_auth.dart';

/// A data model for the users who play the game.
class GameUser {
  final String id;
  final String email;
  
  const GameUser({
    required this.id,
    required this.email,
  });

  factory GameUser.fromFirebaseCredential(UserCredential credential) {
    return GameUser(
      id: credential.user!.uid,
      email: credential.user!.email!
    );
  }
}