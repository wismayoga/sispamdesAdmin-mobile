import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sispamdes/models/user_model.dart';
import 'package:sispamdes/providers/auth_provider.dart';
import 'package:sispamdes/services/auth_service.dart';
import 'package:sispamdes/theme.dart';
import '../widget/custom_button.dart';

class UbahSandiScreen extends StatefulWidget {
  const UbahSandiScreen({super.key});
  static const routeName = "/ubahsandiscreen";

  @override
  State<UbahSandiScreen> createState() => _ProfilEditScreenState();
}

class _ProfilEditScreenState extends State<UbahSandiScreen> {
  final formkey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController passwordlamaController =
      TextEditingController(text: '');
  TextEditingController passwordbaruController =
      TextEditingController(text: '');
  TextEditingController passwordconfirmController =
      TextEditingController(text: '');

  bool hidden1 = true;
  bool hidden2 = true;
  bool hidden3 = true;
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    UserModel user = authProvider.user;
    // HIDDEN PASSWORD
    passwordHidden1() async {
      setState(() {
        hidden1 = !hidden1;
      });
    }

    passwordHidden2() async {
      setState(() {
        hidden2 = !hidden2;
      });
    }

    passwordHidden3() async {
      setState(() {
        hidden3 = !hidden3;
      });
    }

    handleInput() async {
      setState(() {
        isLoading = true;
      });

      if (await AuthService().editPassword(
        old_password: passwordlamaController.text,
        new_password: passwordbaruController.text,
        new_password_confirm: passwordconfirmController.text,
      )) {
        // Navigator.pop(context);
        if (await authProvider.logout(
          token: user.token!,
        )) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Password Berhasil Diubah!',
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Password Gagal Diubah!',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }

      setState(() {
        isLoading = false;
      });
    }

    // PASSWORD INPUT
    Widget passwordInput() {
      return Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Password Lama',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: double.infinity,
              child: TextFormField(
                cursorColor: primaryTextColor,
                controller: passwordlamaController,
                obscureText: hidden1,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Masukkan Password Lama";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
                  hintText: 'Masukkan Password',
                  // filled: true,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: primaryTextColor),
                    borderRadius: BorderRadius.circular(
                      12,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: primaryColor,
                    ),
                  ),
                  prefixIcon: SvgPicture.asset(
                    'assets/password_icon.svg',
                    width: 10,
                    height: 10,
                    fit: BoxFit.scaleDown,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: passwordHidden1,
                    child: SvgPicture.asset(
                      hidden1
                          ? 'assets/eye_slash_icon.svg'
                          : 'assets/eye_icon.svg',
                      width: 18,
                      height: 18,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    //PASSWORD BARU
    Widget passwordBaruInput() {
      return Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Password Baru',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: double.infinity,
              child: TextFormField(
                cursorColor: primaryTextColor,
                controller: passwordbaruController,
                obscureText: hidden2,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Masukkan Password Baru";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
                  hintText: 'Masukkan Password',
                  // filled: true,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: primaryTextColor),
                    borderRadius: BorderRadius.circular(
                      12,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: primaryColor,
                    ),
                  ),
                  prefixIcon: SvgPicture.asset(
                    'assets/password_icon.svg',
                    width: 10,
                    height: 10,
                    fit: BoxFit.scaleDown,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: passwordHidden2,
                    child: SvgPicture.asset(
                      hidden2
                          ? 'assets/eye_slash_icon.svg'
                          : 'assets/eye_icon.svg',
                      width: 18,
                      height: 18,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    //PASSWORD CONFIRM
    Widget passwordConfirmInput() {
      return Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ulang Password Baru',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: double.infinity,
              child: TextFormField(
                cursorColor: primaryTextColor,
                controller: passwordconfirmController,
                obscureText: hidden3,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Masukkan Ulang Password Baru";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
                  hintText: 'Masukkan Password',
                  // filled: true,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: primaryTextColor),
                    borderRadius: BorderRadius.circular(
                      12,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: primaryColor,
                    ),
                  ),
                  prefixIcon: SvgPicture.asset(
                    'assets/password_icon.svg',
                    width: 10,
                    height: 10,
                    fit: BoxFit.scaleDown,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: passwordHidden3,
                    child: SvgPicture.asset(
                      hidden3
                          ? 'assets/eye_slash_icon.svg'
                          : 'assets/eye_icon.svg',
                      width: 18,
                      height: 18,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Container(
        color: whiteColor,
        child: SafeArea(
            child: Column(
          children: [
            //header
            Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.01,
                      blurRadius: 2,
                      offset: const Offset(
                          0, 0), // changes the position of the shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: blueTextColor,
                        size: 18,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    Flexible(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Ubah Kata Sandi",
                          style: blueTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: semiBold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                )),
            Expanded(
                child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: double.infinity,
                child: Column(
                  children: [
                    passwordInput(),
                    passwordBaruInput(),
                    passwordConfirmInput(),
                    const SizedBox(
                      height: 40,
                    ),
                    CustomButton(
                      text: 'Ubah Kata Sandi',
                      color: primaryColor,
                      press: () {
                        handleInput();
                      },
                    )
                  ],
                ),
              ),
            ))
          ],
        )),
      ),
    );
  }
}
