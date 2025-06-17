import 'package:cloud_firestore/cloud_firestore.dart';

class Peminjaman {
  final String id;
  final String namaAnggota;
  final String barang;
  final DateTime tanggalPinjam;
  final DateTime tanggalKembali;

  Peminjaman({
    required this.id,
    required this.namaAnggota,
    required this.barang,
    required this.tanggalPinjam,
    required this.tanggalKembali,
  });

  // 🟩 1. Letakkan di atas
  static DateTime _parseTanggal(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    } else {
      throw FormatException('Format tanggal tidak dikenali: $value');
    }
  }

  // 🟩 2. Factory constructor yang memanggil fungsi static
  factory Peminjaman.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw StateError('Dokumen kosong atau tidak valid');
    }

    return Peminjaman(
      id: doc.id,
      namaAnggota: data['namaAnggota'] ?? '',
      barang: data['barang'] ?? '',
      tanggalPinjam: _parseTanggal(data['tanggalPinjam']),
      tanggalKembali: _parseTanggal(data['tanggalKembali']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'namaAnggota': namaAnggota,
      'barang': barang,
      'tanggalPinjam': Timestamp.fromDate(tanggalPinjam),
      'tanggalKembali': Timestamp.fromDate(tanggalKembali),
    };
  }
}
