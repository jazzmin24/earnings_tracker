import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiKey = 'XmSO35l205r3b6Qe0nVw4w==Xz2QbO4WyMdkSbff';
  static const String baseUrl = 'https://api.api-ninjas.com/v1';

  // Method to fetch earnings data for a specific ticker
  Future<dynamic> fetchEarningsData(String ticker) async {
    final url = Uri.parse('$baseUrl/earningscalendar?ticker=$ticker');
    final response = await http.get(
      url,
      headers: {'X-Api-Key': apiKey},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load earnings data');
    }
  }

  // New method to fetch earnings call transcript for a specific quarter and year
  Future<String> fetchTranscript({required String ticker, required int year, required int quarter}) async {
    final url = Uri.parse('$baseUrl/earningstranscript?ticker=$ticker&year=$year&quarter=$quarter');
    final response = await http.get(
      url,
      headers: {'X-Api-Key': apiKey},
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load transcript');
    }
  }
}
