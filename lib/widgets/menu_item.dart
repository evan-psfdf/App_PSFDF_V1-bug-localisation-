import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const MenuItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: const Color(0xFF474747)), // Gris
          title: Text(
            label,
            style: TextStyle(
              color: const Color(0xFF474747), // Gris
              fontSize: screenWidth * 0.03, // 4% de la largeur de l'écran (taille réduite)
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () {
            // Logique de navigation à implémenter
          },
        ),
        const Divider(
          color: Color(0xFF474747), // Gris
          thickness: 1,
          indent: 0,
          endIndent: 0,
        ),
      ],
    );
  }
}
