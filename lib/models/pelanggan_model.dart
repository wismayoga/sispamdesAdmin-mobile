class PelangganModel {
  int? id;
  String? role;
  String? email;
  String? nama;
  String? status;
  String? fotoprofil;
  // ignore: non_constant_identifier_names 
  String? nomor_hp;
  String? alamat;
  String? token;

  PelangganModel({
    required this.id,
    required this.role,
    required this.email,
    required this.nama,
    required this.status,
    required this.fotoprofil,
    // ignore: non_constant_identifier_names 
    required this.nomor_hp,
    required this.alamat,
    required this.token,
  });

  PelangganModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
    email = json['email'];
    nama = json['nama'];
    status = json['status'];
    fotoprofil = json['fotoprofil'];
    nomor_hp = json['nomor_hp'];
    alamat = json['alamat'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'email': email,
      'nama': nama,
      'status': status,
      'fotoprofil': fotoprofil,
      'nomorhp': nomor_hp,
      'alamat': alamat,
      'token': token,
    };
  }
}
