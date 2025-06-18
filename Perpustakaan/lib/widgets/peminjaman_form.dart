import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/peminjaman.dart';
import '../models/buku.dart';
import '../pages/buku_picker_page.dart';

class FormPeminjaman extends StatefulWidget {
  final Function(Peminjaman) onSubmit;
  final List<Buku> daftarBuku;
  final Peminjaman? initialData; // untuk edit, bisa null kalau tambah baru

  const FormPeminjaman({
    super.key,
    required this.onSubmit,
    required this.daftarBuku,
    this.initialData,
  });

  @override
  State<FormPeminjaman> createState() => _FormPeminjamanState();
}

class _FormPeminjamanState extends State<FormPeminjaman> {
  final _namaController = TextEditingController();

  DateTime? _tanggalPinjam;
  DateTime? _tanggalKembali;
  String? _bukuDipilih;

  bool _loadingNama = true;

  @override
  void initState() {
    super.initState();
    _initForm();
  }

  Future<void> _initForm() async {
    if (widget.initialData != null) {
      // Edit mode: isi form dengan data awal
      final data = widget.initialData!;
      setState(() {
        _namaController.text = data.namaAnggota;
        _bukuDipilih = data.barang;
        _tanggalPinjam = data.tanggalPinjam;
        _tanggalKembali = data.tanggalKembali;
        _loadingNama = false;
      });
    } else {
      // Tambah baru: ambil nama user dari Firestore
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        final namaUser = userDoc.data()?['nama'] ?? '';
        setState(() {
          _namaController.text = namaUser;
          _loadingNama = false;
        });
      } else {
        setState(() {
          _namaController.text = '';
          _loadingNama = false;
        });
      }
    }
  }

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
      id: widget.initialData?.id ?? '', // pakai id lama kalau edit, kosong kalau baru
      namaAnggota: _namaController.text,
      barang: _bukuDipilih!,
      tanggalPinjam: _tanggalPinjam!,
      tanggalKembali: _tanggalKembali!,
      status: widget.initialData?.status ?? 'pending',
    );

    try {
      if (widget.initialData == null) {
        // Tambah data baru
        await FirebaseFirestore.instance.collection('peminjaman').add(peminjaman.toMap());
      } else {
        // Update data lama
        await FirebaseFirestore.instance
            .collection('peminjaman')
            .doc(peminjaman.id)
            .update(peminjaman.toMap());
      }
      widget.onSubmit(peminjaman);
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

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _loadingNama
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCard(
              child: TextField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: "Nama Anggota",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                readOnly: true,
              ),
            ),
            _buildCard(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _bukuDipilih ?? "Belum memilih buku",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _pilihBuku,
                    icon: const Icon(Icons.book),
                    label: const Text("Pilih Buku"),
                  ),
                ],
              ),
            ),
            _buildCard(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _tanggalPinjam == null
                          ? "Tanggal Pinjam belum dipilih"
                          : "Pinjam: ${DateFormat('dd/MM/yyyy').format(_tanggalPinjam!)}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _pilihTanggal(true),
                    icon: const Icon(Icons.date_range),
                    label: const Text("Pilih Tanggal"),
                  ),
                ],
              ),
            ),
            _buildCard(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _tanggalKembali == null
                          ? "Tanggal Kembali belum dipilih"
                          : "Kembali: ${DateFormat('dd/MM/yyyy').format(_tanggalKembali!)}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _pilihTanggal(false),
                    icon: const Icon(Icons.date_range),
                    label: const Text("Pilih Tanggal"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: _submit,
              child: Text(widget.initialData == null ? "Simpan" : "Update"),
            ),
          ],
        ),
      ),
    );
  }
}
