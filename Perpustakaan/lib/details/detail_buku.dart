import 'package:flutter/material.dart';
import 'package:perpustakaan/models/buku.dart';
import 'package:perpustakaan/services/firebase_service.dart';
import 'package:perpustakaan/widgets/buku_form.dart';

class DetailBukuPage extends StatelessWidget {
  final Buku buku;
  final FirebaseService firebaseService = FirebaseService();

  DetailBukuPage({Key? key, required this.buku}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = buku.foto.isNotEmpty
        ? 'https://images.weserv.nl/?url=${Uri.encodeComponent(buku.foto.replaceFirst('https://', ''))}'
        : '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          buku.judul,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Buku',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BukuFormPage(buku: buku)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
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
                await firebaseService.hapusBuku(buku.id);
                Navigator.pop(context);
              }
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
              _infoRow("Judul", buku.judul),
              _infoRow("Penulis", buku.penulis),
              _infoRow("Genre", buku.genre),
              _infoRow("Deskripsi", buku.deskripsi),
              _infoRow("Tahun Terbit", buku.tahunTerbit.toString()),
              _infoRow("Stok", buku.stok.toString()),
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
      children: rows.map((row) => row as TableRow).toList(),
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
