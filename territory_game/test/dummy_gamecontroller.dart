import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/game.dart';
import 'package:territory_game/model/property.dart';
import 'package:territory_game/model/quiz_models/quiz.dart';
import 'package:territory_game/model/quiz_models/quiz_feedback.dart';
import 'package:territory_game/model/topic.dart';
import 'package:territory_game/services/chatbot_services/chatbot_api_provider.dart';
import 'package:territory_game/services/chatbot_services/chatbot_api_service.dart';

class DummyGameController {
  final ChatbotApiProvider chatbotProvider;
  final Game game;

  
  const DummyGameController({
    required this.chatbotProvider,
    required this.game
  });

  String get topicName => game.topic.name;
  Topic get topic => game.topic;
  List<String> get subTopics => game.topic.subTopics;
  ChatbotApiService get chatbot => chatbotProvider.chatbot;
  List<List<dynamic>> get boardState => game.board.state;
  Board get board => game.board;

  Map<String, Map<String, int>> subTopicCountPerArea() {
    final subTopicCounts = {};
    
    final areaCounts = {
      "The Dojo": 0,
      "The Arena": 0,
      "The Battleground": 0,
      "The Pit": 0
    };

    for (String subTopic in topic.subTopics) {
      subTopicCounts[subTopic] = areaCounts;
    }

    for (List row in boardState) {
      for (var item in row) {
        if (item is Property) {
          final propertySubTopic = item.quiz.subTopic;
          final propertyArea = item.boardArea;
          subTopicCounts[propertySubTopic][propertyArea] += 1;
        }
      }
    }

    return Map<String, Map<String, int>>.from(subTopicCounts);
  }

  bool subTopicLimitSurpassed(Property property, {required int row, required int col}) {
    final intendedArea = board.getBoardArea(row, col);
    final subTopic = property.quiz.subTopic;
    final limits = board.areaLimits;
    final currentAreaCounts = subTopicCountPerArea();

    if (currentAreaCounts[subTopic]![intendedArea]! + 1 > limits[intendedArea]!) {
      return true;
    } else {
      return false;
    }
  }


  /// Gets a Quiz object with the specified parameters from the active chatbot.
  Future<Quiz> getQuiz(String subTopic, String questionType, int questionCount, String difficulty) async {
    final questionHistory = game.history.questionHistory[questionType]!;

    Map<String, dynamic>? quizJson = await chatbot.getQuizJson(
      game.topic, 
      subTopic, 
      questionType, 
      questionCount,
      questionHistory,
      difficulty
    );

    if (quizJson != null) {
      return Quiz.fromJson(quizJson);
    } else {
      throw "Failed to get quiz from chatbot";
    }
  }

  /// Gets a QuizFeedback object based on a completed quiz from the active chatbot.
  Future<QuizFeedback> getFeedback(Quiz quiz) async {
    Map<String, dynamic>? quizFeedbackJson = await chatbot.getFeedbackJson(quiz);
    print(quizFeedbackJson.toString());
    if (quizFeedbackJson != null) {
      return QuizFeedback.fromJson(quizFeedbackJson);
    } else {
      throw "Failed to get feedback from chatbot";
    }
  }
}