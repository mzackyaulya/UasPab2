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

  // Optional: untuk konversi ke Map (jika ingin disimpan ke database / JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'namaAnggota': namaAnggota,
      'barang': barang,
      'tanggalPinjam': tanggalPinjam.toIso8601String(),
      'tanggalKembali': tanggalKembali.toIso8601String(),
    };
  }

  // Optional: untuk konversi dari Map
  factory Peminjaman.fromMap(Map<String, dynamic> map) {
    return Peminjaman(
      id: map['id'],
      namaAnggota: map['namaAnggota'],
      barang: map['barang'],
      tanggalPinjam: DateTime.parse(map['tanggalPinjam']),
      tanggalKembali: DateTime.parse(map['tanggalKembali']),
    );
  }
}
