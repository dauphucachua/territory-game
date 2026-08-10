import 'package:mocktail/mocktail.dart';
import 'package:territory_game/model/game_user.dart';
import 'package:territory_game/services/firebase_services/firebase_auth_service.dart';

/// A version of the FirebaseAuthService class that stores an active user without Firebase contact for testing.
class DummyFirebaseAuthService extends Mock implements FirebaseAuthService {
  @override
  GameUser? activeUser;

  DummyFirebaseAuthService({
    this.activeUser
  });
}