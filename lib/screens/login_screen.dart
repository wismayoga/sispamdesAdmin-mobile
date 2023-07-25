import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sispamdes/providers/auth_provider.dart';
import 'package:sispamdes/theme.dart';
import '../widget/custom_button.dart';
import '../widget/custom_text_form_field.dart';
import '../widget/loading_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = "/loginscreen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');

  bool hidden = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    // HIDDEN PASSWORD
    passwordHidden() async {
      setState(() {
        hidden = !hidden;
      });
    }

    // HANDLE LOGIN
    loginHandle() async {
      setState(() {
        isLoading = true;
      });

      if (await authProvider.login(
        email: emailController.text,
        password: passwordController.text,
      )) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/launcher', (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Gagal Login!',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }

      setState(() {
        isLoading = false;
      });
    }

    // HEADER
    Widget header() {
      return Container(
        margin: const EdgeInsets.only(top: 50),
        width: double.infinity,
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/icon.png'),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // LOGIN TEXT
    Widget textLogin() {
      return Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'SISPAM-DES',
              style: blueTextStyle.copyWith(
                fontSize: 18,
                fontWeight: semiBold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'Masuk',
              style: primaryTextStyle.copyWith(
                fontSize: 24,
                fontWeight: semiBold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Silahkan Masukkan Email dan kata sandi kamu yang sudah terdaftar!',
              style: primaryTextStyle.copyWith(
                fontSize: 12,
                color: const Color(0xFF728196),
                fontWeight: regular,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // // EMAIL INPUT
    Widget emailInput() {
      return Container(
        margin: const EdgeInsets.only(top: 25),
        child: CustomTextFormField(
          title: 'Email',
          hint: 'Masukkan Email',
          icon: 'assets/bantuan_email.svg',
          controller: emailController,
          keyboardType: TextInputType.text,
          validator: (value) {
            // NULL
            if (value!.isEmpty) {
              return "Masukkan email";
            }
            // VALID EMAIL
            const pattern =
                r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
            final regExp = RegExp(pattern);

            if (!regExp.hasMatch(value)) {
              return "Masukkan email yang valid";
            }
            return null;
          },
        ),
      );
    }

    // // PASSWORD INPUT
    Widget passwordInput() {
      return Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Password',
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
                controller: passwordController,
                obscureText: hidden,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Masukkan Password";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
                  hintText: 'Masukkan Password',
                  hintStyle: primaryTextStyle.copyWith(
                    fontSize: 12,
                    color: const Color(0xFF728196),
                    fontWeight: regular,
                  ),
                  fillColor: greyColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: whiteColor),
                    borderRadius: BorderRadius.circular(12),
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
                    onTap: passwordHidden,
                    child: SvgPicture.asset(
                      hidden
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

    // BUTTON LOGIN
    Widget buttonLogin() {
      return Container(
        margin: const EdgeInsets.only(top: 30),
        child: CustomButton(
          text: 'Masuk',
          color: primaryColor,
          press: () {
            if (formkey.currentState!.validate()) {
              loginHandle();
            }
          },
        ),
      );
    }

    // BUTTON LOGIN
    Widget buttonLoading() {
      return Container(
        margin: const EdgeInsets.only(top: 30),
        child: const LoadingButton(
          color: primaryColor,
        ),
      );
    }

    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  header(),
                  textLogin(),
                  emailInput(),
                  passwordInput(),
                  isLoading ? buttonLoading() : buttonLogin(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
