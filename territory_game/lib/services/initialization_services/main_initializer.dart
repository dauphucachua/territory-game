import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:territory_game/repositories/firestore_game_repository.dart';
import 'package:territory_game/repositories/firestore_user_repository.dart';
import 'package:territory_game/repositories/game_repository.dart';
import 'package:territory_game/repositories/local_subject_repository.dart';
import 'package:territory_game/repositories/subject_repository.dart';
import 'package:territory_game/repositories/user_repository.dart';
import 'package:territory_game/services/chatbot_services/chatbot_api_provider.dart';
import 'package:territory_game/services/chatbot_services/chatbot_config.dart';
import 'package:territory_game/services/chatbot_services/gpt_api_service.dart';
import 'package:territory_game/services/chatbot_services/groq_api_service.dart';
import 'package:territory_game/services/chatbot_services/mistral_api_service.dart';
import 'package:territory_game/services/firebase_services/firebase_auth_service.dart';
import 'package:territory_game/services/initialization_services/game_builder.dart';
import 'package:territory_game/services/initialization_services/session_builder.dart';

class MainInitializer {
  MainInitializer();

  ChatbotApiProvider createChatbotProvider() {
    final config = ChatbotConfig();
    final groq = GroqApiService(config: config);
    final gpt = GptApiService(config: config);
    final mistral = MistralApiService(config: config);
    final chatbot = ChatbotApiProvider();
    chatbot.addChatbot(groq);
    chatbot.addChatbot(gpt);
    chatbot.addChatbot(mistral);
    return chatbot;
  }

  MultiProvider initializeMultiProvider(Widget child) {
    return MultiProvider(
      providers: [
        Provider<GameRepository>(
          create: (context) => FirestoreGameRepository(),
        ),
        Provider<UserRepository>(
          create: (context) => FirestoreUserRepository(),
        ),
        Provider<SubjectRepository>(
          create: (context) => LocalSubjectRepository(),
        ),
        ChangeNotifierProvider<FirebaseAuthService>(
          create: (context) => FirebaseAuthService(
            userRepository: context.read<UserRepository>()
          ),
        ), 
        Provider<SessionBuilder>(
          create: (context) => SessionBuilder(
            createChatbotProvider: createChatbotProvider,
            gameRepository: context.read<GameRepository>(),
            userRepository: context.read<UserRepository>(),
            firebaseAuth: context.read<FirebaseAuthService>(),
          ),
        ),
        Provider<GameBuilder>(
          create: (context) => GameBuilder(
            sessionBuilder: context.read<SessionBuilder>(), 
            firebaseAuth: context.read<FirebaseAuthService>(), 
            gameRepository: context.read<GameRepository>(), 
            userRepository: context.read<UserRepository>(),
          ),
        ),
      ],
      child: child
    );
  }  
}