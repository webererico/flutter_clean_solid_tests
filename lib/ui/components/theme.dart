import 'package:flutter/material.dart';
import 'package:vibe/constants/colors.dart';
import 'package:vibe/constants/fonts.dart';

final theme = ThemeData(
  primaryColor: primaryColor,
  primaryColorDark: primaryColorDark,
  primaryColorLight: primaryColorLight,
  backgroundColor: Colors.white,
  textTheme: const TextTheme(
    headline1: headline1,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: primaryColor),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: primaryColorLight),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: primaryColor),
    ),
    alignLabelWithHint: true,
  ),
  iconTheme: const IconThemeData(
    color: primaryColorLight,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
      ),
      backgroundColor: MaterialStateProperty.all(primaryColor),
    ),
  ),
);
