import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:perpustakaan/models/buku.dart';
import 'package:perpustakaan/card/buku_card.dart';
import 'package:perpustakaan/details/detail_buku.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchText = '';
  List<Buku> _allBuku = [];
  List<Buku> _filteredBuku = [];

  @override
  void initState() {
    super.initState();
    _fetchBukuFromFirestore();
  }

  void _fetchBukuFromFirestore() async {
    final snapshot = await FirebaseFirestore.instance.collection('buku').get();
    final bukuList = snapshot.docs.map((doc) => Buku.fromFirestore(doc)).toList();

    setState(() {
      _allBuku = bukuList;
      _filteredBuku = bukuList;
    });
  }

  void _filterBuku(String query) {
    final filtered = _allBuku.where((buku) {
      final lowerQuery = query.toLowerCase();
      return buku.judul.toLowerCase().contains(lowerQuery) ||
          buku.penulis.toLowerCase().contains(lowerQuery);
    }).toList();

    setState(() {
      _searchText = query;
      _filteredBuku = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: AppBar(
          title: const Text("Cari Buku"),
          centerTitle: true,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red,
                  Colors.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari berdasarkan judul atau penulis...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: _filterBuku,
            ),
          ),
          Expanded(
            child: _filteredBuku.isEmpty
                ? const Center(child: Text("Buku tidak ditemukan."))
                : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: _filteredBuku.length,
              itemBuilder: (context, index) {
                final buku = _filteredBuku[index];
                return BukuCard(
                  buku: buku,
                  onTapDetail: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailBukuPage(buku: buku),
                      ),
                    );
                  },
                  onEdit: () {
                    // Implementasi edit (jika dibutuhkan)
                  },
                  onDelete: () {
                    // Implementasi delete (jika dibutuhkan)
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
