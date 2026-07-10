import 'package:flutter/material.dart';
import '../data/animals_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mondo Pelosetti"),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: elencoAnimali.length,
        itemBuilder: (context, index) {
          final animale = elencoAnimali[index];

          return Card(
            child: ListTile(
              leading: const Icon(
                Icons.pets,
                color: Colors.orange,
              ),
              title: Text(
                animale.nome,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(animale.categoria),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}