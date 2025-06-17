import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/peminjaman.dart';

class PeminjamanService {
  final CollectionReference _ref =
  FirebaseFirestore.instance.collection('peminjaman');

  Future<void> tambahPeminjaman(Peminjaman peminjaman) async {
    await _ref.doc(peminjaman.id).set(peminjaman.toMap());
  }

  Future<List<Peminjaman>> ambilSemuaPeminjaman() async {
    final snapshot = await _ref.get();
    return snapshot.docs
        .map((doc) => Peminjaman.fromDocument(doc))
        .toList();
  }

  Future<void> hapusPeminjaman(String id) async {
    await _ref.doc(id).delete();
  }

  Future<void> updatePeminjaman(Peminjaman peminjaman) async {
    await _ref.doc(peminjaman.id).update(peminjaman.toMap());
  }
}
