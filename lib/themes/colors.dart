import 'package:flutter/material.dart';

const int _primaryPrimaryColor = 0xFFEBEFF3;
const MaterialColor primaryColor = MaterialColor(
  _primaryPrimaryColor,
  <int, Color>{
    50: Color(0xFFF6F8FA),
    100: Color(_primaryPrimaryColor),
    200: Color(0xFFD2DDE5),
    300: Color(0xFFAABFCF),
    400: Color(0xFF7D9EB3),
    500: Color(0xFF5C819B),
    600: Color(0xFF486781),
    700: Color(0xFF3B5469),
    800: Color(0xFF344758),
    900: Color(0xFF2F3E4B),
    950: Color(0xFF1F2832),
  },
);

const int _primaryAccentColor = 0xFFFB8A3C;
const MaterialColor accentColor = MaterialColor(
  _primaryAccentColor,
  <int, Color>{
    50: Color(0xFFFFF4ED),
    100: Color(0xFFFFE6D5),
    200: Color(0xFFFECCAA),
    300: Color(0xFFFDAC74),
    400: Color(_primaryAccentColor),
    500: Color(0xFFF97316),
    600: Color(0xFFEA670C),
    700: Color(0xFFC2570C),
    800: Color(0xFF9A4A12),
    900: Color(0xFF7C3D12),
    950: Color(0xFF432007),
  },
);
