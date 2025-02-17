import 'package:difwa/utils/theme_constant.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Widget? icon; 
  final double borderRadius;
  final bool left;
  final double? width;
  final double? height; 
  final Color? borderColor;
  final Color baseTextColor; 
  final double fontSize; 

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = ThemeConstants.primaryColorNew,
    this.textColor = Colors.white,
    this.icon,
    this.borderRadius = 30.0,
    this.left = false,
    this.width,
    this.height, 
    this.borderColor, 
    this.baseTextColor = Colors.black, 
    this.fontSize = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    final buttonWidth = width ?? 120;
    final buttonHeight = height ?? 40;
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
