import 'package:flutter/material.dart';
import 'package:sispamdes/theme.dart';

class SyaratScreen extends StatelessWidget {
  const SyaratScreen({super.key});
  static const routeName = "/syaratscreen";
  @override
  Widget build(BuildContext context) {
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
                          "Syarat dan Ketentuan",
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Biodata",
                      style: secondaryTextStyle.copyWith(
                        fontSize: 14,
                        color: primaryColor,
                        fontWeight: semiBold,
                      ),
                    ),
                    Text(
                      "Pengguna diwajibkan untuk membaca seluruh Syarat dan Ketentuan ini dengan seksama, dan dapat menghubungi pihak SISPAM-Des jika memiliki pertanyaan.",
                      style: secondaryTextStyle.copyWith(
                        fontSize: 12,
                        color: primaryTextColor,
                        fontWeight: regular,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Syarat dan Ketentuan ini mengatur pemakian dan akses pengguna terhadap aplikasi, website, konten yang disediakan oleh SISPAM-Des. Dengan mengakses atau menggunakan aplikasi layanan SISPAM-Des, Pengguna setuju dan mematuhi “Syarat dan ketentuan Aplikasi SISPAM-Des”.",
                      style: secondaryTextStyle.copyWith(
                        fontSize: 12,
                        color: primaryTextColor,
                        fontWeight: regular,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Definisi",
                      style: secondaryTextStyle.copyWith(
                        fontSize: 14,
                        color: primaryColor,
                        fontWeight: semiBold,
                      ),
                    ),
                    Text(
                      "SISPAM-Des merupakan aplikasi pengelolaan dan management penggunaan air desa khususnya dalam pendataan air minum desa yang memudahkan petugas dalam mendata menggunakan aplikasi mobile SISPAM-Des.",
                      style: secondaryTextStyle.copyWith(
                        fontSize: 12,
                        color: primaryTextColor,
                        fontWeight: regular,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Ketentuan Umum",
                      style: secondaryTextStyle.copyWith(
                        fontSize: 14,
                        color: primaryColor,
                        fontWeight: semiBold,
                      ),
                    ),
                    Text(
                      "Aplikasi SISPAM-Des dapat digunakan setelah pengguna menyetujui syarat dan ketentuan yang berlaku pada aplikasi SISPAM-Des.",
                      style: secondaryTextStyle.copyWith(
                        fontSize: 12,
                        color: primaryTextColor,
                        fontWeight: regular,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Pengguna aplikasi SISPAM-Des dapat melakukan pendaftaran akun di Admin BUMDes.",
                      style: secondaryTextStyle.copyWith(
                        fontSize: 12,
                        color: primaryTextColor,
                        fontWeight: regular,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Pengguna dengan peran pelanggan dapat menggunakan aplikasi dengan fitur-fitur seperti melihat statistik penggunaan air bulanan, mengubah profil serta memberikan kritik maupun saran kepada pihak pengelola SISPAM-Des.",
                      style: secondaryTextStyle.copyWith(
                        fontSize: 12,
                        color: primaryTextColor,
                        fontWeight: regular,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Pengguna dengan peran petugas dapat menggunakan aplikasi dengan fitur-fitur seperti melakukan pendataan, melihat progres pendataan, mengubah profil pelanggan dan pengguna.",
                      style: secondaryTextStyle.copyWith(
                        fontSize: 12,
                        color: primaryTextColor,
                        fontWeight: regular,
                      ),
                      textAlign: TextAlign.justify,
                    ),
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
