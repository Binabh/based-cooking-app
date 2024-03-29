import 'package:basedcooking/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

ThemeData primaryTheme = ThemeData(
    primaryColor: BasedColors.tomato,
    textTheme: const TextTheme(
      displayLarge:
          TextStyle(color: BasedColors.tomato, fontWeight: FontWeight.bold, fontSize: 18),
      bodyLarge: TextStyle(color: BasedColors.white, fontSize: 16),
      titleMedium: TextStyle(
          fontSize: 12, color: BasedColors.black, fontWeight: FontWeight.bold),
    ));
MarkdownStyleSheet markdownStyleSheet = MarkdownStyleSheet(
    h1: const TextStyle(color: BasedColors.lightBlue),
    h2: const TextStyle(color: BasedColors.lightBlue),
    h3: const TextStyle(color: BasedColors.lightBlue),
    listBullet: const TextStyle(color: BasedColors.tomato),
    blockquote: const TextStyle(color: BasedColors.black),
    p: const TextStyle(color: BasedColors.white));
