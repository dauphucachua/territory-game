import 'package:flutter/material.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/view/widgets/custom_elements.dart';

/// A simple dialog to display the rules in plain text.
class RulesDialog extends StatelessWidget {
  const RulesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.darkBlue,
      child: Padding(
        padding: EdgeInsets.all(40.0),
        child: Column(
          children: [
            TitleText(text: "Rules"),
            SizedBox(height: 20.0),
            // Scrollable rules
            Container(
              height: 525,
              width: 800,
              child: SingleChildScrollView(
                child: Text(
                  AppRules.rules,
                  style: TextStyle(
                    color: AppColors.opaqueWhite,
                    fontSize: 16
                  ),
                  textAlign: .left,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Exit btuton
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Exit",
                style: TextStyle(
                  fontSize: 18.0
                ))
            )
          ]
        )
      )
    );
  }
}