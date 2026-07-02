import 'package:flutter/material.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/view/widgets/board_widget.dart';

class GameScreen extends StatelessWidget {
  final GameController gameController;
  const GameScreen(this.gameController, {super.key});

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
              child: BoardWidget(board: gameController.board)
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
                      child: Text("Active selection goes here", style: TextStyle(color: Colors.white38)),
                    ),
                    Divider(),
                    SizedBox(
                      height: 150,
                      child: Text("Activity/chat goes here", style: TextStyle(color: Colors.white38))
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
                          color: Colors.white38,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      onPressed: () {
                        // Open dialog to choose property topic 
                      }
                    )
                  ]
                ),
              )
            ),
          )
        ],
      ),
    );
  }
}