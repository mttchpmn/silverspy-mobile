import 'package:flutter/material.dart';

enum ButtonType { elevated, outlined }

class FullWidthButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final ButtonType buttonType;

  const FullWidthButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.buttonType = ButtonType.elevated});

  @override
  Widget build(BuildContext context) {
    return buttonType == ButtonType.elevated
        ? Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    minimumSize: const Size.fromHeight(50)),
                onPressed: () {
                  onPressed();
                },
                child: Text(label)),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: OutlinedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)),
                onPressed: () {
                  onPressed();
                },
                child: Text(label)),
          );
  }
}
