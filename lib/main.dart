import 'package:flutter/material.dart';

void main() {
  runApp(const MondoPelosettiApp());
}

class MondoPelosettiApp extends StatelessWidget {
  const MondoPelosettiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mondo Pelosetti',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mondo Pelosetti')),
      body: const Center(
        child: Text('L\'applicazione è pronta!'),
      ),
    );
  }
}
