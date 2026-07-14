import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String titolo;
  final IconData icona;
  final Color colore;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.titolo,
    required this.icona,
    required this.colore,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(20),

      child: Container(
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: colore,

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
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Icon(
              icona,
              size: 45,
              color: Colors.white,
            ),

            const SizedBox(height: 10),

            Text(
              titolo,

              textAlign: TextAlign.center,

              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

          ],
        ),
      ),
    );
  }
}