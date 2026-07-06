import 'package:flutter/material.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/view/widgets/game_screen/UI/dialogs/add_property_dialog.dart';

class MainSidebarWidget extends StatefulWidget {
  final GameController gameController;
  const MainSidebarWidget(this.gameController, {super.key});

  @override
  State<MainSidebarWidget> createState() => _MainSidebarWidgetState();
}

class _MainSidebarWidgetState extends State<MainSidebarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 33, 48, 68),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0)
        ),
      ),
      child: Column(
        mainAxisAlignment: .start,
        spacing: 5,
        children: [
          // Top tabs - need converted to buttons with a currentTab variable
          Row(
            mainAxisAlignment: .spaceEvenly,
            children: [
              Text("My properties", style: TextStyle(color: Colors.white38),),
              Text("Activity", style: TextStyle(color: Colors.white38)),
            ],
          ),
          Divider(),
          // Active selection area - needs a valuenotifier
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
            child: Text(
              "+ New property", 
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
                  return AddPropertyDialog(widget.gameController);
                }
              );
            }
          ),
        ],
      ),
    );
  }
}