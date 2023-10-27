import 'package:flutter/material.dart';
import 'package:jarvis/home_page.dart';
import 'package:jarvis/pallete.dart';

import 'constant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jarvis',
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: kScreenColor,
        appBarTheme: const AppBarTheme(backgroundColor: kScreenColor),
      ),
      home: const HomePage(),
    );
  }
}
