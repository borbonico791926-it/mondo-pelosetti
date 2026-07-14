import 'package:flutter/material.dart';

class DailyTipCard extends StatelessWidget {
  final String titolo;
  final String testo;

  const DailyTipCard({
    super.key,
    required this.titolo,
    required this.testo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.green.shade100,

        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          const Row(
            children: [

              Icon(
                Icons.lightbulb,
                color: Colors.orange,
                size: 30,
              ),

              SizedBox(width: 10),

              Text(
                "Consiglio del giorno",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ],
          ),

          const SizedBox(height: 12),

          Text(
            titolo,

            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            testo,

            style: const TextStyle(
              fontSize: 15,
            ),
          ),

        ],
      ),
    );
  }
}