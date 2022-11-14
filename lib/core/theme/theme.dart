import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData myTheme() {
    return ThemeData(
      primarySwatch: Colors.deepOrange,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        fillColor: Colors.grey[200],
        filled: true,
      ),
    );
  }
}
