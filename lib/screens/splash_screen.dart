import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sispamdes/screens/login_screen.dart';

import '../providers/auth_provider.dart';
import '../theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const routeName = "/splashscreen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    cekLogin();
    super.initState();
  }

  cekLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool islogin = prefs.getBool('isLogin') ?? false;
    String? token = prefs.getString('token');

    // Get user Data
    if (islogin == true) {
      //ignore: avoid_print
      print('login true');
      await Provider.of<AuthProvider>(context, listen: false).getUser(token);
    }
      //ignore: avoid_print
      print('ISLOGIN : $islogin TOKEN : $token');
      islogin
          ? Navigator.pushNamed(context, '/launcher')
          : Navigator.of(context).pushNamed(LoginScreen.routeName);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Image.asset(
          "assets/icon.png",
          width: 180,
        ),
      ),
    );
  }
}
