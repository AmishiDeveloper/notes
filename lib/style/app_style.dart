import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyle
{
  static Color bgColor= Colors.white;
  static Color mainColor= Colors.black;
  static Color accentColor= Colors.deepPurple;

  static List<Color> cardsColor=[
    Colors.orange.shade100,
    Colors.green.shade100,
    Colors.red.shade100,
    Colors.blue.shade100,
    Colors.deepPurple.shade100,
    Colors.pink.shade100,
    Colors.blueGrey.shade100,
    Colors.purple.shade100,
  ];

  static TextStyle mainTitle=GoogleFonts.roboto(fontSize:18,fontWeight: FontWeight.bold);
  static TextStyle mainContent=GoogleFonts.numans(fontSize:18,fontWeight: FontWeight.bold);
  static TextStyle dateTitle=GoogleFonts.roboto(fontSize:18,fontWeight: FontWeight.bold);
}