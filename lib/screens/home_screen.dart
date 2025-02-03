import 'package:flutter/material.dart';
import 'package:association_psfdf/widgets/hamburger_menu.dart'; // Menu Hamburger
import 'package:association_psfdf/widgets/header.dart'; // En-tête
import 'package:association_psfdf/widgets/weather_widget.dart'; // Widget météo
import 'package:association_psfdf/utils/constants.dart'; // Couleurs définies

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isMenuOpen = false; // État du menu hamburger

  // Ouvrir le menu hamburger
  void openHamburgerMenu() {
    setState(() {
      _isMenuOpen = true;
    });
  }

  // Fermer le menu hamburger
  void closeHamburgerMenu() {
    setState(() {
      _isMenuOpen = false;
    });
  }

  // Méthode appelée pour signaler un événement
  void signaler() {
    print("Signalement effectué !");
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.grey, // Arrière-plan défini dans constants.dart
      body: Stack(
        children: [
          Column(
            children: [
              // Header avec bouton signalement et menu hamburger
              Header(
                onHamburgerPressed: openHamburgerMenu,
                onSignalerPressed: signaler,
              ),

              // Widget météo intégré dans HomeScreen
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.02),
                child: const WeatherWidget(), // Appel direct du widget météo
              ),
            ],
          ),

          // Menu Hamburger (affiché si le menu est ouvert)
          if (_isMenuOpen)
            HamburgerMenu(
              onClose: closeHamburgerMenu,
            ),
        ],
      ),
    );
  }
}
