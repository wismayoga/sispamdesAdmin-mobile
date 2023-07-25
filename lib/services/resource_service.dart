import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/pelanggan_model.dart';
import '../models/pendataan_model.dart';

class ResourceService {
  // String baseUrl = 'http://127.0.0.1/sispamdes/public/api';
  // String baseUrl = 'http://10.0.2.2/sispamdes/public/api';
  String baseUrl = 'http://192.168.33.174/sispamdes/public/api';

  // GET Pelanggan
  Future<List<PelangganModel>> getPelanggans() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token').toString();

    var url = '$baseUrl/users';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var data = jsonData['data'];
      List<PelangganModel> pelanggans = [];
      for (var item in data) {
        pelanggans.add(PelangganModel.fromJson(item));
      }

      return pelanggans;
    } else {
      throw Exception('Gagal Mendapatkan Pelanggan');
    }
  }

  // GET Pendataan
  Future<List<PendataanModel>> getPendataans() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token').toString();

    var url = '$baseUrl/pendataans';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var data = jsonData['data'];
      List<PendataanModel> pendataans = [];
      for (var item in data) {
        pendataans.add(PendataanModel.fromJson(item));
      }

      return pendataans;
    } else {
      throw Exception('Gagal Mendapatkan Pendataan');
    }
  }

  //post pendataan
  Future<List<PendataanModel>> postPendataans({
    // ignore: non_constant_identifier_names
    required String? id_pelanggan,
    // ignore: non_constant_identifier_names
    foto_meteran,
    // ignore: non_constant_identifier_names
    required int nilai_meteran,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token').toString();
    var id = prefs.getInt('id');
    var url = '$baseUrl/pendataans';

    try {
      String fileName = foto_meteran.split('.').last;
      FormData formData = FormData.fromMap({
        'foto_meteran': await MultipartFile.fromFile(foto_meteran,
            filename: 'pendataan.$fileName'),
        'id_petugas': id,
        'id_pelanggan': id_pelanggan,
        'nilai_meteran': nilai_meteran,
      });

      Response response = await Dio().post(
        url,
        data: formData,
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 201) {
        Map<String, dynamic> responseData = response.data;
        PendataanModel pendataan = PendataanModel.fromJson(responseData);
        return [pendataan];
        
      } else {
        throw Exception('Gagal Mendapatkan Pendataan');
      }
    } catch (e) {
      //ignore: avoid_print
      print(e); 
      rethrow;
    }
  }
}
