import 'package:flutter/material.dart';

const Color blueClr = Color(0xFF0341fc);
const Color yellowClr = Color(0xFFfcbe03);
const Color redClr = Color(0xFFfc0303);
const Color pinkClr = Color(0xFFfc0373);
const Color greenClr = Color(0xFF3cfc03);
const Color brownClr = Color(0xFF5c0000);
const Color purpleClr = Color(0xFFa200b1);
const Color white = Colors.white;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

const primaryClr = white;

class Themes {
  static final light = ThemeData(
    primaryColor: primaryClr,
    brightness: Brightness.light,
  );

  static final dark = ThemeData(
    primaryColor: Color(0xFFfcbe03),
    brightness: Brightness.dark,
  );
}
