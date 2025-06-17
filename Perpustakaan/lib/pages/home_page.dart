import 'package:flutter/material.dart';
import 'package:perpustakaan/models/anggota.dart';
import 'package:perpustakaan/pages/anggota_page.dart';
import 'package:perpustakaan/pages/buku_page.dart';
import 'package:perpustakaan/pages/list_anggota_page.dart'; // ganti ini
import 'package:perpustakaan/pages/peminjaman_page.dart';
import 'package:perpustakaan/pages/search_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    BukuPage(),
    ListAnggotaPage(), // ← ganti dari AnggotaPage()
    PeminjamanPage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey[600],
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Buku',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Anggota',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in),
            label: 'Peminjaman',
          ),
        ],
      ),
    );
  }
}
