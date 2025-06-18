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
  String roleUser = ''; // kosong dulu, nanti diisi

  @override
  void initState() {
    super.initState();
    _loadUserRole();   // panggil dulu ambil role user
    _loadDataBuku();
  }

  Future<void> _loadUserRole() async {
    // TODO: Ganti ini dengan cara sebenarnya kamu mendapatkan role user,
    // misal baca dari Firestore user doc, SharedPreferences, atau Firebase Auth claims

    await Future.delayed(const Duration(seconds: 1)); // simulasi delay fetch
    setState(() {
      roleUser = 'admin'; // ganti dengan nilai sesungguhnya (misal 'admin' atau 'user')
    });
  }

  void _bukuFormPeminjaman([Peminjaman? peminjaman]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: FormPeminjaman(
          daftarBuku: _listBuku,
          initialData: peminjaman,
          onSubmit: (p) async {
            if (peminjaman == null) {
              await _firebaseService.tambahPeminjaman(p);
            } else {
              await _firebaseService.updatePeminjaman(peminjaman.id, p);
            }
            Navigator.of(context).pop();
          },
        ),
      ),
    );
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

  Color _warnaStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'dipinjam':
        return Colors.blue;
      case 'dikembalikan':
        return Colors.green;
      case 'terlambat':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Daftar Peminjaman',
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent, // harus transparan supaya gradiasi terlihat
        elevation: 0, // supaya bayangan hilang, opsional
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
        foregroundColor: Colors.black, // warna teks dan icon agar terlihat (default putih terlalu kontras di putih)
      ),
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
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final p = data[index];
              final statusColor = _warnaStatus(p.status);

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.book, size: 36, color: Colors.indigo.shade400),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.namaAnggota,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Buku: ${p.barang}',
                              style: const TextStyle(fontSize: 15, color: Colors.black87),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Tanggal: ${p.tanggalPinjam.day}/${p.tanggalPinjam.month}/${p.tanggalPinjam.year} - '
                                  '${p.tanggalKembali.day}/${p.tanggalKembali.month}/${p.tanggalKembali.year}',
                              style: const TextStyle(fontSize: 14, color: Colors.black54),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                p.status.toUpperCase(),
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.lightBlue, size: 26),
                            tooltip: 'Edit',
                            onPressed: () => _bukuFormPeminjaman(p),
                          ),
                          const SizedBox(height: 8),
                          if (roleUser == 'admin')
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 26),
                              tooltip: 'Hapus',
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Konfirmasi'),
                                    content: const Text('Yakin ingin menghapus peminjaman ini?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(ctx).pop(false),
                                        child: const Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(ctx).pop(true),
                                        child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  await _firebaseService.hapusPeminjaman(p.id);
                                }
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _listBuku.isNotEmpty ? _bukaFormPeminjaman : null,
        backgroundColor: _listBuku.isNotEmpty ? Colors.lightBlue : Colors.grey.shade400,
        child: const Icon(Icons.add),
        tooltip: _listBuku.isNotEmpty ? 'Tambah Peminjaman' : 'Data buku kosong',
      ),
    );
  }
}
