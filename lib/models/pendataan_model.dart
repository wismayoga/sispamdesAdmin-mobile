class PendataanModel {
  int? id;
  // ignore: non_constant_identifier_names
  String? id_petugas;
  // ignore: non_constant_identifier_names
  String? id_pelanggan;
  // ignore: non_constant_identifier_names
  int? nilai_meteran;
  // ignore: non_constant_identifier_names
  String? foto_meteran;
  // ignore: non_constant_identifier_names
  int? total_penggunaan;
  // ignore: non_constant_identifier_names
  int? total_harga;
  // ignore: non_constant_identifier_names
  String? status_pembayaran;
  // ignore: non_constant_identifier_names
  String? created_at;
  // ignore: non_constant_identifier_names
  String? updated_at;
  // String? token;

  PendataanModel({
    required this.id,
    // ignore: non_constant_identifier_names
    required this.id_petugas,
    // ignore: non_constant_identifier_names
    required this.id_pelanggan,
    // ignore: non_constant_identifier_names
    required this.nilai_meteran,
    // ignore: non_constant_identifier_names
    required this.foto_meteran,
    // ignore: non_constant_identifier_names
    required this.total_penggunaan,
    // ignore: non_constant_identifier_names
    required this.total_harga,
    // ignore: non_constant_identifier_names
    required this.status_pembayaran,
    // ignore: non_constant_identifier_names
    required this.created_at,
    // ignore: non_constant_identifier_names
    required this.updated_at,
    // required this.token,
  });

  // PendataanModel.fromJson(Map<String, dynamic> json) {
  //   id = json['id'];
  //   id_petugas = json['id_petugas'];
  //   id_pelanggan = json['id_pelanggan'];
  //   nilai_meteran = json['nilai_meteran'];
  //   foto_meteran = json['foto_meteran'];
  //   total_penggunaan = json['total_penggunaan'];
  //   total_harga = json['total_harga'];
  //   status_pembayaran = json['status_pembayaran'];
  //   created_at = json['created_at'];
  //   updated_at = json['updated_at'];
  //   // token = json['token'];
  // }

  PendataanModel.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  id_petugas = json['id_petugas'];
  id_pelanggan = json['id_pelanggan'];
  nilai_meteran = json['nilai_meteran'];
  foto_meteran = json['foto_meteran'];
  total_penggunaan = json['total_penggunaan'];
  total_harga = json['total_harga'];
  status_pembayaran = json['status_pembayaran'];
  created_at = json['created_at'];
  updated_at = json['updated_at'];
  // token = json['token'];
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_petugas': id_petugas,
      'id_pelanggan': id_pelanggan,
      'nilai_meteran': nilai_meteran,
      'foto_meteran': foto_meteran,
      'total_penggunaan': total_penggunaan,
      'total_harga': total_harga,
      'status_pembayaran': status_pembayaran,
      'created_at': created_at,
      'updated_at': updated_at,
      // 'token': token,
    };
  }
}
