import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListAnggotaPage extends StatefulWidget {
  const ListAnggotaPage({super.key});

  @override
  State<ListAnggotaPage> createState() => _ListAnggotaPageState();
}

class _ListAnggotaPageState extends State<ListAnggotaPage> {
  List<Map<String, dynamic>> _anggotaList = [];
  String? currentUserId;
  String? currentUserRole;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initUserAndLoadData();
  }

  Future<void> _initUserAndLoadData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _loading = false;
      });
      return;
    }

    currentUserId = user.uid;

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUserId).get();
    if (userDoc.exists) {
      currentUserRole = userDoc.data()?['role'] as String?;
    }

    await _loadAnggota();
  }

  Future<void> _loadAnggota() async {
    List<Map<String, dynamic>> anggota = [];

    if (currentUserRole == 'admin') {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'anggota')
          .get();

      anggota = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } else if (currentUserRole == 'anggota') {
      final doc = await FirebaseFirestore.instance.collection('users').doc(currentUserId).get();
      if (doc.exists) {
        final data = doc.data()!;
        data['id'] = doc.id;
        anggota = [data];
      }
    }

    setState(() {
      _anggotaList = anggota;
      _loading = false;
    });
  }

  void _hapusAnggota(String id) async {
    if (currentUserRole != 'admin') return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Yakin ingin menghapus anggota ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus')),
        ],
      ),
    );

    if (confirmed == true) {
      await FirebaseFirestore.instance.collection('users').doc(id).delete();
      await _loadAnggota();
    }
  }

  DataCell _centeredCell(String text) {
    return DataCell(
      Align(
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  'Daftar Anggota',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.person, color: Colors.black),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: _anggotaList.isNotEmpty
                  ? FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.topLeft,
                child: DataTable(
                  columnSpacing: 10,
                  dataRowMinHeight: 36,
                  dataRowMaxHeight: 44,
                  headingRowHeight: 42,
                  headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.blue.shade50),
                  border: TableBorder.all(color: Colors.grey.shade300),
                  columns: [
                    const DataColumn(label: Center(child: _TableHeader('No', fontSize: 12))),
                    const DataColumn(label: Center(child: _TableHeader('NIS', fontSize: 12))),
                    const DataColumn(label: Center(child: _TableHeader('Nama', fontSize: 12))),
                    const DataColumn(label: Center(child: _TableHeader('Email', fontSize: 12))),
                    const DataColumn(label: Center(child: _TableHeader('Jurusan', fontSize: 12))),
                    const DataColumn(label: Center(child: _TableHeader('Lahir', fontSize: 12))),
                    if (currentUserRole == 'admin')
                      DataColumn(label: Center(child: _TableHeader('Aksi', fontSize: 12))),
                  ],
                  rows: _anggotaList.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;

                    final cells = <DataCell>[
                      _centeredCell('${index + 1}'),
                      _centeredCell(data['nis'] ?? '-'),
                      _centeredCell(data['nama'] ?? '-'),
                      _centeredCell(data['email'] ?? '-'),
                      _centeredCell(data['jurusan'] ?? '-'),
                      _centeredCell(data['tanggalLahir'] ?? '-'),
                    ];

                    if (currentUserRole == 'admin') {
                      cells.add(
                        DataCell(
                          Align(
                            alignment: Alignment.center,
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                              onPressed: () => _hapusAnggota(data['id']),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ),
                        ),
                      );
                    }

                    return DataRow(cells: cells);
                  }).toList(),
                ),
              )
                  : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.info_outline, color: Colors.grey, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'Belum ada data anggota.',
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper widget untuk header tabel
class _TableHeader extends StatelessWidget {
  final String title;
  final double fontSize;
  const _TableHeader(this.title, {this.fontSize = 14, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: fontSize),
        textAlign: TextAlign.center,
      ),
    );
  }
}
