import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/model/game_user.dart';
import 'package:territory_game/view/screens/main_menu_screen.dart';
import 'package:territory_game/view/widgets/custom_elements.dart';

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

  Future<UserCredential> login(String email, String password) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email, 
      password: password
    );
    return credential;
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
                    onPressed: () async => register(
                      context, 
                      emailController.text,
                      passwordController.text
                    )
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

                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => MainMenuScreen(currentUser: currentUser)
                            ),
                          );
                        }
                      } on FirebaseAuthException catch (e) {
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
  final bool hideText;
  final TextEditingController controller;
  
  const EntryField({
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