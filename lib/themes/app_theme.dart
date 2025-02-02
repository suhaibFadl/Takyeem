import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF333333), // Dark Gray
    brightness: Brightness.light,
    primary: const Color(0xFF262523),
    secondary: const Color(0xFF73655D),
    surface: const Color(0xFFF2ECE4),
  ),
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: Color(0xFF333333),
  ),
  textTheme: TextTheme(
    displayLarge: const TextStyle(
      fontSize: 72,
      fontWeight: FontWeight.bold,
      color: Color(0xFF262523),
    ),
    titleLarge: GoogleFonts.reemKufi(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      // fontStyle: FontStyle.italic,
      color: const Color(0xFF262523),
    ),
    titleMedium: GoogleFonts.reemKufi(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      // fontStyle: FontStyle.italic,
      color: const Color(0xFF262523),
    ),
    bodyLarge: GoogleFonts.almarai(
      fontSize: 20,
    ),
    bodyMedium: GoogleFonts.almarai(
      fontSize: 16,
    ),
    displaySmall: GoogleFonts.almarai(
      fontSize: 12,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 16,
      shadowColor: Colors.grey.withOpacity(0.5), // Set the shadow color

      backgroundColor: const Color(0xFF262523), // Dark Gray background
      foregroundColor: const Color(0xFFF2ECE4), // / White text
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        // Rounded corners
      ),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF262523)), // Primary color
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
          color: Color(0xFF73655D)), // Secondary color or any other color
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      textStyle: GoogleFonts.almarai(
        fontSize: 16, // Match bodyMedium font size
      ),
      foregroundColor: const Color(0xFF262523), // Set text color
    ),
  ),
);
