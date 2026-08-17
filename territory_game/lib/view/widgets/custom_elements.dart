import 'package:flutter/material.dart';
import 'package:territory_game/constants/constants.dart';

/// Common elements for use in the UI.

/// Text for use as a title.
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

/// Text for use as a subtitle.
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

/// Text for standard content.
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

/// An 'x' button for closing dialogs.
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

/// A CircularProgressIndicator that displays a message.
class LoaderWithText extends StatelessWidget {
  final String text;
  Color? color;

  LoaderWithText({
    required this.text,
    this.color = AppColors.opaqueWhite,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 14.0
          )
        ),
        SizedBox(width: 12.0),
        CircularProgressIndicator()
      ]
    );
  }
}
