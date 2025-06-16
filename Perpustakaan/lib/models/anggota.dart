class Anggota {
  String? id; // ← pastikan bisa null saat awal
  String nis;
  String nama;
  String email;
  String jurusan;
  String tanggalLahir;

  Anggota({
    this.id,
    required this.nis,
    required this.nama,
    required this.email,
    required this.jurusan,
    required this.tanggalLahir,
  });

  factory Anggota.fromJson(Map<String, dynamic> json) {
    return Anggota(
      nis: json['nis'],
      nama: json['nama'],
      email: json['email'],
      jurusan: json['jurusan'],
      tanggalLahir: json['tanggalLahir'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nis': nis,
      'nama': nama,
      'email': email,
      'jurusan': jurusan,
      'tanggalLahir': tanggalLahir,
    };
  }
}
