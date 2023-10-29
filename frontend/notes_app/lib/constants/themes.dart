import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/constants/colors.dart';

enum Theme { darkMode, lightMode, systemDefault }

class MyThemes {
  final lightTheme = ThemeData(
    iconTheme: const IconThemeData(color: Colors.black),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: bottomBannerColor,
      foregroundColor: Colors.black,
    ),
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo, brightness: Brightness.light),
    useMaterial3: true,
    textTheme: TextTheme(
      // for notesHeadline at homePage
      displayLarge: GoogleFonts.notoSans(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      // for notes content at homepage
      displayMedium: GoogleFonts.notoSans(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      // for searchbar text
      // for notes Page headline
      headlineLarge: GoogleFonts.notoSans(
        color: Colors.black,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      // for notespage content
      headlineMedium: GoogleFonts.notoSans(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      // for small headline in home page
      headlineSmall: GoogleFonts.notoSans(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: GoogleFonts.notoSans(
        color: Colors.black,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      labelMedium: GoogleFonts.notoSans(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      labelLarge: GoogleFonts.notoSans(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
  final darkTheme = ThemeData(
      iconTheme: const IconThemeData(color: Colors.white),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: themeColorDarkMode,
        foregroundColor: Colors.white,
      ),
      textTheme: TextTheme(
        // for notesHeadline at homePage
        displayLarge: GoogleFonts.notoSans(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        // for notes content at homepage
        displayMedium: GoogleFonts.notoSans(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        // for searchbar text
        // for notes Page headline
        headlineLarge: GoogleFonts.notoSans(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        // for notespage content
        headlineMedium: GoogleFonts.notoSans(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        // for small headline in home page
        headlineSmall: GoogleFonts.notoSans(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: GoogleFonts.notoSans(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        labelMedium: GoogleFonts.notoSans(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        labelLarge: GoogleFonts.notoSans(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.normal,
        ),
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: darkModeScaffoldColor,
      colorScheme: ColorScheme.fromSeed(
          seedColor: themeColorDarkMode, brightness: Brightness.dark));
}
