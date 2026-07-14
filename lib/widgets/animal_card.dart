import 'package:flutter/material.dart';

class AnimalCard extends StatelessWidget {
  final String nome;
  final String categoria;
  final String descrizione;
  final VoidCallback onTap;

  const AnimalCard({
    super.key,
    required this.nome,
    required this.categoria,
    required this.descrizione,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),

      elevation: 3,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(20),

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Row(
                children: [

                  const CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(
                      Icons.pets,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Text(
                      nome,

                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 10),

              Text(
                categoria,

                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                descrizione,
              ),

            ],
          ),
        ),
      ),
    );
  }
}