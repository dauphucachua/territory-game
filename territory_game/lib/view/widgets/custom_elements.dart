import 'package:flutter/material.dart';
import 'package:territory_game/constants/constants.dart';

/// Common elements for use in the UI.

class TitleText extends StatelessWidget {
  final String text;
  const TitleText({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text, 
      style: TextStyle(
        fontSize: 25.0,
        color: AppColors.opaqueWhite,
      ),
    );
  }
}

class SubtitleText extends StatelessWidget {
  final String text;
  const SubtitleText({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.opaqueWhite,
        fontSize: 20.0,
      ),
    );
  }
}

class ContentText extends StatelessWidget {
  const ContentText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: const Color.fromARGB(136, 255, 255, 255)
      ),
      textAlign: .center
            
    );
  }
}

class CloseWindowButton extends StatelessWidget {
  const CloseWindowButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      }, 
      icon: Icon(
        Icons.close, 
        color: AppColors.opaqueWhite
      ),
    );
  }
}

class LoaderWithText extends StatelessWidget {
  final String text;
  const LoaderWithText({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ContentText(text: text),
        SizedBox(width: 12.0),
        CircularProgressIndicator()
      ]
    );
  }
}
