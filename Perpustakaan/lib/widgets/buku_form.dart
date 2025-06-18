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
  late TextEditingController genreController;
  late TextEditingController deskripsiController;

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
    genreController = TextEditingController(text: buku?.genre ?? '');
    deskripsiController = TextEditingController(text: buku?.deskripsi ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.buku != null;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(isEdit ? 'Form Edit Buku' : 'Form Tambah Buku'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        '📖 Data Buku 📖',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      buildTextField(controller: fotoController, label: 'URL Foto Sampul', icon: Icons.image),
                      const SizedBox(height: 12),
                      buildTextField(controller: judulController, label: 'Judul', icon: Icons.book),
                      const SizedBox(height: 12),
                      buildTextField(controller: penulisController, label: 'Penulis', icon: Icons.person),
                      const SizedBox(height: 12),
                      buildTextField(controller: genreController, label: 'Genre', icon: Icons.category),
                      const SizedBox(height: 12),
                      buildTextField(
                        controller: tahunController,
                        label: 'Tahun Terbit',
                        icon: Icons.date_range,
                        keyboardType: TextInputType.number,
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
                        controller: deskripsiController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: "Deskripsi Buku",
                          prefixIcon: Icon(Icons.description),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'Deskripsi wajib diisi' : null,
                      ),
                      const SizedBox(height: 12),
                      buildTextField(
                        controller: stokController,
                        label: 'Stok',
                        icon: Icons.numbers,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Stok wajib diisi';
                          if (int.tryParse(value) == null) return 'Harus angka';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.lightBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final data = Buku(
                            id: widget.buku?.id ?? '',
                            judul: judulController.text,
                            penulis: penulisController.text,
                            stok: int.tryParse(stokController.text) ?? 0,
                            foto: fotoController.text,
                            tahunTerbit: int.tryParse(tahunController.text) ?? 0,
                            genre: genreController.text,
                            deskripsi: deskripsiController.text,
                          );

                          if (isEdit) {
                            await firebaseService.updateBuku(data.id, data.toMap());
                          } else {
                            await firebaseService.tambahBuku(data);
                          }

                          Navigator.pop(context, true);
                        }
                      },
                      child: Text(
                        isEdit ? "Simpan" : "Tambah",

                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black),
                      ),
                    ),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget builder reusable
  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: validator ??
              (value) {
            if (value == null || value.isEmpty) return '$label wajib diisi';
            return null;
          },
    );
  }
}
