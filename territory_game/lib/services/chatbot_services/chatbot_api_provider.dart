import 'package:territory_game/services/chatbot_services/chatbot_api_service.dart';

/// A class that provides access to various chatbots' API services through their API service interface.
/// 
/// It contains a list for adding chatbot models, so that multiple models can be available within the same game.
/// This allows for switching between models if one goes down, or if the token limit is reached, etc.
/// This class can be expanded to include this switching logic, changing the currentChatbotIndex when necessary.
class ChatbotApiProvider {
  final List<ChatbotApiService> _chatbotList = [];
  int currentChatbotIndex = 0;

  ChatbotApiProvider();

  /// Adds a chatbot's API service to the list.
  void addChatbot(ChatbotApiService chatbot) {
    _chatbotList.add(chatbot);
  }

  /// Uses the currentChatbotIndex to return the active chatbot's API service.'
  ChatbotApiService get chatbot => _chatbotList[currentChatbotIndex];

  

}