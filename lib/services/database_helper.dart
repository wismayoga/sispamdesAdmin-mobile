import 'dart:io';

import 'package:path/path.dart';
import 'package:sispamdes/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/pelanggan_model.dart';
import '../models/pendataan_model.dart';
import '../models/harga_model.dart';

class DatabaseHelper {
  static const _databaseName = "sispamdes.db";
  static const _databaseVersion = 1;

  static const pelanggans = 'pelanggans';
  static const pendataans = 'pendataans';
  static const harga = 'harga';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      // await _database!.close();
      // await deleteDatabase(_database!.path);
      return _database!;
    }

    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    print('created database new1');
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    print(path);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute("""
        CREATE TABLE $pelanggans (
          id INTEGER, 
          role TEXT, 
          email TEXT, 
          nama TEXT, 
          status TEXT, 
          foto_profil TEXT,
          nomor_hp TEXT,
          alamat TEXT
          )""");
    await db.execute("""
        CREATE TABLE $pendataans (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          id_petugas TEXT, 
          id_pelanggan TEXT, 
          nilai_meteran INTEGER, 
          foto_meteran TEXT, 
          total_penggunaan INTEGER,
          total_harga INTEGER,
          status_pembayaran TEXT,
          created_at TEXT,
          updated_at TEXT,
          isSynced INTEGER
          )""");
    await db.execute("""
        CREATE TABLE $harga (
          id INTEGER PRIMARY KEY, 
          level1 TEXT, 
          level2 TEXT, 
          level3 TEXT, 
          created_at TEXT,
          updated_at TEXT
          )""");
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insertPelanggans(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(pelanggans, row);
  }

  Future<int> insertPendataans(Map<String, dynamic> row) async {
    row['isSynced'] = 0;
    Database db = await instance.database;
    return await db.insert(pendataans, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.

  Future<List<PelangganModel>> queryAllRowsPelanggans() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query('pelanggans');

    // Assuming PelangganModel.fromJson() is a constructor to convert a map to PelangganModel
    return results.map((row) => PelangganModel.fromJson(row)).toList();
  }

  Future<List<HargaModel>> queryAllRowsHarga() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query('harga');

    // Assuming PelangganModel.fromJson() is a constructor to convert a map to PelangganModel
    return results.map((row) => HargaModel.fromJson(row)).toList();
  }

  Future<List<PendataanModel>> queryAllRowsPendataans() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results =
        await db.query('pendataans WHERE isSynced = 0');

    // Assuming PelangganModel.fromJson() is a constructor to convert a map to PelangganModel
    return results.map((row) => PendataanModel.fromJson(row)).toList();
  }

  //Get all records which are unsynched
  Future<List<Map<String, dynamic>>> queryUnsynchedRecords() async {
    Database db = await instance.database;
    return await db.rawQuery(
        'SELECT id,id_pelanggan,foto_meteran,nilai_meteran FROM $pendataans WHERE isSynced = 0');
  }

  Future<List<Map<String, dynamic>>> queryAllRecordsPelanggans() async {
    Database db = await instance.database;
    return await db.rawQuery(
        'SELECT id,role,email,nama,status,foto_profil,nomor_hp,alamat FROM $pelanggans');
  }

  Future<List<Map<String, dynamic>>> queryAllRecordsPendataans() async {
    Database db = await instance.database;
    return await db.rawQuery(
        'SELECT id,id_petugas,id_pelanggan,nilai_meteran,foto_meteran,total_penggunaan,total_harga,status_pembayaran,created_at,updated_at FROM $pendataans');
  }

  Future<Map<String, dynamic>> queryFirstRecordHarga() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.rawQuery(
        'SELECT level1, level2, level3 FROM $harga LIMIT 1'); // Using LIMIT 1 to retrieve only the first record
    if (results.isNotEmpty) {
      return results.first; // Return the first record
    } else {
      return {}; // Return an empty map if no records were found
    }
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $pelanggans'))!;
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update(pendataans, row, where: 'id = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(pelanggans, where: 'id = ?', whereArgs: [id]);
  }

  //download pelanggan
  // ...

  // Function to insert data from PelanggansAPI to db.Helper
  Future<void> insertPelanggansFromAPIv1(
      List<PelangganModel> pelanggansAPI) async {
    try {
      Database db = await instance.database;
      Batch batch = db.batch();

      // Loop through the list of PelangganModel and insert each row into the database
      for (var pelanggan in pelanggansAPI) {
        batch.insert(pelanggans, pelanggan.toJson());
      }

      // Commit the batch insert
      await batch.commit();
    } catch (e) {
      // Handle any potential errors during the insert process
      print('Error inserting data from API to database: $e');
    }
  }

  Future<void> insertPelanggansFromAPI(
      List<PelangganModel> pelanggansAPI) async {
    Database db = await instance.database;

    for (var pelanggan in pelanggansAPI) {
      await insertOrUpdatePelanggan(db, pelanggan);
    }
  }

  Future<void> insertOrUpdatePelanggan(
      Database db, PelangganModel pelanggan) async {
    List<Map<String, dynamic>> existingRecords = await db.query(
      'pelanggans',
      where: 'id = ?',
      whereArgs: [pelanggan.id],
    );

    if (existingRecords.isNotEmpty) {
      // If the record exists, update it
      await db.update(
        'pelanggans',
        pelanggan
            .toJson(), // Assuming toJson() converts PelangganModel to a map
        where: 'id = ?',
        whereArgs: [pelanggan.id],
      );
    } else {
      // If the record doesn't exist, insert it as a new record
      await db.insert('pelanggans', pelanggan.toJson());
    }
  }

  Future<void> insertHargaFromAPI(List<HargaModel> hargaAPI) async {
    Database db = await instance.database;

    for (var harga in hargaAPI) {
      await insertOrUpdateHarga(db, harga);
    }
  }

  Future<void> insertOrUpdateHarga(Database db, HargaModel harga) async {
    List<Map<String, dynamic>> existingRecords = await db.query(
      'harga',
      where: 'id = ?',
      whereArgs: [harga.id],
    );

    if (existingRecords.isNotEmpty) {
      // If the record exists, update it
      await db.update(
        'harga',
        harga.toJson(), // Assuming toJson() converts PelangganModel to a map
        where: 'id = ?',
        whereArgs: [harga.id],
      );
    } else {
      // If the record doesn't exist, insert it as a new record
      await db.insert('harga', harga.toJson());
    }
  }

  Future<void> deleteSyncedPendataans() async {
    try {
      Database db = await instance.database;
      await db.delete(pendataans, where: 'isSynced = ?', whereArgs: [1]);
      print('sudah dihapus');
    } catch (e) {
      // Handle any potential errors during the delete process
      print('Error deleting synced Pendataan data: $e');
    }
  }

  Future<int> updateUserByEmail(PelangganModel user) async {
    Database db = await instance.database;

    // Define the values you want to update
    Map<String, dynamic> valuesToUpdate = {
      'nama': user.nama,
      'nomor_hp': user.nomor_hp,
      'alamat': user.alamat
    };

    // Perform the update based on the email
    return await db.update(
      'pelanggans', // Replace with your table name if necessary
      valuesToUpdate,
      where: 'email = ?', // Specify the condition for updating
      whereArgs: [user.email], // The email value to match
    );
  }
}
