import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF5975F1); // Opaque color (Blueish tone)
  static const Color secondary =
      Color(0xFFDDE1F5); // Opaque color (Light blueish tone)
  static const Color inactive = Color.fromARGB(159, 206, 206, 206);
  static const Color myblack = Color.fromARGB(255, 0, 0, 0);
  static const Color blackLight = Color.fromARGB(255, 26, 25, 25);
  static const Color blackLight2 = Color.fromARGB(255, 22, 21, 21);
  static const Color mywhite = Colors.white;
  static const Color myGreen = Colors.green;
  static const Color buttonbgColor = Color(0xFF096FCE);
  static const Color buttontextcolor = Color(0xFF4878BB);
  static const Color inputfield = Color(0xFFF3743D);


  static var primaryColor = const Color(0xFF6256CA);

  static const Color textBlack = Color.fromARGB(255, 22, 21, 21);
  static const Color darkGrey = Color.fromARGB(179, 132, 132, 132);
  static const Color redColor = Color.fromARGB(255, 240, 31, 31);

  AppColors(Color primaryColor);

   // Custom Gradient for Button Background
  static const LinearGradient buttonBgGradient = LinearGradient(
    colors: [Color(0xFFFFA279), Color(0xFFF3743D)], // Custom gradient colors
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Custom Gradient for Background
  static const LinearGradient iconbg = LinearGradient(
    colors: [Color(0xFFFFA082), Color(0xFFF3743D)], // Custom gradient colors
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Color iconbgStart = Color(0xFFFFA082); // Start color
  static const Color iconbgEnd = Color(0xFFF3743D);   // End color
}
