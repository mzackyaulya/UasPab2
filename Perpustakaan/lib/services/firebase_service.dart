import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:perpustakaan/models/buku.dart';

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
}
