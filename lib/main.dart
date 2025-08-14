import 'package:flutter/material.dart';
import 'views/home_screen.dart';

void main() {
  runApp(const TravelersVoiceApp());
}

class TravelersVoiceApp extends StatelessWidget {
  const TravelersVoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travelers Voice',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
