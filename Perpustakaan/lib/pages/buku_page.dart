import 'package:flutter/material.dart';
import 'package:perpustakaan/models/buku.dart';
import 'package:perpustakaan/pages/search_page.dart';
import 'package:perpustakaan/services/firebase_service.dart';
import 'package:perpustakaan/widgets/buku_form.dart';
import 'package:perpustakaan/details/detail_buku.dart';
import 'package:perpustakaan/card/buku_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BukuPage extends StatefulWidget {
  const BukuPage({super.key});

  @override
  State<BukuPage> createState() => _BukuPageState();
}

class _BukuPageState extends State<BukuPage> {
  final FirebaseService firebaseService = FirebaseService();

  String? currentUserRole;
  bool _loadingRole = true;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        currentUserRole = null;
        _loadingRole = false;
      });
      return;
    }

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (doc.exists) {
      setState(() {
        currentUserRole = doc.data()?['role'] as String?;
        _loadingRole = false;
      });
    } else {
      setState(() {
        currentUserRole = null;
        _loadingRole = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingRole) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "📚 Daftar Buku 📚",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 2.0,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchPage()),
              );
            },
          ),
        ],
        centerTitle: true,
        elevation: 4,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<Buku>>(
        stream: firebaseService.getBukuStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final bukuList = snapshot.data!;

          if (bukuList.isEmpty) {
            return const Center(
              child: Text(
                "📭 Belum ada buku yang ditambahkan",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: bukuList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              final buku = bukuList[index];
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BukuFormPage(buku: buku),
                    ),
                  );
                },
                onDelete: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Hapus Buku"),
                      content: const Text("Yakin ingin menghapus buku ini?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Batal"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Hapus"),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await firebaseService.hapusBuku(buku.id);
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: currentUserRole == 'admin'
          ? FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        child: const Icon(Icons.book_rounded),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const BukuFormPage(),
            ),
          );
        },
      )
          : null,
    );
  }
}
