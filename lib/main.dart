import 'package:flutter/material.dart';
import 'package:pokemon_quiz/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokémon Quiz',
      theme: ThemeData(
        fontFamily: 'RobotoMono',
        primarySwatch: Colors.amber,
      ),
      home: HomeScreen(),
    );
  }
}
