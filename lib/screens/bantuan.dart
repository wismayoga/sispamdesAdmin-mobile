import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sispamdes/theme.dart';

class BantuanScreen extends StatelessWidget {
  const BantuanScreen({super.key});
  static const routeName = "/bantuanscreen";

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
                          "Pusat Bantuan",
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
                      "Pusat Bantuan",
                      style: secondaryTextStyle.copyWith(
                        fontSize: 14,
                        color: primaryColor,
                        fontWeight: semiBold,
                      ),
                    ),
                    Text(
                      "Butuh bantuan? jika kamu mengalami kendala saat pemakaian aplikasi SISPAM-Des bisa kamu tanyakan pada kamu melalui salah satu platform berikut ya!",
                      style: secondaryTextStyle.copyWith(
                        fontSize: 12,
                        color: primaryTextColor,
                        fontWeight: regular,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Hubungi Kami",
                      style: secondaryTextStyle.copyWith(
                        fontSize: 14,
                        color: primaryColor,
                        fontWeight: semiBold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: greyColor.withOpacity(1),
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/bantuan_email.svg',
                                  width: 20,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "admin-sispamdes@gmail.com",
                                  style: secondaryTextStyle.copyWith(
                                    fontSize: 14,
                                    fontWeight: regular,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: greyColor.withOpacity(1),
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/bantuan_wasap.svg',
                                  width: 20,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "+62821-4693-0640",
                                  style: secondaryTextStyle.copyWith(
                                    fontSize: 14,
                                    fontWeight: regular,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: greyColor.withOpacity(1),
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/bantuan_ig.svg',
                                  width: 20,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "@sispamdes",
                                  style: secondaryTextStyle.copyWith(
                                    fontSize: 14,
                                    fontWeight: regular,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: greyColor.withOpacity(1),
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/bantuan_hp.svg',
                                  width: 20,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "+62821-4693-0640",
                                  style: secondaryTextStyle.copyWith(
                                    fontSize: 14,
                                    fontWeight: regular,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
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
