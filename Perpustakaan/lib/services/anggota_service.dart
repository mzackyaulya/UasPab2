import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:perpustakaan/models/anggota.dart';

class AnggotaService {
  final CollectionReference _anggotaRef =
  FirebaseFirestore.instance.collection('anggota');

  Future<void> tambahAnggota(Anggota anggota) async {
    await _anggotaRef.add(anggota.toJson());
  }

  Future<void> editAnggota(Anggota anggota) async {
    if (anggota.id != null) {
      await _anggotaRef.doc(anggota.id!).update(anggota.toJson());
    }
  }

  Future<void> hapusAnggota(String id) async {
    await _anggotaRef.doc(id).delete();
  }

  Future<List<Anggota>> ambilSemuaAnggota() async {
    final snapshot = await _anggotaRef.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Anggota.fromJson(data, doc.id);
    }).toList();
  }
}
