import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:sispamdes/launcher_screen.dart';
import 'package:sispamdes/providers/auth_provider.dart';
import 'package:sispamdes/providers/pelanggan_provider.dart';
import 'package:sispamdes/providers/pendataan_provider.dart';
import 'package:sispamdes/screens/bantuan.dart';
import 'package:sispamdes/screens/login_screen.dart';
import 'package:sispamdes/screens/pelanggan.dart';
import 'package:sispamdes/screens/pelanggan_edit.dart';
import 'package:sispamdes/screens/pelanggandetail.dart';
import 'package:sispamdes/screens/pendataan_ocr.dart';
import 'package:sispamdes/screens/pendatan_input.dart';
import 'package:sispamdes/screens/profil.dart';
import 'package:sispamdes/screens/profil_edit.dart';
import 'package:sispamdes/screens/profil_ubahsandi.dart';
import 'package:sispamdes/screens/qr_screen.dart';
import 'package:sispamdes/screens/riwayat.dart';
import 'package:sispamdes/screens/riwayatdetail.dart';
import 'package:sispamdes/screens/splash_screen.dart';
import 'package:sispamdes/screens/syaratdanketentuan.dart';
import './screens/home_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  initializeDateFormatting('id_ID', '').then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => PelangganProvider()),
        ChangeNotifierProvider(create: (context) => PendataanProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: const LoginScreen(),
        // initialRoute: LoginScreen.routeName,
        
        routes: {
          '/': (context) => const SplashScreen(),
          '/launcher': (context) => const LauncherScreen(),
          // LauncherScreen.routeName:(context) => const LauncherScreen(),
          '/login': (context) => const LoginScreen(),
          LoginScreen.routeName:(context) => const LoginScreen(),
          HomeScreen.routeName:(context) => const HomeScreen(),
          Riwayat.routeName:(context) => const Riwayat(),
          RiwayatDetail.routeName:(context) => const RiwayatDetail(),
          PelangganScreen.routeName:(context) => const PelangganScreen(),
          PelangganDetail.routeName:(context) => const PelangganDetail(),
          PelangganEditScreen.routeName:(context) => const PelangganEditScreen(),
          ProfilScreen.routeName:(context) => const ProfilScreen(),
          ProfilEditScreen.routeName:(context) => const ProfilEditScreen(),
          UbahSandiScreen.routeName:(context) => const UbahSandiScreen(),
          SyaratScreen.routeName:(context) => const SyaratScreen(),
          BantuanScreen.routeName:(context) => const BantuanScreen(),
          // QrScreen.routeName: (context) => QrScreen(scannedResult: ModalRoute.of(context)?.settings.arguments  as String),
          QrScreen.routeName: (context) => const QrScreen(),
          PendataanInputScreen.routeName:(context) => const PendataanInputScreen(nilaiMeteran: '', scanData: '',),
          OCRScreen.routeName:(context) => const OCRScreen(),
        }, 
        builder: EasyLoading.init(),
      ),
    );
  }
}