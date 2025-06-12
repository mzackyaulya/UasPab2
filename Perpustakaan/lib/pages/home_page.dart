import 'package:flutter/material.dart';
import 'package:perpustakaan/pages/buku_page.dart';
import 'package:perpustakaan/pages/anggota_page.dart';
import 'package:perpustakaan/pages/peminjaman_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    BukuPage(),
    AnggotaPage(),
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Buku'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Anggota'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Peminjaman'),
        ],
      ),
    );
  }
}
