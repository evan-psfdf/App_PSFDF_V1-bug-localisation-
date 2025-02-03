import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleSheetsService {
  final String apiKey = 'AIzaSyBDxpE7Q6eZV1Hm5HNopt8gw-L29i7Dnxw'; // Remplace par ta clé API
  final String spreadsheetId = '1V5EgHi3PyFRs3bhSqTxPlLjGPRNQDNKD033Kz-I5KaY'; // Remplace par l'ID de la feuille
  final String range = 'Sheet1!A1:Z1000'; // Plage des données (ajuste selon ton besoin)

  Future<List<Map<String, String>>> getIncendies() async {
    final url =
        'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$range?key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Map<String, String>> incendies = [];
      for (var row in data['values']) {
        // Assurez-vous que le format de la ligne correspond à ce que vous attendez
        incendies.add({
          'Commune': row[0],
          'Date_signalement': row[1],
          'Num_dep': row[2],
          'Statut': row[3],
          'imageUrl': row[4], 
        });
      }
      return incendies;
    } else {
      throw Exception('Erreur lors de la récupération des données');
    }
  }
}
