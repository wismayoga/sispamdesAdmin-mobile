import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../utils/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class AuthProvider with ChangeNotifier {
  late UserModel _user;

  UserModel get user => _user;

  set user(UserModel user) {
    _user = user;
    notifyListeners();
  }

  // GET USER
  Future<void> getUser(token) async {
    try {
      UserModel user = await AuthService().getUser(token: token);
      _user = user;
    } catch (e) {
      //ignore: avoid_print
      print(e);
    }
  }

  //POST IMAGE PROFILE
  var imageURL = '';
  void uploadImage(ImageSource imageSource) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: imageSource);
      if (pickedFile != null) {
        var response = await AuthService().uploadProfileFoto(pickedFile.path);
        if (response.statusCode == 200) {
          //get image url from api response

          imageURL = response.data['data']['foto_profil'];
          UserModel? currentUser = await UserPreferences().getUser();
          if (currentUser != null) {
            // Create a new UserModel instance with the updated values
            UserModel updatedUser = UserModel(
              id: currentUser.id,
              role: currentUser.role,
              token: currentUser.token,
              status: currentUser.status,
              foto_profil: imageURL,
              // Update the fields with the edited values
              nama: currentUser.nama,
              email: currentUser.email,
              nomor_hp: currentUser.nomor_hp,
              alamat: currentUser.alamat,
            );

            // Call the method to update the user data in SharedPreferences
            await UserPreferences().updateUser(updatedUser);
          }

          // _user.foto_profil = imageURL;

          //ignore: avoid_print
          print('Image uploaded successfully $imageURL');
        } else {
          //ignore: avoid_print
          print('$response');
          //ignore: avoid_print
          print('Gagal Upload');
        }
      } else {
        //ignore: avoid_print
        print('Image not selected');
      }
    } catch (e) {
      //ignore: avoid_print
      print('catch ne bos');
      //ignore: avoid_print
      print(e);
    }
  }

  // LOGIN
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      UserModel user = await AuthService().login(
        email: email,
        password: password,
      );

      _user = user;

      UserPreferences().saveUser(_user);
      return true;
    } catch (e) {
      //ignore: avoid_print
      print(e);
      return false;
    }
  }

  // LOGOUT
  Future<bool> logout({
    required String token,
  }) async {
    try {
      // API LOGOUT
      bool res = await AuthService().logout(
        token: token,
      );
      String text = 'authprov : ';
      //ignore: avoid_print
      print(text + res.toString());
      // REMOVE TOKEN
      UserPreferences().removeToken();
      return res;
    } catch (e) {
      //ignore: avoid_print
      print(e);
      return false;
    }
  }
}
