import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/forecast_page.dart';
// import 'pages/detail_page.dart'; // HAPUS ATAU KOMENTAR BARIS INI (Tidak dipakai di main)

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _index = 0;

  // PERBAIKAN: Cukup 2 Halaman saja. DetailPage dihapus dari sini.
  final pages = const [
    HomePage(),
    ForecastPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Cuaca',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: Scaffold(
        body: pages[_index], // Menampilkan halaman sesuai urutan list di atas
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home), 
              label: "Home"
            ),
            // BottomNavigationBarItem Detail DIHAPUS
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), 
              label: "Forecast"
            ),
          ],
        ),
      ),
    );
  }
}