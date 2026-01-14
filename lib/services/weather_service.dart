import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String baseUrl = "http://10.0.2.2:3001"; 
  // 10.0.2.2 = localhost untuk emulator Android

  Future<Map<String, dynamic>> getCurrentWeather(String city) async {
    final response = await http.get(Uri.parse('$baseUrl/weather?city=$city'));
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getForecast(String city) async {
    // Ingat: Android Emulator pakai 10.0.2.2, bukan localhost
    final url = Uri.parse('$baseUrl/forecast?city=$city'); 
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Gagal mengambil data forecast');
      }
    } catch (e) {
      throw Exception('Error koneksi: $e');
    }
  }
}
