import 'package:flutter/material.dart';
import '../models/buku.dart';

class BukuPickerPage extends StatelessWidget {
  final List<Buku> daftarBuku;

  const BukuPickerPage({super.key, required this.daftarBuku});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pilih Buku")),
      body: ListView.builder(
        itemCount: daftarBuku.length,
        itemBuilder: (context, index) {
          final buku = daftarBuku[index];
          return ListTile(
            title: Text(buku.judul),
            subtitle: Text("Penulis: ${buku.penulis}"),
            onTap: () {
              Navigator.pop(context, buku.judul); // kirim kembali ke form
            },
          );
        },
      ),
    );
  }
}
