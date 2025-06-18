class Anggota {
  String? id; // document id
  String uid;
  String nis;
  String nama;
  String email;
  String telepon;
  String jurusan;
  String tanggalLahir;

  Anggota({
    this.id,
    required this.uid,
    required this.nis,
    required this.nama,
    required this.email,
    required this.telepon,
    required this.jurusan,
    required this.tanggalLahir,
  });

  factory Anggota.fromJson(Map<String, dynamic> json, String id) {
    return Anggota(
      uid: id,
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      telepon: json['telepon'] ?? '',
      nis: json['nis'],
      jurusan: json['jurusan'],
      tanggalLahir: json['tanggalLahir'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'nis': nis,
      'nama': nama,
      'email': email,
      'telepon': telepon,
      'jurusan': jurusan,
      'tanggalLahir': tanggalLahir,
      'role': 'anggota',
    };
  }

}
