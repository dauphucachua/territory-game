import 'package:flutter/material.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/view/widgets/board_widget.dart';

class GameScreen extends StatefulWidget {
  final GameController gameController;
  const GameScreen(this.gameController, {super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {

          }
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(50.0),
              child: BoardWidget(board: widget.gameController.board)
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 300,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 33, 48, 68),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0)
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: .start,
                  spacing: 5,
                  children: [
                    Row(
                      mainAxisAlignment: .spaceEvenly,
                      children: [
                        Text("My properties", style: TextStyle(color: Colors.white38),),
                        Text("Activity", style: TextStyle(color: Colors.white38)),
                      ],
                    ),
                    Divider(),
                    SizedBox(
                      height: 100,
                      child: Text("Active selection goes here", style: TextStyle(color: const Color.fromARGB(255, 57, 92, 109),)),
                    ),
                    Divider(),
                    SizedBox(
                      height: 150,
                      child: Text("Activity/chat goes here", style: TextStyle(color: const Color.fromARGB(255, 57, 92, 109),))
                    ),
                    Divider(),                
                    ElevatedButton(      
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 57, 92, 109),
                        elevation: 2.0,
                        fixedSize: Size(150, 50)
                      ),
                      child: Text("+ New property", 
                        style: TextStyle(
                          color: const Color.fromARGB(164, 255, 255, 255),
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)
                              ),
                              backgroundColor: const Color.fromARGB(255, 33, 48, 68),
                              insetPadding: EdgeInsets.symmetric(
                                horizontal: 30.0,
                                vertical: 10.0
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: .start,
                                      children: [
                                        Text(
                                          "New property", 
                                          style: TextStyle(
                                            fontSize: 25.0,
                                            color: const Color.fromARGB(164, 255, 255, 255),
                                          ),
                                        ),
                                      ]
                                    ),
                                    Divider(),
                                    SizedBox(height: 20.0),
                                    Text(
                                      "Select a topic",
                                      style: TextStyle(
                                        color: const Color.fromARGB(164, 255, 255, 255),
                                        fontSize: 20.0,
                                      )

                                    ),
                                    SizedBox(
                                      height: 150,
                                      child: ListView.builder(
                                        scrollDirection: .horizontal,
                                        itemCount: widget.gameController.subTopics.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Card(
                                              color: const Color.fromARGB(255, 57, 92, 109),
                                              elevation: 2.0,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: 150,
                                                  child: Text(
                                                    widget.gameController.subTopics[index],
                                                    style: TextStyle(
                                                      color: const Color.fromARGB(164, 255, 255, 255),
                                                      fontSize: 15.0,
                                                    )
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    Divider(),
                                    SizedBox(height: 20.0),
                                    Text(
                                      "Select a question type",
                                      style: TextStyle(
                                        color: const Color.fromARGB(164, 255, 255, 255),
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 100,
                                      child: ListView(
                                        scrollDirection: .horizontal,
                                        children: [
                                          for (int i = 0; i < 5; i++)
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Card(
                                              color: const Color.fromARGB(255, 57, 92, 109),
                                              elevation: 2.0,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: 150,
                                                  child: Text(
                                                    "Question Type",
                                                    style: TextStyle(
                                                      color: const Color.fromARGB(164, 255, 255, 255),
                                                      fontSize: 15.0,
                                                    )
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],

                                      ),
                                    ),
                                    Spacer(),
                                    Row(
                                      mainAxisAlignment: .end,
                                      children: [
                                        ElevatedButton(      
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color.fromARGB(255, 57, 92, 109),
                                            elevation: 2.0,
                                            fixedSize: Size(150, 50)
                                          ),
                                          child: Text(
                                            "Start quiz", 
                                            style: TextStyle(
                                              color: const Color.fromARGB(164, 255, 255, 255),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          onPressed: () {
                                            // Close dialog
                                            // Open question dialog
                                          }
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            );
                          }
                        );
                      }
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}