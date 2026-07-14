import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String titolo;
  final IconData? icona;

  const SectionTitle({
    super.key,
    required this.titolo,
    this.icona,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),

      child: Row(
        children: [

          if (icona != null)
            Icon(
              icona,
              size: 28,
              color: Colors.orange,
            ),

          if (icona != null)
            const SizedBox(width: 10),

          Text(
            titolo,

            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

        ],
      ),
    );
  }
}