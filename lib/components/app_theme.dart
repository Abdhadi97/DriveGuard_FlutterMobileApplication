import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.teal,
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontFamily: 'Roboto',
          inherit: true,
        ),
        bodyMedium: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: 'Roboto',
          inherit: true,
        ),
        titleLarge: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
          inherit: true,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        hintStyle: const TextStyle(color: Colors.grey),
        labelStyle: const TextStyle(color: Colors.teal), // Added labelStyle
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.teal),
        ),
        prefixIconColor: Colors.teal,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontSize: 16, fontFamily: 'Roboto'),
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.teal,
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.teal,
        brightness: Brightness.light,
      ).copyWith(
        secondary: Colors.amber,
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.deepPurple[900],
      scaffoldBackgroundColor: Colors.deepPurple[800],
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontFamily: 'Roboto',
          inherit: true,
        ),
        bodyMedium: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Roboto',
          inherit: true,
        ),
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
          inherit: true,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.deepPurple[700],
        hintStyle: const TextStyle(color: Colors.white70),
        labelStyle:
            const TextStyle(color: Colors.purpleAccent), // Added labelStyle
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white70),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white70),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.purpleAccent),
        ),
        prefixIconColor: Colors.purpleAccent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.deepPurple[900],
          backgroundColor: Colors.purpleAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          textStyle: const TextStyle(fontSize: 16, fontFamily: 'Roboto'),
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.purpleAccent,
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.dark,
      ).copyWith(
        secondary: Colors.purpleAccent,
      ),
    );
  }
}
