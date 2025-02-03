import 'package:flutter/material.dart';
import 'package:association_psfdf/utils/constants.dart'; // Import des constantes pour les couleurs
import 'package:association_psfdf/services/weather_service.dart'; // Import du service météo
import 'package:association_psfdf/services/location_service.dart'; // Import du service de localisation

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({Key? key}) : super(key: key);

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}
class _WeatherWidgetState extends State<WeatherWidget> {
  String _locationInfo = "..."; // Changement ici pour stocker à la fois la ville et le département
  String _temperature = "...";
  String _humidity = "...";
  String _windSpeed = "...";
  String _windDirection = "..."; // Direction lisible, ex : "Nord"
  bool _windWillIncrease = false; // Indique si la vitesse du vent augmentera ou non
  bool _humidityWillIncrease = false; // Indique si l'humidité augmentera ou non
  bool _temperatureWillIncrease = false; // Indique si la température augmentera ou non

  @override
  void initState() {
    super.initState();
    _fetchLocationAndWeather();
  }
  // Fonction pour récupérer les données météo et de localisation
  Future<void> _fetchLocationAndWeather() async {
    try {
      // Étape 1 : Récupérer le nom de la ville et le département
      final locationInfo = await LocationService.getCityAndDepartement();
      print('Information de localisation récupérée : $locationInfo');
      setState(() {
        _locationInfo = locationInfo;
      });

      // Étape 2 : Récupérer les données météo pour cette ville
      // Il est probablement préférable d'utiliser uniquement la ville, vous pouvez l'extraire ici si nécessaire.
      final city = _locationInfo.split(",")[0]; // On récupère la ville de l'info
      final weatherData = await WeatherService.getWeather(city);

      // Débogage : Afficher les données brutes
      print("Données météo actuelles : ${weatherData.toString()}");

      // Étape 3 : Extraire les données météo
      final windSpeedInMetersPerSecond =
          double.tryParse(weatherData['wind']['speed']?.toString() ?? "") ?? 0.0;
      final windSpeedKmH =
          (windSpeedInMetersPerSecond * 3.6).round(); // Convertir m/s en km/h

      final windDirectionDegStr =
          weatherData['wind']['deg']?.toString() ?? "..."; // Direction brute du vent (en degrés)

      // Exemple de prévision pour vent/température/humidité
      final double nextHourWindSpeed = 10.0; // Exemple simulant les prévisions de vitesse du vent
      final double nextHourTemperature = 18.0; // Exemple prévision pour la température
      final double nextHourHumidity = 70.0; // Exemple prévision pour l'humidité

      // Calculs pour déterminer si les valeurs augmentent ou baissent
      final bool windWillIncrease = nextHourWindSpeed > windSpeedInMetersPerSecond;
      final bool temperatureWillIncrease = nextHourTemperature >
          (double.tryParse(weatherData['main']['temp']?.toString() ?? "") ?? 0.0);
      final bool humidityWillIncrease = nextHourHumidity >
          (double.tryParse(weatherData['main']['humidity']?.toString() ?? "") ?? 0.0);

      // Mettre à jour les données pour l'affichage
      setState(() {
        _temperature =
            double.tryParse(weatherData['main']['temp']?.toString() ?? "")
                    ?.round()
                    .toString() ??
                "...";
        _humidity = double
                .tryParse(weatherData['main']['humidity']?.toString() ?? "")
                ?.toStringAsFixed(0) ??
            "...";
        _windSpeed = "$windSpeedKmH";

        // Convertir la direction brute en direction lisible (ex : "Nord-Est")
        _windDirection = _getCardinalDirection(windDirectionDegStr);

        _windWillIncrease = windWillIncrease;
        _temperatureWillIncrease = temperatureWillIncrease;
        _humidityWillIncrease = humidityWillIncrease;
      });
    } catch (e) {
      // En cas d'erreur, afficher un message d'erreur dans l'affichage
      setState(() {
        _locationInfo = "Erreur";
        _temperature = "Erreur";
        _windSpeed = "Erreur";
        _humidity = "Erreur";
        _windDirection = "Erreur";
        _windWillIncrease = false;
        _temperatureWillIncrease = false;
        _humidityWillIncrease = false;
      });
    }
  }
  // Fonction pour convertir les degrés en direction cardinale
  String _getCardinalDirection(String degreesStr) {
    final double? degrees = double.tryParse(degreesStr);

    if (degrees == null) {
      return "Inconnue";
    }

    if ((degrees >= 0 && degrees <= 22.5) || (degrees > 337.5 && degrees <= 360)) {
      return "Nord";
    } else if (degrees > 22.5 && degrees <= 67.5) {
      return "Nord-Est";
    } else if (degrees > 67.5 && degrees <= 112.5) {
      return "Est";
    } else if (degrees > 112.5 && degrees <= 157.5) {
      return "Sud-Est";
    } else if (degrees > 157.5 && degrees <= 202.5) {
      return "Sud";
    } else if (degrees > 202.5 && degrees <= 247.5) {
      return "Sud-Ouest";
    } else if (degrees > 247.5 && degrees <= 292.5) {
      return "Ouest";
    } else if (degrees > 292.5 && degrees <= 337.5) {
      return "Nord-Ouest";
    } else {
      return "Inconnue";
    }
  }
@override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  return Align(
    alignment: Alignment.center,
    child: Container(
      width: screenWidth * 0.95,
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
      ),
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // **Colonne gauche : Localisation**
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Météo des feux",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white),
                        SizedBox(width: screenWidth * 0.02),
                        Text(
                          _locationInfo, // Affiche la ville et le département ensemble
                          style: TextStyle(
                            fontSize: screenWidth * 0.03,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    // **Bloc blanc pour le "Risque Incendie"**
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.whiteWithOpacity30,
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                        horizontal: screenWidth * 0.02,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Titre "Risque Incendie"
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Risque incendie",
                              style: TextStyle(
                                fontSize: screenWidth * 0.03,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          // Affichage du département (rempli dynamiquement)
                          Text(
  _locationInfo != null && _locationInfo.contains("Département:")
      ? "Département : ${_locationInfo.split("Département:").last.trim()}"
      : "Erreur : localisation",
  style: TextStyle(
    fontSize: screenWidth * 0.03,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
),


                          SizedBox(height: screenHeight * 0.01),
                          // **Cercle indiquant le risque (placé à l'intérieur du bloc blanc)**
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: screenHeight * 0.04,
                              width: screenWidth * 0.35,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(screenWidth * 0.04),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(screenWidth * 0.04),
                                child: Row(
                                  children: [
                                    // Vert (moins large)
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        color: const Color.fromARGB(255, 47, 160, 51),
                                      ),
                                    ),
                                    Container(width: 1, color: Colors.white),
                                    // Jaune (moins large)
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        color: const Color.fromARGB(255, 238, 199, 92),
                                      ),
                                    ),
                                    Container(width: 1, color: Colors.white),
                                    // Orange avec texte (plus large)
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        color: Colors.orange,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Sévère',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: screenHeight * 0.015,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(width: 1, color: Colors.white),
                                    // Rouge (moins large)
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              // **Colonne droite : Températures/Humidité + Vent**
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(minWidth: double.infinity),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // **Vent**
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.air, // Icône pour le vent
                              color: Colors.white,
                              size: screenWidth * 0.06,
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Text(
                              "$_windSpeed km/h",
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        // Bloc Direction + Prévision (incluant flèche pour vent)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Colonne pour la direction
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Direction",
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.025,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    _windDirection,
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.030,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Petit trait séparateur vertical
                            Container(
                              width: screenWidth * 0.005,
                              height: screenWidth * 0.1,
                              color: Colors.white,
                              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                            ),
                            // Colonne pour la prévision
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Prévision",
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.025,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Container(
                                    width: screenWidth * 0.05,
                                    height: screenWidth * 0.05,
                                    decoration: BoxDecoration(
                                      color: _windWillIncrease ? Colors.red : Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _windWillIncrease ? Icons.arrow_upward : Icons.arrow_downward,
                                      color: Colors.white,
                                      size: screenWidth * 0.035,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        // **Température et Humidité avec flèches**
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Bloc pour la Température
                            Container(
                              width: screenWidth * 0.2,
                              height: screenWidth * 0.24,
                              decoration: BoxDecoration(
                                color: AppColors.blue,
                                borderRadius: BorderRadius.circular(screenWidth * 0.03),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01,
                                horizontal: screenWidth * 0.01,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Temp.",
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.03,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.008),
                                  Text(
                                    "$_temperature°C",
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.035,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Container(
                                    width: screenWidth * 0.05,
                                    height: screenWidth * 0.05,
                                    decoration: BoxDecoration(
                                      color: _temperatureWillIncrease ? Colors.red : Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _temperatureWillIncrease ? Icons.arrow_upward : Icons.arrow_downward,
                                      color: Colors.white,
                                      size: screenWidth * 0.035,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Bloc pour l'Humidité
                            Container(
                              width: screenWidth * 0.2,
                              height: screenWidth * 0.24,
                              decoration: BoxDecoration(
                                color: AppColors.blue,
                                borderRadius: BorderRadius.circular(screenWidth * 0.03),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01,
                                horizontal: screenWidth * 0.01,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Humidité",
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.03,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.008),
                                  Text(
                                    "$_humidity%",
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.035,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Container(
                                    width: screenWidth * 0.05,
                                    height: screenWidth * 0.05,
                                    decoration: BoxDecoration(
                                      color: _humidityWillIncrease ? Colors.green : Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _humidityWillIncrease ? Icons.arrow_upward : Icons.arrow_downward,
                                      color: Colors.white,
                                      size: screenWidth * 0.035,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}
