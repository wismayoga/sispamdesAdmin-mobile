import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sispamdes/models/harga_model.dart';
import '../models/pendataan_model.dart';
import '../services/resource_service.dart';
import '../services/database_helper.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class PendataanProvider with ChangeNotifier {
  List<PendataanModel> _pendataans = [];
  List<PendataanModel> _pendataansOnline = [];
  final dbHelper = DatabaseHelper.instance;

  List<PendataanModel> get pendataans => _pendataans;
  List<PendataanModel> get pendataansOnline => _pendataansOnline;

  set pendataans(List<PendataanModel> pendataans) {
    _pendataans = pendataans;
    _pendataansOnline = pendataansOnline;
    notifyListeners();
  }

  //get pendataan
  Future<void> getPendataans() async {
    try {
      // List<PendataanModel> pendataansOnline =
      //     await ResourceService().getPendataans();
      List<PendataanModel> pendataans = await dbHelper.queryAllRowsPendataans();
      _pendataans = pendataans;
      notifyListeners();
      // _pendataansOnline = pendataansOnline;
    } catch (e) {
      //ignore: avoid_print
      print(e);
    }
  }

  //get pendataan + online
  Future<void> getPendataansAll() async {
    try {
      EasyLoading.show(status: 'Mengupdate pendataan...');
      List<PendataanModel> pendataansOnline =
          await ResourceService().getPendataans();
      print('test1');
      List<PendataanModel> pendataans = await dbHelper.queryAllRowsPendataans();
      _pendataans = pendataans;
      _pendataansOnline = pendataansOnline;
      EasyLoading.showSuccess('Update pendataan berhasil!');
      notifyListeners();
    } catch (e) {
      EasyLoading.showError('Gagal mengupdate');
      //ignore: avoid_print
      print(e);
    }
  }

  //get last month data
  PendataanModel? getLastMonthData(int? idPelanggan) {
    if (idPelanggan == null) {
      return null;
    }

    // Get the current date
    final currentDate = DateTime.now();

    // Calculate the last month's date
    final lastMonthDate =
        DateTime(currentDate.year, currentDate.month, currentDate.day);

    try {
      // Find the data for the last month and the given idPelanggan
      final lastMonthData = pendataansOnline.firstWhere(
        (pendataan) {
          if (pendataan.id_pelanggan == idPelanggan.toString() &&
              pendataan.created_at != null) {
            final createdDate = DateTime.parse(pendataan.created_at!);
            return createdDate.isBefore(lastMonthDate);
          }
          return false;
        },
      );

      return lastMonthData;
    } catch (e) {
      // Handle the case when no matching element is found
      print("No data found for the last month and idPelanggan: $idPelanggan");
      return null; // or you can return a default PendataanModel object if you have one.
    }
  }

  //post pendataan ke
  Future<void> postPendataanToAPI(
    // ignore: non_constant_identifier_names
    String? id_pelanggan,
    // ignore: non_constant_identifier_names
    foto_meteran,
    // ignore: non_constant_identifier_names
    int nilai_meteran,
  ) async {
    try {
      if (foto_meteran != null) {
        await ResourceService().postPendataans(
            id_pelanggan: id_pelanggan,
            foto_meteran: foto_meteran.path,
            nilai_meteran: nilai_meteran);
      }
    } catch (e) {
      //ignore: avoid_print
      print(e);
    }
  }

  //post pendataan sqflite
  Future<void> postPendataanLocal(
    // ignore: non_constant_identifier_names
    String? id_pelanggan,
    // ignore: non_constant_identifier_names
    foto_meteran,
    // ignore: non_constant_identifier_names
    int nilai_meteran,
    // ignore: non_constant_identifier_names
    int total_penggunaan,
  ) async {
    try {
      if (foto_meteran != null || id_pelanggan != null) {
        // Your existing API call to post the data to the server can go here
        // ...
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        var id = prefs.getInt('id');
        

        // Save the data to the local database
        final DatabaseHelper dbHelper = DatabaseHelper.instance;

        Map<String, dynamic> harga = await dbHelper.queryFirstRecordHarga();
        String level1 = harga['level1'];
        String level2 = harga['level2'];
        String level3 = harga['level3'];
        // ignore: non_constant_identifier_names
        int total_harga = 0;
        if (total_penggunaan <= 20) {
            total_harga = total_penggunaan * int.parse(level1);
        } else if (total_penggunaan > 20 && total_penggunaan <= 40) {
            int harga1 = 20 * int.parse(level1);
            int meteran1 = total_penggunaan - 20;
            int harga2 = meteran1 * int.parse(level2);
            total_harga = harga1 + harga2;
        } else {
            int harga1 = 20 * int.parse(level1);
            int harga2 = 20 * int.parse(level2);
            int meteran1 = total_penggunaan - 40;
            int harga3 = meteran1 * int.parse(level3);
            total_harga = harga1 + harga2 + harga3;
        }
        
        Map<String, dynamic> pendataanData = {
          'id_petugas': id, // Replace with the actual ID
          'id_pelanggan': id_pelanggan,
          'nilai_meteran': nilai_meteran,
          'foto_meteran': foto_meteran.path,
          'total_penggunaan':total_penggunaan, // Set to 0 as it is not available at this stage
          'total_harga': total_harga, // Set to 0 as it is not available at this stage
          'status_pembayaran': 'Unpaid', // Set the initial status
          'created_at': DateTime.now().toString(),
          'updated_at': DateTime.now().toString(),
        };

        // Insert the data into the local database
        int insertedRowId = await dbHelper.insertPendataans(pendataanData);
        print('Pendataan inserted with ID: $insertedRowId');

        getPendataans();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> syncPendataanToAPI() async {
    try {

      final DatabaseHelper dbHelper = DatabaseHelper.instance;
      List<Map<String, dynamic>> unsyncedRecords =
          await dbHelper.queryUnsynchedRecords();

      if (unsyncedRecords.isNotEmpty) {
        EasyLoading.show(status: 'Mengsinkronkan data...');
        for (var record in unsyncedRecords) {
          String? id_pelanggan = record['id_pelanggan'];
          String? foto_meteranPath = record['foto_meteran'];
          int nilai_meteran = record['nilai_meteran'];

          // Check if the photo file exists locally
          // File foto_meteran = File(foto_meteranPath.toString());
          if (!foto_meteranPath!.isNotEmpty) {
            print(
                'Foto meteran file not found for Pendataan with id_pelanggan: $id_pelanggan');
            continue; // Skip this record if the photo file is not found
          }

          // Send the Pendataan data to the API
          await ResourceService().postPendataans(
            id_pelanggan: id_pelanggan,
            foto_meteran: foto_meteranPath,
            nilai_meteran: nilai_meteran,
          );
          // Update the status of the record in the local database to mark it as synced
          int id = record['id'];
            Map<String, dynamic> updatedRecord = {
              'id': id,
              'isSynced': 1,
            };
            await dbHelper.update(updatedRecord);
          
        }

        // After successful sync, delete all data from the local database
        await dbHelper.deleteSyncedPendataans();
        await getPendataansAll();
        EasyLoading.showSuccess('Sinkron data berhasil!');
      }else{
        EasyLoading.showInfo('Pendataan lokal kosong!');
      }
    } catch (e) {
      EasyLoading.showError('Gagal sinkron');
      // Handle any potential errors during the sync process
      print('Error syncing Pendataan to API: $e');
    }
  }
}
