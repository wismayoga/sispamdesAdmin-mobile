import 'package:flutter/material.dart';
import 'package:sispamdes/models/user_model.dart';

import '../models/pelanggan_model.dart';
import '../models/harga_model.dart';
import '../services/resource_service.dart';
import '../services/database_helper.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class PelangganProvider with ChangeNotifier {
  List<PelangganModel> _pelanggans = [];
  List<HargaModel> _harga = [];
  final dbHelper = DatabaseHelper.instance;

  List<PelangganModel> get pelanggans => _pelanggans;
  List<HargaModel> get harga => _harga;

  set pelanggans(List<PelangganModel> pelanggans) {
    _pelanggans = pelanggans;
    _harga = harga;
    notifyListeners();
  }

  Future<void> getPelanggans() async {
    try {
      // List<PelangganModel> pelanggans = await ResourceService().getPelanggans();

      List<PelangganModel> pelanggans = await dbHelper.queryAllRowsPelanggans();
      _pelanggans = pelanggans;
      notifyListeners();
    } catch (e) {
      //ignore: avoid_print
      print(e);
    }
  }

  Future<dynamic> editProfil(
      String nama,
      // ignore: non_constant_identifier_names
      String nomor_hp,
      String alamat,
      String email,
      String id) async {
    try {
      PelangganModel pelanggan = await ResourceService()
          .editProfil(nama: nama, nomor_hp: nomor_hp, alamat: alamat, id: id);
      await DatabaseHelper.instance.updateUserByEmail(pelanggan);

      // Find the index of the item to be updated in _pelanggans
      int index = _pelanggans.indexWhere((pelanggan) => pelanggan.email == email);

      if (index != -1) {
        // Replace the item at the found index with the new UserModel
        _pelanggans[index] = pelanggan;
      }
      notifyListeners();
      return true;
    } catch (e) {
      //ignore: avoid_print
      print(e);
    }
  }

  Future<void> downloadPelanggans() async {
    try {
      EasyLoading.show(status: 'Mengunduh data...');
      List<PelangganModel> pelanggansAPI =
          await ResourceService().getPelanggans();

      List<HargaModel> hargaAPI = await ResourceService().getHarga();

      // function to insert data from PelanggansAPI to db.Helper
      await dbHelper.insertPelanggansFromAPI(pelanggansAPI);
      await dbHelper.insertHargaFromAPI(hargaAPI);

      List<PelangganModel> pelanggans = await dbHelper.queryAllRowsPelanggans();
      List<HargaModel> harga = await dbHelper.queryAllRowsHarga();

      _pelanggans = pelanggans;
      _harga = harga;
      EasyLoading.showSuccess('Unduh data berhasil!');
      notifyListeners();
    } catch (e) {
      EasyLoading.showError('Gagal mengunduh data');
      // ignore: avoid_print
      print(e);
    }
  }

  // Future<void> downloadPelanggans() async {
  //   try {
  //     List<PelangganModel> pelanggansAPI = await ResourceService().getPelanggans();

  //     // Get the existing Pelanggans from the local database
  //     List<PelangganModel> existingPelanggans = await dbHelper.queryAllRowsPelanggans();

  //     // Filter out Pelanggans from the API that already exist in the local database
  //     List<PelangganModel> newPelanggans = pelanggansAPI.where((apiPelanggan) {
  //       return !existingPelanggans
  //           .any((localPelanggan) => apiPelanggan.id == localPelanggan.id);
  //     }).toList();

  //     // Insert the new Pelanggans into the local database
  //     await dbHelper.insertPelanggansFromAPI(newPelanggans);

  //     // Update the _pelanggans list with all Pelanggans from the database
  //     List<PelangganModel> pelanggans = await dbHelper.queryAllRowsPelanggans();
  //     _pelanggans = pelanggans;
  //   } catch (e) {
  //     //ignore: avoid_print
  //     print(e);
  //   }
  // }
}
