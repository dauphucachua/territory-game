import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/controller/game_controller.dart';
import 'package:territory_game/model/property.dart';
import 'package:territory_game/view/widgets/custom_elements.dart';
import 'package:territory_game/view/widgets/game_screen/UI/dialogs/add_property_dialog.dart';
import 'package:territory_game/view/widgets/game_screen/property_icon.dart';

enum TabStatus {activityTab, propertiesTab}

class MainSidebarWidget extends StatefulWidget {
  const MainSidebarWidget({super.key});

  @override
  State<MainSidebarWidget> createState() => _MainSidebarWidgetState();
}

class _MainSidebarWidgetState extends State<MainSidebarWidget> {
  TabStatus activeTab = TabStatus.propertiesTab;
  

  @override
  Widget build(BuildContext context) {
    final gameController = context.watch<GameController>();
    final activePlayer = gameController.activePlayer;

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
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: activeTab == TabStatus.propertiesTab 
                  ? AppColors.blue
                  : null
                ),
                child: Text("My properties"),
                onPressed: () => setState(() {activeTab = TabStatus.propertiesTab;})
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: activeTab == TabStatus.activityTab 
                  ? AppColors.blue
                  : null
                ),
                child: Text("Activity"),
                onPressed: () => setState(() {activeTab = TabStatus.activityTab;})
              ),
            ],
          ),
          Divider(),
          activeTab == TabStatus.activityTab ? ActivityTabContent() : PropertiesTabContent(),
          Divider(),
          Spacer(),                
          ElevatedButton(      
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 57, 92, 109),
              elevation: 2.0,
              fixedSize: Size(175, 50)
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
              // If the active player has a property to place, block them from creating a new one.
              activePlayer.mustPlaceProperty 
                ? ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("You must place your property before adding a new one.")
                  )
                )
                : showDialog(
                  context: context,
                  builder: (newContext) => ChangeNotifierProvider.value(
                    value: context.read<GameController>(),
                    child: AddPropertyDialog()
                  )
                );
            }
          ),
          SizedBox(height: 10)
        ],
      ),
    );
  }
}

class ActivityTabContent extends StatelessWidget {
  const ActivityTabContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final activityHistory = context.watch<GameController>().game.history.activityHistory;

    return Column(
      children: [
        SizedBox(
          height: 100,
          child: Text("Active selection goes here", style: TextStyle(color: const Color.fromARGB(255, 57, 92, 109),)),
        ),
        Divider(),
        SizedBox(
          height: MediaQuery.heightOf(context) - 400,
          child: Column(
            children: [
              ContentText(text: "Activity"),
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  padding: .all(12.0),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundCream,
                    borderRadius: AppDimensions.cornerRadius
                  ),
                  child: ListView.builder(
                    scrollDirection: .vertical,
                    itemCount: activityHistory.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const .all(2.0),
                      child: Text(
                        activityHistory[index],
                        style: TextStyle(
                          fontSize: 12
                        )
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PropertiesTabContent extends StatelessWidget {
  const PropertiesTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final gameController = context.watch<GameController>();
    final activePlayer = gameController.activePlayer;
    final playerProperties = activePlayer.properties;
    final propertyToPlace = activePlayer.propertyToPlace;
    final playerColor = activePlayer.propertyColor;

    return Column(
      children: [
        ContentText(text: "Property to place"),
        propertyToPlace == null
        ? Text(
          "None\nClick '+ New property' to load a property",
          style: TextStyle(
            color: AppColors.opaqueWhite,
            fontSize: 12,
            fontStyle: FontStyle.italic
          ),
          textAlign: .center,
        )
        : Column(
          children: [
            Draggable(
              data: propertyToPlace,
              feedback: PropertyIcon(color: playerColor), // Needs to be player.color             
              child: PropertyListCard(
                property: propertyToPlace,
                iconColor: playerColor
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "Click and drag property to place it",
              style: TextStyle(
                color: AppColors.opaqueWhite,
                fontSize: 12,
                fontStyle: FontStyle.italic
              ),
              textAlign: .center,
            ),
          ],
        ),
        SizedBox(height: 10),
        Divider(),
        SizedBox(
          height: 400,
          width: MediaQuery.widthOf(context),
          child: ListView.builder(
            scrollDirection: .vertical,
            itemCount: playerProperties.length,
            itemBuilder: (context, index) {
              final property = playerProperties[index];
          
              return Padding(
                padding: const EdgeInsets.all(3.0),
                child: PropertyListCard(
                  property: property,
                  iconColor: playerColor
                ),
              );
            },       
          ),
        ),
      ],
    );
  }
}

class PropertyListCard extends StatelessWidget {
  const PropertyListCard({
    super.key,
    required this.property,
    required this.iconColor
  });

  final Property property;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .maxFinite,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: AppDimensions.cornerRadius,
        color: AppColors.blue,
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          PropertyIcon(
            color: iconColor, 
            width: 40, 
            height: 40,
            child: (property.row != null && property.col != null) 
              ? Text(
                "${property.humanCoord}",
                style: TextStyle(
                  color: iconColor == AppColors.propertyBlack 
                  ? AppColors.propertyWhite
                  : AppColors.propertyBlack,
                  fontSize: 10
                )
              )
              : null
          ),
          Column(
            crossAxisAlignment: .start,
            children: [             
              ContentText(text: property.quizType),
              ContentText(text: "${property.questionCount} questions")             
            ],
          ),
          HealthStat(health: property.health),
        ],
      ),
    );
  }
}

class HealthStat extends StatelessWidget {
  final int health;

  const HealthStat({
    super.key,
    required this.health,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [ 
        Icon(
          health <= 20 ? Icons.heart_broken : Icons.favorite,
          color: AppColors.heartRed),
        ContentText(
          text: "$health",  
        ),
      ],
    );
  }
}