import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> initialData;

  const EditProfilePage({super.key, required this.initialData});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nisController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController jurusanController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();
  DateTime? tanggalLahir;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    nisController.text = widget.initialData['nis'] ?? '';
    namaController.text = widget.initialData['nama'] ?? '';
    emailController.text = widget.initialData['email'] ?? '';
    jurusanController.text = widget.initialData['jurusan'] ?? '';
    teleponController.text = widget.initialData['telepon'] ?? '';

    final tgl = widget.initialData['tanggalLahir'];
    if (tgl != null) {
      tanggalLahir = DateTime.tryParse(tgl);
    }
  }

  Future<void> saveProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    if (nisController.text.isEmpty ||
        namaController.text.isEmpty ||
        emailController.text.isEmpty ||
        jurusanController.text.isEmpty ||
        teleponController.text.isEmpty ||
        tanggalLahir == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Mohon lengkapi semua data."),
        backgroundColor: Colors.red,
      ));
      return;
    }

    setState(() => isSaving = true);

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'nis': nisController.text.trim(),
        'nama': namaController.text.trim(),
        'email': emailController.text.trim(),
        'jurusan': jurusanController.text.trim(),
        'telepon': teleponController.text.trim(),
        'tanggalLahir': tanggalLahir!.toIso8601String().split('T')[0],
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Profil berhasil diperbarui."),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Gagal memperbarui profil: $e"),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() => isSaving = false);
    }
  }

  @override
  void dispose() {
    nisController.dispose();
    namaController.dispose();
    emailController.dispose();
    jurusanController.dispose();
    teleponController.dispose();
    super.dispose();
  }

  Widget buildTextField(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.red.shade700;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Edit Profil",
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.red,
                Colors.white,
              ],
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                buildTextField('NIS', nisController),
                buildTextField('Nama', namaController),
                buildTextField('Email', emailController, type: TextInputType.emailAddress),
                buildTextField('Jurusan', jurusanController),
                buildTextField('Telepon', teleponController, type: TextInputType.phone),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("Tanggal Lahir", style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text(
                    tanggalLahir != null
                        ? "${tanggalLahir!.day}/${tanggalLahir!.month}/${tanggalLahir!.year}"
                        : "Belum dipilih",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  trailing: Icon(Icons.calendar_today, color: primaryColor),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: tanggalLahir ?? DateTime(2005),
                      firstDate: DateTime(1990),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        tanggalLahir = picked;
                      });
                    }
                  },
                ),

                const SizedBox(height: 24),
                Divider(),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isSaving ? null : saveProfile,
                    icon: isSaving
                        ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                        : Icon(Icons.save),
                    label: Text("Simpan"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
