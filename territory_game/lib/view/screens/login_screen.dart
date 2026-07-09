import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/board.dart';
import 'package:territory_game/model/game_user.dart';
import 'package:territory_game/model/subject.dart';
import 'package:territory_game/services/chatbot_services/chatbot_api_provider.dart';
import 'package:territory_game/services/chatbot_services/chatbot_config.dart';
import 'package:territory_game/services/chatbot_services/mistral_api_service.dart';
import 'package:territory_game/view/screens/game_screen.dart';
import 'package:territory_game/view/widgets/custom_elements.dart';
import 'package:territory_game/view/widgets/game_screen/UI/dialogs/feedback_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  final Map<String, dynamic> exampleSubject = {
    "name": "Introduction to Programming",
    "topics": [
      {
          "name": "Variables",
          "week": 1,
          "subTopics": [
              "Naming",
              "Conventions",
              "Values"
          ]
      },
      {
          "name": "Functions",
          "week": 2,
          "subTopics": [
              "Scope",
              "Iteration"
          ]
      },
    ],
    "questionTypes": [
        "multipleChoice",
        "theory",
        "codingProblem",
        "codingExercise"
    ]
  };

  Future<UserCredential> login(String email, String password) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email, 
      password: password
    );
    return credential;
  }

  Future<void> register(String email, String password) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          duration: Duration(
            seconds: 3
          )
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 22, 41, 58),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 80, horizontal: 60),
          height: 600.0,
          width: 500.0,
          decoration: BoxDecoration(
            borderRadius: AppDimensions.cornerRadius,
            color: AppColors.darkBlue,
          ),
          child: Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .center,
            children: [
              TitleText(text: "Login"),
              SizedBox(height: 50.0),
              Row(
                mainAxisAlignment: .start,
                children: [
                  SizedBox(width: 20.0),
                  ContentText(text: "Email"),
                ],
              ),
              SizedBox(height: 4.0),
              EntryField(
                hideText: false,
                controller: emailController),
              SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: .start,
                children: [
                  SizedBox(width: 20.0),
                  ContentText(text: "Password"),
                ],
              ),
              SizedBox(height: 4.0),
              EntryField(
                hideText: true,
                controller: passwordController),
              SizedBox(height: 4.0),
              Row(
                mainAxisAlignment: .end,
                children: [
                  ContentText(text: "Forgot password?"),
                  SizedBox(width: 20.0),
                ],
              ),
              SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: .center,
                children: [
                  ElevatedButton(
                  
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: AppColors.opaqueWhite,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      
                    }
                  ),
                  SizedBox(width: 20.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.opaqueWhite,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: AppColors.blue,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      try {
                        final credential = await login(emailController.text, passwordController.text);
                        GameUser currentUser = GameUser.fromFirebaseCredential(credential);

                        Subject subject = Subject.fromJson(exampleSubject);

                        final board = Board(
                          rows: 10,
                          cols: 10
                        );

                        final ChatbotApiProvider chatbotProvider = ChatbotApiProvider();
                        final mistralClient = MistralApiService(
                          config: ChatbotConfig());
                        chatbotProvider.addChatbot(mistralClient);
                        
                        final gameController = GameController(
                          user: currentUser,
                          chatbotProvider: chatbotProvider,
                          board: board, 
                          subject: subject,
                          topic: subject.topics[0]
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => GameScreen(
                              gameController
                            ),
                          ),
                        );

                      } on FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                            duration: Duration(
                              seconds: 3
                            )
                          )
                        );
                      }
                    }
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EntryField extends StatelessWidget {
  bool hideText;
  TextEditingController controller;
  
  EntryField({
    required this.hideText,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: AppDimensions.cornerRadius,
        color: AppColors.blue,
      ),
      child: Center(
        child: TextField(
          controller: controller,
          obscureText: hideText,
          style: TextStyle(
            color: AppColors.opaqueWhite,
          ),
        ),
      )
    );
  }
}