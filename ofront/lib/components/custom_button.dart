import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onPress, required this.label});
  final Function onPress;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => onPress(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).highlightColor, // Background color
          foregroundColor: Colors.white, // Text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // BorderRadius
          ),
        ),
        child: Text(label));
  }
}
