import 'package:basedcooking/constants/theme.dart';
import 'package:basedcooking/screens/homepage.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Based Cooking',
      theme: primaryTheme,
      home: const MyHomePage(),
    );
  }
}
