
import 'package:flutter/material.dart';
import '../models/pendataan_model.dart';
import '../services/resource_service.dart';

class PendataanProvider with ChangeNotifier {
  List<PendataanModel> _pendataans = [];

  List<PendataanModel> get pendataans => _pendataans;

  set pendataans(List<PendataanModel> pendataans) {
    _pendataans = pendataans;
    notifyListeners();
  }

  //get pendataan
  Future<void> getPendataans() async {
    try {
      List<PendataanModel> pendataans = await ResourceService().getPendataans();
      _pendataans = pendataans;
      notifyListeners();
      print('ini get pendataan jalan');
    } catch (e) {
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
      final lastMonthData = pendataans.firstWhere(
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

  //post pendataan
  Future<void> postPendataan(
    // ignore: non_constant_identifier_names
    String? id_pelanggan,
    // ignore: non_constant_identifier_names
    foto_meteran,
    // ignore: non_constant_identifier_names
    int nilai_meteran,
  ) async {
    try {
      if (foto_meteran != null) {
        await ResourceService()
            .postPendataans(
                id_pelanggan: id_pelanggan,
                foto_meteran: foto_meteran.path,
                nilai_meteran: nilai_meteran);
      }
    } catch (e) {
      //ignore: avoid_print
      print(e);
    }
  }
}
