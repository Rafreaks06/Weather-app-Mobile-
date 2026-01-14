import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatelessWidget {
  // Variabel untuk menerima data dari halaman sebelumnya
  final Map<String, dynamic> weatherData;

  const DetailPage({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    // 1. Ekstrak data dari JSON
    final DateTime date = DateTime.parse(weatherData['dt_txt']);
    final String temp = weatherData['main']['temp'].toStringAsFixed(1);
    final String feelsLike = weatherData['main']['feels_like'].toStringAsFixed(1);
    final String iconCode = weatherData['weather'][0]['icon'];
    final String description = weatherData['weather'][0]['description'];
    
    // Data Detail Tambahan
    final humidity = "${weatherData['main']['humidity']}%";
    final pressure = "${weatherData['main']['pressure']} hPa";
    final windSpeed = "${weatherData['wind']['speed']} m/s";
    final seaLevel = "${weatherData['main']['sea_level']} hPa";

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Detail Cuaca", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        // Memastikan tombol Back berwarna putih agar terlihat
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Background Gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4FA3F7), Color(0xFF2B5797)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // --- TANGGAL & JAM ---
                Text(
                  DateFormat('EEEE, d MMMM y').format(date),
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                Text(
                  DateFormat('HH:mm').format(date),
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
                
                const SizedBox(height: 20),

                // --- ICON BESAR ---
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                    border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                  ),
                  child: Image.network(
                    'https://openweathermap.org/img/wn/$iconCode@4x.png',
                    width: 120,
                    height: 120,
                    errorBuilder: (context, error, stackTrace) => 
                      const Icon(Icons.cloud, size: 100, color: Colors.white),
                  ),
                ),

                const SizedBox(height: 10),

                // --- SUHU UTAMA ---
                Text(
                  "$temp°C",
                  style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  description.toUpperCase(),
                  style: const TextStyle(fontSize: 20, color: Colors.white70, letterSpacing: 1),
                ),
                Text(
                  "Terasa seperti $feelsLike°C",
                  style: const TextStyle(fontSize: 14, color: Colors.white54),
                ),

                const SizedBox(height: 40),

                // --- GRID INFO DETAIL ---
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: [
                    // Kita kirim 'context' agar bisa memunculkan pesan (SnackBar) saat diklik
                    _buildDetailCard(Icons.water_drop, "Kelembaban", humidity, context),
                    _buildDetailCard(Icons.air, "Angin", windSpeed, context),
                    _buildDetailCard(Icons.speed, "Tekanan", pressure, context),
                    _buildDetailCard(Icons.water, "Permukaan Laut", seaLevel, context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget kartu yang sudah diedit menjadi tombol (Interactive)
  Widget _buildDetailCard(IconData icon, String title, String value, BuildContext context) {
    return Material(
      color: Colors.transparent, // Transparan agar background gradient tetap terlihat
      child: InkWell(
        onTap: () {
          // AKSI SAAT DIKLIK: Munculkan pesan di bawah
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("$title saat ini adalah $value"),
              duration: const Duration(seconds: 1),
              backgroundColor: Colors.black87,
            ),
          );
        },
        borderRadius: BorderRadius.circular(20), // Agar efek klik mengikuti bentuk bulat
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white70, size: 30),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(color: Colors.white60, fontSize: 12)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}