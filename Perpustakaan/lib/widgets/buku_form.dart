import 'package:flutter/material.dart';
import 'package:perpustakaan/models/buku.dart';
import 'package:perpustakaan/services/firebase_service.dart';

class BukuFormPage extends StatefulWidget {
  final Buku? buku;

  const BukuFormPage({Key? key, this.buku}) : super(key: key);

  @override
  State<BukuFormPage> createState() => _BukuFormPageState();
}

class _BukuFormPageState extends State<BukuFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController judulController;
  late TextEditingController penulisController;
  late TextEditingController stokController;
  late TextEditingController fotoController;
  late TextEditingController tahunController;

  final FirebaseService firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    final buku = widget.buku;
    judulController = TextEditingController(text: buku?.judul ?? '');
    penulisController = TextEditingController(text: buku?.penulis ?? '');
    stokController = TextEditingController(text: buku?.stok.toString() ?? '');
    fotoController = TextEditingController(text: buku?.foto ?? '');
    tahunController = TextEditingController(text: buku?.tahunTerbit.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.buku != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? '✏️ Edit Buku' : '➕ Tambah Buku'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: fotoController,
                decoration: const InputDecoration(
                  labelText: "URL Foto Sampul",
                  prefixIcon: Icon(Icons.image),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'URL Foto wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: judulController,
                decoration: const InputDecoration(
                  labelText: "Judul",
                  prefixIcon: Icon(Icons.book),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: penulisController,
                decoration: const InputDecoration(
                  labelText: "Penulis",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Penulis wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: tahunController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Tahun Terbit",
                  prefixIcon: Icon(Icons.date_range),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Tahun wajib diisi';
                  final tahun = int.tryParse(value);
                  if (tahun == null) return 'Harus angka';
                  if (tahun < 1000 || tahun > DateTime.now().year + 1) return 'Tahun tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: stokController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Stok",
                  prefixIcon: Icon(Icons.numbers),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Stok wajib diisi';
                  if (int.tryParse(value) == null) return 'Harus angka';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(isEdit ? Icons.save : Icons.add),
                label: Text(isEdit ? "Simpan" : "Tambah"),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final data = Buku(
                      id: widget.buku?.id ?? '',
                      judul: judulController.text,
                      penulis: penulisController.text,
                      stok: int.tryParse(stokController.text) ?? 0,
                      foto: fotoController.text,
                      tahunTerbit: int.tryParse(tahunController.text) ?? 0,
                    );

                    if (isEdit) {
                      await firebaseService.updateBuku(data.id, data.toMap());
                    } else {
                      await firebaseService.tambahBuku(data);
                    }

                    Navigator.pop(context); // kembali setelah simpan
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
