import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class UserPreferences {
  Future<bool> saveUser(UserModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', true);
    prefs.setString('token', user.token!);
    prefs.setString('nama', user.nama!);
    prefs.setInt('id', user.id!);
    prefs.setString('role', user.role!);
    prefs.setString('alamat', user.alamat!);
    prefs.setString('foto_profil', user.foto_profil!);
    prefs.setString('nomor_hp', user.nomor_hp!);
    prefs.setString('status', user.status!);
    prefs.setString('email', user.email!);

    return true;
  }

  Future<void> updateUser(UserModel updatedUser) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', updatedUser.token!);
    prefs.setString('nama', updatedUser.nama!);
    prefs.setInt('id', updatedUser.id!);
    prefs.setString('role', updatedUser.role!);
    prefs.setString('alamat', updatedUser.alamat!);
    prefs.setString('foto_profil', updatedUser.foto_profil!);
    prefs.setString('nomor_hp', updatedUser.nomor_hp!);
    prefs.setString('status', updatedUser.status!);
    prefs.setString('email', updatedUser.email!);
    // Add other fields you want to update in SharedPreferences

    // You can also consider updating the UserModel instance in memory (optional)
    // userModelInstance.nama = updatedUser.nama;
    // userModelInstance.nomor_hp = updatedUser.nomor_hp;
    // userModelInstance.alamat = updatedUser.alamat;
    // userModelInstance.email = updatedUser.email;
  }

  void removeToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', false);
    prefs.remove('token');
    prefs.remove('nama');
    prefs.remove('id');
    prefs.remove('role');
    prefs.remove('status');
    prefs.remove('alamat');
    prefs.remove('foto_profil');
    prefs.remove('nomor_hp');
    prefs.remove('email');
  }

  // Future<String> getToken() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString("token");
  //   return token.toString();
  // }

  Future<UserModel?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool('isLogin') ?? false;
    if (isLogin) {
      String? token = prefs.getString('token');
      String? nama = prefs.getString('nama');
      int? id = prefs.getInt('id');
      String? role = prefs.getString('role');
      String? status = prefs.getString('status');
      String? alamat = prefs.getString('alamat');
      String? email = prefs.getString('email');
      // ignore: non_constant_identifier_names
      String? foto_profil = prefs.getString('foto_profil');
      // ignore: non_constant_identifier_names
      String? nomor_hp = prefs.getString('nomor_hp');

      UserModel user = UserModel(
        id: id,
        role: role,
        email: email,
        status: status,
        foto_profil: foto_profil,
        nomor_hp: nomor_hp,
        alamat: alamat,
        token: token,
        nama: nama,
      );

      return user;
    } else {
      return null;
    }
  }
}
