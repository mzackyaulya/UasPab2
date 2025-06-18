import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:perpustakaan/models/buku.dart';
import 'package:perpustakaan/services/firebase_service.dart';
import 'package:perpustakaan/widgets/buku_form.dart';

class DetailBukuPage extends StatefulWidget {
  final Buku buku;

  const DetailBukuPage({Key? key, required this.buku}) : super(key: key);

  @override
  State<DetailBukuPage> createState() => _DetailBukuPageState();
}

class _DetailBukuPageState extends State<DetailBukuPage> {
  final FirebaseService firebaseService = FirebaseService();
  String? currentUserRole;
  bool loadingRole = true;
  late Buku currentBuku;

  Buku _fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Buku(
      id: doc.id,
      judul: data['judul'] ?? '',
      penulis: data['penulis'] ?? '',
      genre: data['genre'] ?? '',
      deskripsi: data['deskripsi'] ?? '',
      tahunTerbit: data['tahunTerbit'] ?? 0,
      stok: data['stok'] ?? 0,
      foto: data['foto'] ?? '',
    );
  }

  @override
  void initState() {
    super.initState();
    currentBuku = widget.buku;
    _loadUserRole();
  }


  Future<void> _loadUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        currentUserRole = null;
        loadingRole = false;
      });
      return;
    }

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    setState(() {
      currentUserRole = doc.exists && doc.data() != null
          ? (doc.data()!['role'] as String?)
          : null;
      loadingRole = false;
    });
  }

  Future<void> _reloadBuku() async {
    final doc = await FirebaseFirestore.instance
        .collection('buku')
        .doc(widget.buku.id)
        .get();

    if (doc.exists) {
      setState(() {
        currentBuku = Buku(
          id: doc.id,
          judul: doc['judul'],
          penulis: doc['penulis'],
          genre: doc['genre'],
          deskripsi: doc['deskripsi'],
          tahunTerbit: doc['tahunTerbit'],
          stok: doc['stok'],
          foto: doc['foto'],
        );
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final imageUrl = currentBuku.foto.isNotEmpty
        ? 'https://images.weserv.nl/?url=${Uri.encodeComponent(currentBuku.foto.replaceFirst('https://', ''))}'
        : '';

    if (loadingRole) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentBuku.judul,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        actions: currentUserRole == 'admin'
            ? [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Buku',
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BukuFormPage(buku: currentBuku)),
              );
              if (result == true) {
                await _reloadBuku();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete,color: Colors.red),
            tooltip: 'Hapus Buku',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Konfirmasi"),
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
                await firebaseService.hapusBuku(currentBuku.id);
                Navigator.pop(context);
              }
            },
          ),
        ]
            : [],
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(imageUrl, height: 280),
              ),
            const SizedBox(height: 20),
            const Text(
              "📖 Informasi Buku 📖",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoTable([
              _infoRow("Judul", currentBuku.judul),
              _infoRow("Penulis", currentBuku.penulis),
              _infoRow("Genre", currentBuku.genre),
              _infoRow("Deskripsi", currentBuku.deskripsi),
              _infoRow("Tahun Terbit", currentBuku.tahunTerbit.toString()),
              _infoRow("Stok", currentBuku.stok.toString()),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTable(List<TableRow> rows) {
    return Table(
      columnWidths: const {0: IntrinsicColumnWidth()},
      border: TableBorder.all(color: Colors.grey.shade300),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: rows,
    );
  }

  TableRow _infoRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(value),
        ),
      ],
    );
  }
}
