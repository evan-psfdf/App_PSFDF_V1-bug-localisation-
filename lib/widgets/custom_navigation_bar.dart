import 'package:flutter/material.dart';
import 'menu_header.dart'; // Importer la partie du haut du menu
import 'menu_item.dart'; // Importer les éléments du menu (pages)


class HamburgerMenu extends StatefulWidget {
  final VoidCallback onClose;

  const HamburgerMenu({super.key, required this.onClose});

  @override
  _HamburgerMenuState createState() => _HamburgerMenuState();
}

class _HamburgerMenuState extends State<HamburgerMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // Initialisation de l'AnimationController et de l'Animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800), // Durée de l'animation
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Lancer l'animation de glissade à l'ouverture du menu
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Libération de l'animation
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Récupérer les dimensions de l'écran
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Fermer si on glisse vers la droite
        if (details.primaryDelta! < -10) {
          widget.onClose(); // Fermeture du menu via glissement
          _controller.reverse(); // Animation de fermeture
        }
      },
      onTap: () {
        // Assurez-vous que la fermeture se fasse également lorsque l'on touche l'extérieur du menu
        widget.onClose();
        _controller.reverse(); // Animation de fermeture
      },
      child: Stack(
        children: [
          // Partie floue et transparente
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Volet du menu avec animation de glissade
          SlideTransition(
            position: _slideAnimation,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: screenWidth * 0.66,
                height: screenHeight, // Contrainte explicite de hauteur
                color: const Color(0xFFF9F8F4),
                child: Column(
                  children: [
                    MenuHeader(
                        onClose: widget.onClose), // Intégration du MenuHeader
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero, // Supprime le padding par défaut
                        itemCount: _menuItems().length,
                        itemBuilder: (context, index) {
                          final item = _menuItems()[index];
                          return MenuItem(
                            icon: item['icon'] as IconData,
                            label: item['label'] as String,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fonction pour centraliser la liste des éléments
  List<Map<String, dynamic>> _menuItems() {
    return [
      {'icon': Icons.data_usage, 'label': "Utilisation des données"},
      {'icon': Icons.settings, 'label': "Paramètres"},
      {'icon': Icons.privacy_tip, 'label': "Politique de confidentialité"},
      {'icon': Icons.update, 'label': "Note de mise à jour"},
      {'icon': Icons.source, 'label': "Nos sources"},
      {'icon': Icons.info, 'label': "À propos"},
      {'icon': Icons.group, 'label': "Nous rejoindre"},
      {'icon': Icons.contact_page, 'label': "Contact"},
      {'icon': Icons.mobile_screen_share, 'label': "Présentation de l'application"},
    ];
  }
}
