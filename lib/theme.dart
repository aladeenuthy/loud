import 'package:flutter/material.dart';

import 'constants.dart';

ThemeData darkTheme() {
  return ThemeData(
    primaryColor: darkcolorLight,
    brightness: Brightness.dark,
    popupMenuTheme: ThemeData.dark().popupMenuTheme.copyWith(
        color: darkcolor),
    appBarTheme:
        ThemeData.dark().appBarTheme.copyWith(backgroundColor: darkcolor, titleTextStyle: const TextStyle(color: Colors.white)),
    scaffoldBackgroundColor: darkcolor,
    colorScheme: ThemeData()
        .colorScheme
        .copyWith(primary: primarycolorLight, brightness: Brightness.dark),
  );
}

ThemeData lightTheme() {
  return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: primarycolor,
      
      appBarTheme: ThemeData.light().appBarTheme.copyWith(
            backgroundColor: Colors.white,
            titleTextStyle: const TextStyle(
              color: Colors.black
            )
          ),
      colorScheme: ThemeData()
          .colorScheme
          .copyWith(primary: Colors.black12, brightness: Brightness.light));
}
