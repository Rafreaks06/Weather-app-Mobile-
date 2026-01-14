import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../services/weather_service.dart';
import 'detail_page.dart'; // PENTING: Import halaman detail agar bisa dipanggil

class ForecastPage extends StatefulWidget {
  const ForecastPage({super.key});

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  final WeatherService _weatherService = WeatherService();
  List<dynamic>? forecastList;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadForecast();
  }

  Future<void> loadForecast() async {
    try {
      final result = await _weatherService.getForecast("Tangerang");
      setState(() {
        forecastList = result['list']; 
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Ramalan 5 Hari", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4FA3F7), Color(0xFF2B5797)],
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : forecastList == null
                ? const Center(child: Text("Gagal memuat data", style: TextStyle(color: Colors.white)))
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 100, bottom: 20, left: 15, right: 15),
                    itemCount: forecastList!.length,
                    itemBuilder: (context, index) {
                      final item = forecastList![index];
                      final DateTime date = DateTime.parse(item['dt_txt']);
                      final String temp = item['main']['temp'].toStringAsFixed(0);
                      final String iconCode = item['weather'][0]['icon'];
                      final String description = item['weather'][0]['description'];

                      // --- PERBAIKAN DISINI ---
                      // Kita bungkus Container dengan GestureDetector (Tombol Invisible)
                      return GestureDetector(
                        onTap: () {
                          // Aksi saat diklik: Pindah ke DetailPage bawa data 'item'
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(weatherData: item),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('EEEE').format(date),
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Text(
                                    DateFormat('HH:mm').format(date),
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image.network(
                                    'https://openweathermap.org/img/wn/$iconCode.png',
                                    width: 40,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    description,
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                              Text(
                                "$temp°C",
                                style: const TextStyle(
                                  fontSize: 24, 
                                  fontWeight: FontWeight.bold, 
                                  color: Colors.white
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                      // --- AKHIR PERBAIKAN ---
                    },
                  ),
      ),
    );
  }
}