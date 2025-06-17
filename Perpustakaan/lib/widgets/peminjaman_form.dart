import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/peminjaman.dart';
import '../models/buku.dart';
import '../pages/buku_picker_page.dart';
import '../services/firebase_service.dart'; // pastikan impor ini

class FormPeminjaman extends StatefulWidget {
  final Function(Peminjaman) onSubmit;
  final List<Buku> daftarBuku;

  const FormPeminjaman({
    super.key,
    required this.onSubmit,
    required this.daftarBuku,
  });

  @override
  State<FormPeminjaman> createState() => _FormPeminjamanState();
}

class _FormPeminjamanState extends State<FormPeminjaman> {
  final _namaController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  DateTime? _tanggalPinjam;
  DateTime? _tanggalKembali;
  String? _bukuDipilih;

  Future<void> _submit() async {
    if (_namaController.text.isEmpty ||
        _bukuDipilih == null ||
        _tanggalPinjam == null ||
        _tanggalKembali == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua field.')),
      );
      return;
    }

    final peminjaman = Peminjaman(
      id: DateTime.now().toIso8601String(), // ID sementara, Firestore akan ganti
      namaAnggota: _namaController.text,
      barang: _bukuDipilih!,
      tanggalPinjam: _tanggalPinjam!,
      tanggalKembali: _tanggalKembali!,
    );

    try {
      await _firebaseService.tambahPeminjaman(peminjaman);
      widget.onSubmit(peminjaman); // opsional: untuk update UI lokal
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
    }
  }

  void _pilihTanggal(bool isPinjam) async {
    final hasil = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (hasil != null) {
      setState(() {
        if (isPinjam) {
          _tanggalPinjam = hasil;
        } else {
          _tanggalKembali = hasil;
        }
      });
    }
  }

  void _pilihBuku() async {
    final hasil = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BukuPickerPage(daftarBuku: widget.daftarBuku),
      ),
    );

    if (hasil != null) {
      setState(() {
        _bukuDipilih = hasil;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: "Nama Anggota"),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: Text(_bukuDipilih ?? "Belum memilih buku")),
                TextButton(onPressed: _pilihBuku, child: const Text("Pilih Buku")),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(_tanggalPinjam == null
                      ? "Tanggal Pinjam belum dipilih"
                      : "Pinjam: ${DateFormat('dd/MM/yyyy').format(_tanggalPinjam!)}"),
                ),
                TextButton(
                  onPressed: () => _pilihTanggal(true),
                  child: const Text("Pilih Tanggal"),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(_tanggalKembali == null
                      ? "Tanggal Kembali belum dipilih"
                      : "Kembali: ${DateFormat('dd/MM/yyyy').format(_tanggalKembali!)}"),
                ),
                TextButton(
                  onPressed: () => _pilihTanggal(false),
                  child: const Text("Pilih Tanggal"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _submit, child: const Text("Simpan")),
          ],
        ),
      ),
    );
  }
}
