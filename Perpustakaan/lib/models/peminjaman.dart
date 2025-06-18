import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Peminjaman {
  final String id;
  final String namaAnggota;
  final String barang;
  final DateTime tanggalPinjam;
  final DateTime tanggalKembali;
  final String status;

  Peminjaman({
    required this.id,
    required this.namaAnggota,
    required this.barang,
    required this.tanggalPinjam,
    required this.tanggalKembali,
    required this.status,
  });

  // Parsing tanggal dari Firestore (Timestamp/String)
  static DateTime _parseTanggal(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    } else {
      throw FormatException('Format tanggal tidak dikenali: $value');
    }
  }

  // Factory untuk konversi dari DocumentSnapshot ke Peminjaman
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
      status: data['status'] ?? 'pending',
    );
  }

  // Konversi ke Map untuk disimpan ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'namaAnggota': namaAnggota,
      'barang': barang,
      'tanggalPinjam': Timestamp.fromDate(tanggalPinjam),
      'tanggalKembali': Timestamp.fromDate(tanggalKembali),
      'status': status,
    };
  }

  // Method static untuk menambah data peminjaman baru dengan nama otomatis dari user login
  static Future<void> tambahPeminjaman({
    required String barang,
    required DateTime tanggalKembali,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User belum login');
    }

    // Ambil data user dari koleksi users di Firestore
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final namaUser = userDoc.data()?['nama'] ?? 'Tidak diketahui';

    // Buat instance Peminjaman baru
    final peminjamanBaru = Peminjaman(
      id: '', // id akan dibuat otomatis oleh Firestore
      namaAnggota: namaUser,
      barang: barang,
      tanggalPinjam: DateTime.now(),
      tanggalKembali: tanggalKembali,
      status: 'pending',
    );

    // Simpan ke koleksi peminjaman
    await FirebaseFirestore.instance.collection('peminjaman').add(peminjamanBaru.toMap());
  }
}
