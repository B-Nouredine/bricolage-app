import 'constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    primaryColor: kPrimaryColor,
    textSelectionTheme: TextSelectionTheme.of(context).copyWith(
          cursorColor: Colors.black12,
          selectionColor: Colors.black12,
    ),
    scaffoldBackgroundColor: kPrimaryColor,
    appBarTheme: const AppBarTheme().copyWith(
      titleTextStyle: const TextStyle(color: kContentColorLightTheme),
        iconTheme: const IconThemeData(color: kContentColorLightTheme),
    ),

    iconTheme: const IconThemeData(color: kContentColorLightTheme),
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
        .apply(bodyColor: kContentColorLightTheme),
    colorScheme: const ColorScheme.light(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      error: kErrorColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: kContentColorLightTheme.withOpacity(0.7),
      unselectedItemColor: kContentColorLightTheme.withOpacity(0.32),
      selectedIconTheme: const IconThemeData(color: kPrimaryColor),
      showUnselectedLabels: true,
    ),
    brightness: Brightness.light
  );
}

ThemeData darkThemeData(BuildContext context) {

  return ThemeData.dark().copyWith(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: kContentColorLightTheme,
    appBarTheme: const AppBarTheme().copyWith(
      backgroundColor: kContentColorLightTheme,
      titleTextStyle: const TextStyle(color: kContentColorDarkTheme),
      iconTheme: const IconThemeData(color: kContentColorDarkTheme),
    ),
    iconTheme: const IconThemeData(color: kContentColorDarkTheme),
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
        .apply(bodyColor: kContentColorDarkTheme),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      error: kErrorColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: kContentColorLightTheme,
      selectedItemColor: Colors.white70,
      unselectedItemColor: kContentColorDarkTheme.withOpacity(0.32),
      selectedIconTheme: const IconThemeData(color: kPrimaryColor),
      showUnselectedLabels: true,
    ),
      brightness: Brightness.dark
  );
}
