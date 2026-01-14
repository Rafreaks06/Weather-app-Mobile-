import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _cityController = TextEditingController(); // Untuk input teks
  
  Map<String, dynamic>? data;
  bool isLoading = true;
  String currentCity = "Tangerang"; // Kota default

  @override
  void initState() {
    super.initState();
    loadData(currentCity);
  }

  // Fungsi loadData sekarang menerima nama kota
  Future<void> loadData(String city) async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await _weatherService.getCurrentWeather(city);
      setState(() {
        data = result;
        currentCity = city; // Update kota yang aktif
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      // Jika gagal (misal kota tidak ketemu), tampilkan pesan error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Kota '$city' tidak ditemukan!")),
        );
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fungsi untuk menampilkan Dialog Pencarian
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.9),
        title: const Text("Cari Kota"),
        content: TextField(
          controller: _cityController,
          decoration: const InputDecoration(
            hintText: "Contoh: Jakarta, Tokyo, London",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_cityController.text.isNotEmpty) {
                Navigator.pop(context); // Tutup dialog
                loadData(_cityController.text); // Cari cuaca kota baru
                _cityController.clear(); // Bersihkan text field
              }
            },
            child: const Text("Cari"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (data == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Gagal memuat data cuaca"),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => loadData(currentCity),
                child: const Text("Coba Lagi"),
              )
            ],
          ),
        ),
      );
    }

    String iconCode = data!['weather'][0]['icon'] ?? '01d';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Weather App", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        // --- BAGIAN BARU: Tombol Search & Refresh ---
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: _showSearchDialog, // Panggil fungsi dialog
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => loadData(currentCity),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4FA3F7), 
              Color(0xFF2B5797),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView( // Agar aman di layar kecil
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                
                // --- NAMA KOTA ---
                Text(
                  data!['name'],
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                
                const SizedBox(height: 10),
                
                // --- TANGGAL ---
                Text(
                  DateFormat('EEEE, d MMMM y').format(DateTime.now()), 
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),

                const SizedBox(height: 40),

                // --- IKON CUACA ---
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ]
                  ),
                  child: Image.network(
                    'https://openweathermap.org/img/wn/$iconCode@4x.png',
                    width: 180,
                    height: 180,
                    errorBuilder: (context, error, stackTrace) => 
                        const Icon(Icons.cloud, size: 100, color: Colors.white),
                  ),
                ),

                // --- SUHU ---
                Text(
                  "${data!['main']['temp'].toStringAsFixed(0)}°",
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                // --- DESKRIPSI ---
                Text(
                  data!['weather'][0]['description'].toString().toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 50),

                // --- KARTU INFO TAMBAHAN ---
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoItem(Icons.water_drop, "Humidity", "${data!['main']['humidity']}%"),
                      Container(height: 40, width: 1, color: Colors.white30),
                      _buildInfoItem(Icons.air, "Wind", "${data!['wind']['speed']} m/s"),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold, 
            fontSize: 16
          ),
        ),
      ],
    );
  }
}