import 'package:flutter/material.dart';  // Assurez-vous que cet import est présent

class MenuHeader extends StatelessWidget {
  final VoidCallback onClose;

  const MenuHeader({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.05), // 4% de la largeur de l'écran
      child: Row(
        children: [
          Image.asset(
            'assets/icons/app_icon.png',
            width: screenWidth * 0.1, // 10% de la largeur de l'écran
            height: screenHeight * 0.1, // 10% de la hauteur de l'écran
          ),
          SizedBox(width: screenWidth * 0.02), // 2% de la largeur de l'écran
          Text(
            "PSFDF",
            style: TextStyle(
              color: const Color(0xFF474747), // Gris
              fontSize: screenWidth * 0.045, // 4.5% de la largeur de l'écran
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(), // Pousse la croix à droite
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF474747)),
            onPressed: onClose, // Appelle la fonction pour fermer le menu
          ),
        ],
      ),
    );
  }
}
