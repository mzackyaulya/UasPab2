import 'package:cloud_firestore/cloud_firestore.dart';

class Buku {
  final String id;
  final String judul;
  final String penulis;
  final int stok;
  final String foto;
  final int tahunTerbit;
  final String genre;
  final String deskripsi;

  Buku({
    required this.id,
    required this.judul,
    required this.penulis,
    required this.stok,
    required this.foto,
    required this.tahunTerbit,
    required this.genre,
    required this.deskripsi,
  });

  factory Buku.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Buku(
      id: doc.id,
      judul: data['judul'] ?? '',
      penulis: data['penulis'] ?? '',
      stok: data['stok'] ?? 0,
      foto: data['foto'] ?? '',
      tahunTerbit: data['tahunTerbit'] ?? 0,
      genre: data['genre'] ?? '',
      deskripsi: data['deskripsi'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'judul': judul,
      'penulis': penulis,
      'stok': stok,
      'foto': foto,
      'tahunTerbit': tahunTerbit,
      'genre': genre,
      'deskripsi': deskripsi,
    };
  }
}
