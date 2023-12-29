import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sispamdes/providers/pendataan_provider.dart';
import 'package:sispamdes/screens/home_screen.dart';

import 'providers/pelanggan_provider.dart';
// import 'providers/wilayah_provider.dart';
import 'theme.dart';

class LauncherScreen extends StatefulWidget {
  const LauncherScreen({Key? key}) : super(key: key);
  static const routeName = "/launcherscreen";

  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> {
  @override
  void initState() {
    main();
    super.initState();
    // SET PROVIDER
    Provider.of<PelangganProvider>(context, listen: false).getPelanggans();
    Provider.of<PendataanProvider>(context, listen: false).getPendataans();
  }

  main() {
    Future.delayed(const Duration(seconds: 1), () {
      // Navigator.pushNamed(context, '/home');
      Navigator.of(context).pushNamed(HomeScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
