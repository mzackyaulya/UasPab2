// import 'package:flutter/material.dart';
// import 'anggota_page.dart'; // pastikan file anggota_page.dart berisi daftar anggota
//
// class PeminjamanPage extends StatefulWidget {
//   final String role; // "admin" atau "anggota"
//
//   const PeminjamanPage({super.key, required this.role});
//
//   @override
//   State<PeminjamanPage> createState() => _PeminjamanPageState();
// }
//
// class _PeminjamanPageState extends State<PeminjamanPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _barangController = TextEditingController();
//   Anggota? selectedAnggota;
//   DateTime? tanggalPinjam;
//   DateTime? tanggalKembali;
//
//   List<Map<String, dynamic>> riwayatPeminjaman = [];
//
//   void _pilihTanggal(BuildContext context, bool isTanggalPinjam) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//     );
//
//     if (picked != null) {
//       setState(() {
//         if (isTanggalPinjam) {
//           tanggalPinjam = picked;
//         } else {
//           tanggalKembali = picked;
//         }
//       });
//     }
//   }
//
//   void _submitForm() {
//     if (_formKey.currentState!.validate() &&
//         selectedAnggota != null &&
//         tanggalPinjam != null &&
//         tanggalKembali != null) {
//       setState(() {
//         riwayatPeminjaman.add({
//           'anggota': selectedAnggota!.nama,
//           'barang': _barangController.text,
//           'tanggalPinjam': tanggalPinjam,
//           'tanggalKembali': tanggalKembali,
//         });
//         _barangController.clear();
//         selectedAnggota = null;
//         tanggalPinjam = null;
//         tanggalKembali = null;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isAdmin = widget.role == 'admin';
//     final anggotaList = getAnggotaList();
//
//     return Scaffold(
//       appBar: AppBar(title: Text("Peminjaman Buku")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             if (isAdmin)
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     DropdownButtonFormField<Anggota>(
//                       value: selectedAnggota,
//                       decoration: InputDecoration(labelText: 'Pilih Anggota'),
//                       items: anggotaList.map((anggota) {
//                         return DropdownMenuItem(
//                           value: anggota,
//                           child: Text(anggota.nama),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           selectedAnggota = value;
//                         });
//                       },
//                       validator: (value) =>
//                       value == null ? 'Wajib pilih anggota' : null,
//                     ),
//                     TextFormField(
//                       controller: _barangController,
//                       decoration: InputDecoration(labelText: 'Nama Barang'),
//                       validator: (value) =>
//                       value == null || value.isEmpty ? 'Isi nama barang' : null,
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             tanggalPinjam == null
//                                 ? 'Tanggal Pinjam belum dipilih'
//                                 : 'Tanggal Pinjam: ${tanggalPinjam!.toLocal()}'.split(' ')[0],
//                           ),
//                         ),
//                         ElevatedButton(
//                           onPressed: () => _pilihTanggal(context, true),
//                           child: Text("Pilih Tanggal Pinjam"),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             tanggalKembali == null
//                                 ? 'Tanggal Kembali belum dipilih'
//                                 : 'Tanggal Kembali: ${tanggalKembali!.toLocal()}'.split(' ')[0],
//                           ),
//                         ),
//                         ElevatedButton(
//                           onPressed: () => _pilihTanggal(context, false),
//                           child: Text("Pilih Tanggal Kembali"),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     ElevatedButton(
//                       onPressed: _submitForm,
//                       child: Text("Simpan Peminjaman"),
//                     ),
//                     const Divider(height: 30),
//                   ],
//                 ),
//               ),
//             const SizedBox(height: 10),
//             Text(
//               "Riwayat Peminjaman",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             Expanded(
//               child: riwayatPeminjaman.isEmpty
//                   ? Center(child: Text("Belum ada peminjaman"))
//                   : ListView.builder(
//                 itemCount: riwayatPeminjaman.length,
//                 itemBuilder: (context, index) {
//                   final item = riwayatPeminjaman[index];
//                   return ListTile(
//                     title: Text(item['barang']),
//                     subtitle: Text(
//                       "Anggota: ${item['anggota']}\n"
//                           "Pinjam: ${item['tanggalPinjam'].toLocal().toString().split(' ')[0]} - "
//                           "Kembali: ${item['tanggalKembali'].toLocal().toString().split(' ')[0]}",
//                     ),
//                     isThreeLine: true,
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
