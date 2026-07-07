import 'package:flutter/material.dart';

/// Common elements for use in dialog boxes.


class DialogSubtitleText extends StatelessWidget {
  final String text;
  const DialogSubtitleText({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: const Color.fromARGB(164, 255, 255, 255),
        fontSize: 20.0,
      ),
    );
  }
}

class DialogTitleText extends StatelessWidget {
  final String text;
  const DialogTitleText({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text, 
      style: TextStyle(
        fontSize: 25.0,
        color: const Color.fromARGB(164, 255, 255, 255),
      ),
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
        color: const Color.fromARGB(139, 255, 255, 255)
      ),
    );
  }
}

