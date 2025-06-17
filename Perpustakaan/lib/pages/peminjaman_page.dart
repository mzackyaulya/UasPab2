import 'package:flutter/material.dart';
import '../models/peminjaman.dart';
import '../models/buku.dart';
import '../services/firebase_service.dart';
import '../widgets/peminjaman_form.dart';

class PeminjamanPage extends StatefulWidget {
  const PeminjamanPage({super.key});

  @override
  State<PeminjamanPage> createState() => _PeminjamanPageState();
}

class _PeminjamanPageState extends State<PeminjamanPage> {
  final List<Peminjaman> _listPeminjaman = [];
  List<Buku> _listBuku = [];
  final FirebaseService _firebaseService = FirebaseService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDataBuku();
  }

  Future<void> _loadDataBuku() async {
    try {
      final buku = await _firebaseService.getDaftarBuku();
      setState(() {
        _listBuku = buku;
        _isLoading = false;
      });
    } catch (e) {
      print('Gagal mengambil data buku: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _tambahPeminjaman(Peminjaman peminjaman) async {
    await _firebaseService.tambahPeminjaman(peminjaman);
  }

  void _bukaFormPeminjaman() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: FormPeminjaman(
          daftarBuku: _listBuku,
          onSubmit: _tambahPeminjaman,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<List<Peminjaman>>(
        stream: _firebaseService.getPeminjaman(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print('🔥 Error saat mengambil data: ${snapshot.error}');
            return const Center(child: Text('Terjadi kesalahan saat mengambil data'));
          }


          final data = snapshot.data;

          if (data == null || data.isEmpty) {
            return const Center(child: Text('Belum ada peminjaman'));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final p = data[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400), // Garis tepi
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.bookmark, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nama : ${p.namaAnggota}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                          Text('Buku : ${p.barang}', style: const TextStyle(fontSize: 14, color: Colors.black87)),
                          Text(
                            'Tanggal : ${p.tanggalPinjam.day}/${p.tanggalPinjam.month} - ${p.tanggalKembali.day}/${p.tanggalKembali.month}',
                            style: const TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text('Hapus', style: TextStyle(color: Colors.red)),
                      onPressed: () async {
                        await _firebaseService.hapusPeminjaman(p.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _listBuku.isNotEmpty ? _bukaFormPeminjaman : null,
        child: const Icon(Icons.add),
      ),
    );
  }
}
