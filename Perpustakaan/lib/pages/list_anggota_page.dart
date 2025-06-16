import 'package:flutter/material.dart';
import 'package:perpustakaan/models/anggota.dart';
import 'package:perpustakaan/services/anggota_service.dart';
import 'package:perpustakaan/pages/anggota_page.dart';

class ListAnggotaPage extends StatefulWidget {
  const ListAnggotaPage({super.key});

  @override
  State<ListAnggotaPage> createState() => _ListAnggotaPageState();
}

class _ListAnggotaPageState extends State<ListAnggotaPage> {
  final AnggotaService _anggotaService = AnggotaService();
  List<Anggota> _anggotaList = [];

  @override
  void initState() {
    super.initState();
    _loadAnggota();
  }

  Future<void> _loadAnggota() async {
    final data = await _anggotaService.ambilSemuaAnggota();
    setState(() {
      _anggotaList = data;
    });
  }

  void _hapusAnggota(String id) async {
    await _anggotaService.hapusAnggota(id);
    _loadAnggota();
  }

  void _keHalamanForm([Anggota? anggota]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnggotaPage(anggota: anggota),
      ),
    );
    _loadAnggota();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Anggota')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () => _keHalamanForm(),
              icon: const Icon(Icons.add),
              label: const Text('Tambah Anggota'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Responsif: jika terlalu kecil, scroll horizontal
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: constraints.maxWidth),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Table(
                          border: TableBorder.all(color: Colors.grey),
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FixedColumnWidth(40),
                            1: FixedColumnWidth(120),
                            2: FixedColumnWidth(150),
                            3: FixedColumnWidth(200),
                            4: FixedColumnWidth(120),
                            5: FixedColumnWidth(150),
                            6: FixedColumnWidth(120),
                          },
                          children: [
                            _buildHeader(),
                            ..._anggotaList.asMap().entries.map((entry) {
                              final index = entry.key;
                              final anggota = entry.value;
                              return _buildRow(index, anggota);
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildHeader() {
    return TableRow(
      decoration: BoxDecoration(color: Colors.blue.shade100),
      children: const [
        _HeaderCell('No'),
        _HeaderCell('NIS'),
        _HeaderCell('Nama'),
        _HeaderCell('Email'),
        _HeaderCell('Jurusan'),
        _HeaderCell('Tanggal Lahir'),
        _HeaderCell('Aksi'),
      ],
    );
  }

  TableRow _buildRow(int index, Anggota anggota) {
    return TableRow(
      children: [
        _cell((index + 1).toString()),
        _cell(anggota.nis),
        _cell(anggota.nama),
        _cell(anggota.email),
        _cell(anggota.jurusan),
        _cell(anggota.tanggalLahir),
        _cellButton(anggota),
      ],
    );
  }

  Widget _cell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }

  Widget _cellButton(Anggota anggota) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.orange),
            onPressed: () => _keHalamanForm(anggota),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _hapusAnggota(anggota.id!),
          ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String title;
  const _HeaderCell(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        textAlign: TextAlign.center,
      ),
    );
  }
}
