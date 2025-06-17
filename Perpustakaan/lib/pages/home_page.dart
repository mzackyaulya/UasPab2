import 'package:flutter/material.dart';
import 'package:perpustakaan/pages/buku_page.dart';
import 'package:perpustakaan/pages/list_anggota_page.dart';
import 'package:perpustakaan/pages/peminjaman_page.dart';
import 'package:perpustakaan/pages/profile_page.dart'; // ✅ Tambah import

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    BukuPage(),
    ListAnggotaPage(),
    PeminjamanPage(),
    ProfilePage(), // ✅ Tambah halaman profile
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
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // ✅ Icon profil
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
