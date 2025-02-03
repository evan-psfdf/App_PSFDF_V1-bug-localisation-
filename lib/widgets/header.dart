import 'package:flutter/material.dart';
import 'package:association_psfdf/utils/constants.dart';

class Header extends StatelessWidget {
  final Function onHamburgerPressed; // Callback pour ouvrir le menu hamburger
  final Function onSignalerPressed; // Callback pour le bouton Signaler

  const Header({
    super.key, // Utilisation de super paramètre
    required this.onHamburgerPressed,
    required this.onSignalerPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(top: screenHeight * 0.06, left: screenWidth * 0.03, right: screenWidth * 0.03), // Espacement dynamique
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Bouton Hamburger à gauche
          GestureDetector(
            onTap: () => onHamburgerPressed(),
            child: Container(
              width: screenWidth * 0.1, // Taille proportionnelle à l'écran
              height: screenWidth * 0.1,
              decoration: BoxDecoration(
                color: AppColors.blue, // Couleur de fond grise
                borderRadius: BorderRadius.circular(screenWidth * 0.05), // Rayon dynamique
              ),
              child: Icon(
                Icons.menu,
                color: Colors.white,
                size: screenWidth * 0.05, // Taille proportionnelle à l'écran
              ),
            ),
          ),
          // Bouton Signaler à droite
          GestureDetector(
            onTap: () => onSignalerPressed(),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.03,
                vertical: screenHeight * 0.01,
              ), // Espacement dynamique
              decoration: BoxDecoration(
                color: const Color(0xFFBA1817), // Rouge
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'SIGN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.03, // Taille proportionnelle à l'écran
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.003), // Espace entre le texte et l'icône
                  Icon(
                    Icons.local_fire_department, // Icône de flamme
                    color: Colors.white,
                    size: screenWidth * 0.045, // Taille proportionnelle à l'écran
                  ),
                  SizedBox(width: screenWidth * 0.003), // Espace entre l'icône et le texte
                  Text(
                    'LER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.03, // Taille proportionnelle à l'écran
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
