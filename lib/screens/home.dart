import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sispamdes/models/user_model.dart';
import 'package:sispamdes/providers/auth_provider.dart';
import '../theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/percent_indicator.dart';

//home
class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // _isMounted = false;
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    UserModel user = authProvider.user;

    // LOGOUT HANDLE
    handleLogout() async {
      setState(() {
        isLoading = true;
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          );
        },
      );

      if (await authProvider.logout(
        token: user.token!,
      )) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Gagal Logout!',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }

    return Container(
      color: greyColor,
      child: SafeArea(
        child: Column(
          children: [
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
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Halo,",
                          style: secondaryTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: regular,
                          ),
                        ),
                        Text(
                          user.nama.toString(),
                          style: blueTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: semiBold,
                          ),
                        ),
                      ],
                    ),
                    IconButton( 
                      icon: const Icon(Icons.favorite),
                      onPressed: handleLogout),
                  ],
                )),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      width: double.infinity,
                      // height: 500,
                      child: Column(
                        children: [
                          Column(
                            children: [
                              //Progres Pendataan
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Progres Bulan Ini",
                                        style: secondaryTextStyle.copyWith(
                                          fontSize: 12,
                                          color: secondaryColor,
                                          fontWeight: regular,
                                        ),
                                      ),
                                      IconButton(
                                        iconSize: 12,
                                        icon: const Icon(Icons.info_outline),
                                        color: primaryColor,
                                        onPressed: () {
                                          // ...
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              //Container Progres Pendataan
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                decoration: BoxDecoration(
                                    color: whiteColor,
                                    border: Border.all(
                                      color: whiteColor,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                child: Row(
                                  children: [
                                    CircularPercentIndicator(
                                      radius: 50.0,
                                      lineWidth: 17.0,
                                      animation: true,
                                      percent: 0.7,
                                      center: Text(
                                        "70.0%",
                                        style: secondaryTextStyle.copyWith(
                                          fontSize: 14,
                                          color: blueTextColor,
                                          fontWeight: semiBold,
                                        ),
                                      ),
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      progressColor: primaryColor,
                                      backgroundColor: secondaryColor,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Periode : Juni 2023",
                                          style: blueTextStyle.copyWith(
                                            fontSize: 12,
                                            color: blueTextColor,
                                            fontWeight: semiBold,
                                          ),
                                        ),
                                        Text(
                                          "Total : 545 / 825",
                                          style: blueTextStyle.copyWith(
                                            fontSize: 12,
                                            color: blueTextColor,
                                            fontWeight: semiBold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Container Pendataan
                              Column(
                                children: [
                                  //text pendataan
                                  Row(
                                    children: [
                                      Text(
                                        "Pendataan",
                                        style: secondaryTextStyle.copyWith(
                                          fontSize: 12,
                                          color: secondaryColor,
                                          fontWeight: regular,
                                        ),
                                      ),
                                      IconButton(
                                        iconSize: 12,
                                        icon: const Icon(Icons.info_outline),
                                        color: primaryColor,
                                        onPressed: () {
                                          // ...
                                        },
                                      ),
                                    ],
                                  ),
                                  //list button pendataan
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox.fromSize(
                                        size: const Size(56, 56),
                                        child: ClipOval(
                                          child: Material(
                                            color: primaryColor,
                                            child: InkWell(
                                              splashColor: secondaryColor,
                                              onTap: () {},
                                              child: const Icon(
                                                Icons.qr_code,
                                                size: 25.0,
                                                color: whiteColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox.fromSize(
                                        size: const Size(56, 56),
                                        child: ClipOval(
                                          child: Material(
                                            color: primaryColor,
                                            child: InkWell(
                                              splashColor: secondaryColor,
                                              onTap: () {},
                                              child: const Icon(
                                                Icons.search,
                                                size: 25.0,
                                                color: whiteColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox.fromSize(
                                        size: const Size(56, 56),
                                        child: ClipOval(
                                          child: Material(
                                            color: primaryColor,
                                            child: InkWell(
                                              splashColor: secondaryColor,
                                              onTap: () {},
                                              child: const Icon(
                                                Icons.history,
                                                size: 25.0,
                                                color: whiteColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox.fromSize(
                                        size: const Size(56, 56),
                                        child: ClipOval(
                                          child: Material(
                                            color: primaryColor,
                                            child: InkWell(
                                              splashColor: secondaryColor,
                                              onTap: () {},
                                              child: const Icon(
                                                Icons.notes,
                                                size: 25.0,
                                                color: whiteColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),

                              //container SISPAMDES
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Fitur SISPAM-Des",
                                        style: secondaryTextStyle.copyWith(
                                          fontSize: 12,
                                          color: secondaryColor,
                                          fontWeight: regular,
                                        ),
                                      ),
                                      IconButton(
                                        iconSize: 12,
                                        icon: const Icon(Icons.info_outline),
                                        color: primaryColor,
                                        onPressed: () {
                                          // ...
                                        },
                                      ),
                                    ],
                                  ),

                                  //Unduh
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    decoration: BoxDecoration(
                                        color: whiteColor,
                                        border: Border.all(
                                          color: whiteColor,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/fitursispam_unduh.svg',
                                          width: 70,
                                        ),
                                        const Spacer(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "Unduh Data Pelanggan",
                                              style:
                                                  secondaryTextStyle.copyWith(
                                                fontSize: 12,
                                                color: blueTextColor,
                                                fontWeight: semiBold,
                                              ),
                                            ),
                                            Text(
                                              "Unduh data pelanggan yang baru",
                                              style:
                                                  secondaryTextStyle.copyWith(
                                                fontSize: 9,
                                                color: secondaryTextColor,
                                                fontWeight: regular,
                                              ),
                                            ),
                                            Text(
                                              "Pelanggan baru : 10",
                                              style:
                                                  secondaryTextStyle.copyWith(
                                                fontSize: 9,
                                                color: secondaryTextColor,
                                                fontWeight: regular,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            TextButton(
                                              onPressed: () {},
                                              style: TextButton.styleFrom(
                                                foregroundColor: whiteColor,
                                                backgroundColor: primaryColor,
                                                textStyle:
                                                    secondaryTextStyle.copyWith(
                                                  fontSize: 10,
                                                  color: secondaryTextColor,
                                                  fontWeight: regular,
                                                ),
                                              ),
                                              child: const Text(
                                                'Unduh Data',
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  //Sinkron data
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    decoration: BoxDecoration(
                                        color: whiteColor,
                                        border: Border.all(
                                          color: whiteColor,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/fitursispam_sinkron.svg',
                                          width: 80,
                                        ),
                                        const Spacer(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "Sinkron Data",
                                              style:
                                                  secondaryTextStyle.copyWith(
                                                fontSize: 12,
                                                color: blueTextColor,
                                                fontWeight: semiBold,
                                              ),
                                            ),
                                            Text(
                                              "Sinkron data perangkat ke server",
                                              style:
                                                  secondaryTextStyle.copyWith(
                                                fontSize: 9,
                                                color: secondaryTextColor,
                                                fontWeight: regular,
                                              ),
                                            ),
                                            Text(
                                              "Data belum disinkron : 250",
                                              style:
                                                  secondaryTextStyle.copyWith(
                                                fontSize: 9,
                                                color: secondaryTextColor,
                                                fontWeight: regular,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            TextButton(
                                              onPressed: () {},
                                              style: TextButton.styleFrom(
                                                foregroundColor: whiteColor,
                                                backgroundColor: primaryColor,
                                                textStyle:
                                                    secondaryTextStyle.copyWith(
                                                  fontSize: 10,
                                                  color: secondaryTextColor,
                                                  fontWeight: regular,
                                                ),
                                              ),
                                              child: const Text(
                                                'Sinkron Sekarang',
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      )),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
