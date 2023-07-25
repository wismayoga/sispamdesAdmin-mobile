class UserModel {
  int? id;
  String? role;
  String? email;
  String? nama;
  String? status;
  // ignore: non_constant_identifier_names 
  String? foto_profil;
   // ignore: non_constant_identifier_names 
  String? nomor_hp;
  String? alamat;
  String? token;

  UserModel({
    required this.id,
    required this.role,
    required this.email, 
    required this.nama,
    required this.status,
    // ignore: non_constant_identifier_names 
    required this.foto_profil,
     // ignore: non_constant_identifier_names 
    required this.nomor_hp,
    required this.alamat,
    required this.token,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
    email = json['email'];
    nama = json['nama'];
    status = json['status'];
    foto_profil = json['foto_profil'];
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
      'foto_profil': foto_profil,
      'nomor_hp': nomor_hp,
      'alamat': alamat,
      'token': token,
    };
  }
}
