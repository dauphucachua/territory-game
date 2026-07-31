import 'package:flutter/material.dart';
import 'package:territory_game/constants/constants.dart';
import 'package:territory_game/view/widgets/custom_elements.dart';

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
            Container(
              height: 500,
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
            )
            
          ]
        )
      )
    );
  }
}