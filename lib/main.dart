import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MondoPelosettiApp());
}

class MondoPelosettiApp extends StatelessWidget {
  const MondoPelosettiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mondo Pelosetti',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const HomeScreen(),
    );
  }
}