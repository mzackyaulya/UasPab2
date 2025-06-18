import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:perpustakaan/models/buku.dart';
import 'package:perpustakaan/models/peminjaman.dart';

class FirebaseService {
  final _db = FirebaseFirestore.instance;

  Stream<List<Buku>> getBukuStream() {
    return _db.collection('buku').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Buku.fromFirestore(doc)).toList();
    });
  }

  Future<void> tambahBuku(Buku buku) async {
    await _db.collection('buku').add(buku.toMap());
  }

  Future<void> updateBuku(String id, Map<String, dynamic> data) async {
    await _db.collection('buku').doc(id).update(data);
  }

  Future<void> hapusBuku(String id) async {
    await _db.collection('buku').doc(id).delete();
  }

  Future<List<Buku>> getDaftarBuku() async {
    final snapshot = await _db.collection('buku').get();

    if (snapshot.docs.isEmpty) return [];

    return snapshot.docs.map((doc) => Buku.fromFirestore(doc)).toList();
  }
  Stream<List<Peminjaman>> getPeminjaman() {
    return FirebaseFirestore.instance
        .collection('peminjaman')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Peminjaman.fromDocument(doc))
        .toList());
  }

  Future<void> tambahPeminjaman(Peminjaman p) async {
    await FirebaseFirestore.instance
        .collection('peminjaman')
        .doc(p.id)
        .set(p.toMap()); // pakai .set dan doc(id)
  }

  Future<void> updatePeminjaman(String id, Peminjaman p) async {
    await _db.collection('peminjaman').doc(id).update(p.toMap());
  }

  Future<void> hapusPeminjaman(String id) async {
    await FirebaseFirestore.instance.collection('peminjaman').doc(id).delete();
  }

}
