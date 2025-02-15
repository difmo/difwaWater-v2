import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Widget? icon; // Icon or any other widget
  final double borderRadius;
  final bool left;
  final double? width; // Nullable width, calculated dynamically if not provided
  final double? height; // Nullable height, calculated dynamically if not provided
  final Color? borderColor; // Optional border color
  final Color baseTextColor; // Base text color
  final double fontSize; // Font size

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.icon,
    this.borderRadius = 30.0,
    this.left = false,
    this.width,
    this.height, // Initialize height
    this.borderColor, // Initialize borderColor
    this.baseTextColor = Colors.black, // Initialize baseTextColor
    this.fontSize = 14.0, // Initialize fontSize
  });

  @override
  Widget build(BuildContext context) {
    final buttonWidth = width ?? 80;
    final buttonHeight = height ?? 35;
    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.all(0),
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide.none, // Apply border color if provided
          ),
          elevation: 0, // Button shadow
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (left && icon != null) ...[
              icon!, // Render the icon if provided
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: fontSize, // Use the provided font size
                fontWeight: FontWeight.bold,
                color: textColor != Colors.white ? textColor : baseTextColor, // Use baseTextColor if textColor is default
              ),
            ),
            if (!left && icon != null) ...[
              const SizedBox(width: 8),
              icon!, // Render the icon if provided
              const SizedBox(width: 8), // Space between icon and text
            ],
          ],
        ),
      ),
    );
  }
}
