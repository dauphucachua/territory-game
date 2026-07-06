import 'package:territory_game/services/chatbot_api.dart';

class ChatbotApiProvider {
  final List<ChatbotApiService> _chatbotList = [];
  int currentChatbotIndex = 0;

  ChatbotApiProvider();

  void addChatbot(ChatbotApiService chatbot) {
    _chatbotList.add(chatbot);
  }

  ChatbotApiService get chatbot => _chatbotList[currentChatbotIndex];

  

}