import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../utils/shared_preferences.dart';
import 'package:dio/dio.dart';

class AuthService {
  // String baseUrl = 'http://127.0.0.1/sispamdes/public/api';
  // String baseUrl = 'http://10.0.2.2/sispamdes/public/api';
  String baseUrl = 'http://192.168.33.174/sispamdes/public/api';

  // LOGIN
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    var url = '$baseUrl/login';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'email': email,
      'password': password,
    });

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      UserModel user = UserModel.fromJson(data);
      String text = 'Bearer ';
      user.token = text + data['access_token'];
      user.nama = data['nama'];

      return user;
    } else {
      throw Exception('Gagal Login');
    }
  }

  // GET USER
  Future<UserModel> getUser({
    required String token,
  }) async {
    var url = '$baseUrl/profile';
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
    };

    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      UserModel user = UserModel.fromJson(data);
      user.token = token;
      user.nama = data['nama'];

      return user;
    } else {
      UserPreferences().removeToken();
      throw Exception('Error Get User');
    }
  }

  // GET USER DATA
  Future<UserModel> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('token').toString();
    var url = '$baseUrl/users';
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
    };

    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      UserModel pengguna = UserModel.fromJson(data[0]);

      return pengguna;
    } else {
      UserPreferences().removeToken();
      throw Exception('Error Get User');
    }
  }

  // POST EDIT USER DATA
  Future<bool> editProfil({
    required String nama,
    required String email,
    // ignore: non_constant_identifier_names
    required String nomor_hp,
    required String alamat,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token').toString();
    var id = prefs.getInt('id').toString();

    var url = '$baseUrl/profile/$id';
    var headers = {
      'Content-Type': 'application/json',
      // 'Accept': 'application/json',
      'Authorization': token,
    };
    var body = jsonEncode({
      'nama': nama,
      'email': email,
      'nomor_hp': nomor_hp,
      'alamat': alamat,
    });

    var response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    // ignore: avoid_print
    print(body);
    // ignore: avoid_print
    print('status code: ${response.statusCode} ');

    if (response.statusCode == 200) {
      // Successful API call, now update the SharedPreferences data
      UserModel? currentUser = await UserPreferences().getUser();
      if (currentUser != null) {
        // Create a new UserModel instance with the updated values
        UserModel updatedUser = UserModel(
          id: currentUser.id,
          role: currentUser.role,
          token: currentUser.token,
          status: currentUser.status,
          foto_profil: currentUser.foto_profil,
          // Update the fields with the edited values
          nama: nama,
          email: email,
          nomor_hp: nomor_hp,
          alamat: alamat,
        );

        // Call the method to update the user data in SharedPreferences
        await UserPreferences().updateUser(updatedUser);
      }
      return true;
    } else {
      return false;
      // throw Exception('Gagal Menyimpan Data');
    }
  }

  //edit foto profil
  Future<dynamic> uploadProfileFoto(filePath) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token').toString();
    var id = prefs.getInt('id');
    var idString = id != null ? id.toString() : '';
    var url = '$baseUrl/profile-foto/$idString';
    

    try {
      String fileName = filePath.split('.').last;
      FormData formData = FormData.fromMap({
        'foto_profil': await MultipartFile.fromFile(filePath, filename: 'dp.$fileName'),
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

      return response;
      
    } on DioException catch (e) {
      // Handle Dio-specific errors (e.g., network errors, timeouts)
      return e.response;
    } catch (e) {
      // Handle other types of errors
      //ignore: avoid_print
      print(e); // or throw an error, depending on your use case
      return null;
    }
  }

  // POST CHANGE PASSWORD
  Future<bool> editPassword({
    // ignore: non_constant_identifier_names
    required String old_password,
    // ignore: non_constant_identifier_names
    required String new_password,
    // ignore: non_constant_identifier_names
    required String new_password_confirm,
    // required String id,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token').toString();
    var id = prefs.getInt('id').toString();
    var url = '$baseUrl/change-password/$id';

    var headers = {
      'Content-Type': 'application/json',
      // 'Accept': 'application/json',
      'Authorization': token,
    };
    var body = jsonEncode({
      'old_password': old_password,
      'new_password': new_password,
      'new_password_confirm': new_password_confirm,
    });

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    // ignore: avoid_print
    print(body);
    // ignore: avoid_print
    print('status code: ${response.statusCode} ');

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
      // throw Exception('Gagal Menyimpan Data');
    }
  }

  //logout
  Future<bool> logout({
    required String token,
  }) async {
    var url = '$baseUrl/logout';
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
    };
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
    );
    if (response.statusCode == 200) {
      // var data = jsonDecode(response.body)['data'];

      return true;
    } else {
      throw Exception('Error Logout');
    }
  }
}
