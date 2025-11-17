import 'package:flutter/material.dart';
import 'pages/yi_choice_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '易经决策器',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const YiChoicePage(),
    );
  }
}