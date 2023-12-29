class HargaModel {
  int? id;
  String? level1;
  String? level2;
  String? level3;
  // ignore: non_constant_identifier_names
  String? created_at;
  // ignore: non_constant_identifier_names
  String? updated_at;

  HargaModel({
    required this.id,
    required this.level1,
    required this.level2,
    required this.level3,
    // ignore: non_constant_identifier_names
    required this.created_at,
    // ignore: non_constant_identifier_names
    required this.updated_at,
    // required this.token,
  });

  HargaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    level1 = json['level1'];
    level2 = json['level2'];
    level3 = json['level3'];
    created_at = json['created_at'];
    updated_at = json['updated_at'];
    // token = json['token'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level1': level1,
      'level2': level2,
      'level3': level3,
      'created_at': created_at,
      'updated_at': updated_at,
      // 'token': token,
    };
  }
}
