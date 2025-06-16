import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:perpustakaan/models/anggota.dart';

import 'package:perpustakaan/services/anggota_service.dart';

class AnggotaPage extends StatefulWidget {
  final Anggota? anggota;

  const AnggotaPage({super.key, this.anggota});

  @override
  State<AnggotaPage> createState() => _AnggotaPageState();
}

class _AnggotaPageState extends State<AnggotaPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nisController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController jurusanController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();

  final anggotaService = AnggotaService();

  @override
  void initState() {
    super.initState();
    if (widget.anggota != null) {
      nisController.text = widget.anggota!.nis;
      namaController.text = widget.anggota!.nama;
      emailController.text = widget.anggota!.email;
      jurusanController.text = widget.anggota!.jurusan;
      tanggalLahirController.text = widget.anggota!.tanggalLahir;
    }
  }

  void _simpanData() {
    if (_formKey.currentState!.validate()) {
      final anggota = Anggota(
        id: widget.anggota?.id,
        nis: nisController.text,
        nama: namaController.text,
        email: emailController.text,
        jurusan: jurusanController.text,
        tanggalLahir: tanggalLahirController.text,
      );

      if (widget.anggota == null) {
        anggotaService.tambahAnggota(anggota);
      } else {
        anggotaService.editAnggota(anggota);
      }

      Navigator.pop(context);
    }
  }

  Future<void> _pilihTanggal() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        tanggalLahirController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.anggota == null ? 'Tambah Anggota' : 'Edit Anggota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nisController,
                decoration: const InputDecoration(labelText: 'NIS'),
                validator: (value) => value!.isEmpty ? 'NIS tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (value) => value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Email tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: jurusanController,
                decoration: const InputDecoration(labelText: 'Jurusan'),
                validator: (value) => value!.isEmpty ? 'Jurusan tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: tanggalLahirController,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Tanggal Lahir'),
                onTap: _pilihTanggal,
                validator: (value) => value!.isEmpty ? 'Tanggal lahir harus diisi' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _simpanData,
                child: const Text('Simpan'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
