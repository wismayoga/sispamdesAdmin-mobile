import 'package:flutter/material.dart';

import '../models/pelanggan_model.dart';
import '../services/resource_service.dart';

class PelangganProvider with ChangeNotifier {
  List<PelangganModel> _pelanggans = [];

  List<PelangganModel> get pelanggans => _pelanggans;

  set pelanggans(List<PelangganModel> pelanggans) {
    _pelanggans = pelanggans;
    notifyListeners();
  }

  Future<void> getPelanggans() async {
    try {
      List<PelangganModel> pelanggans = await ResourceService().getPelanggans();
      _pelanggans = pelanggans;
    } catch (e) {
      //ignore: avoid_print
      print(e);
    }
  }
}
