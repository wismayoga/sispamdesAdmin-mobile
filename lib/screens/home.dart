import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sispamdes/models/pendataan_model.dart';
import 'package:sispamdes/models/user_model.dart';
import 'package:sispamdes/providers/auth_provider.dart';
import 'package:sispamdes/providers/pelanggan_provider.dart';
import 'package:sispamdes/providers/pendataan_provider.dart';
import 'package:sispamdes/utils/shared_preferences.dart';
import '../theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sispamdes/screens/qr_screen.dart';
import 'package:sispamdes/screens/pendatan_input.dart';

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
  UserModel? userData;

  @override
  void initState() {
    super.initState();
    
    getUserData().then((data) {
      setState(() {
        userData = data;
      });
    });
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
    });
  }

  @override
  void dispose() {
    // _isMounted = false;
    super.dispose();
  }

  Future<UserModel?> getUserData() async {
    UserPreferences userPreferences = UserPreferences();
    UserModel? userData = await userPreferences.getUser();
    return userData;
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> checkInternetConnection() async {
      var connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    }

    void showNoInternetConnectionPopup() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child: SizedBox(
              height: 330,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/nointernet.svg',
                    height: 120,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Whoops!",
                    style: primaryTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semiBold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Tidak ada koneksi internet. \nPeriksa pengaturan koneksi anda",
                    style: secondaryTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: regular,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        backgroundColor: primaryDarkColor),
                    child: Text(
                      "OK",
                      style: secondaryTextStyle.copyWith(
                        fontSize: 12,
                        color: whiteColor,
                        fontWeight: regular,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    }

    //sync data
    final pendataanProvider =
        Provider.of<PendataanProvider>(context, listen: true);
    // AuthProvider authProvider = Provider.of<AuthProvider>(context);
    // UserModel user = authProvider.user;
    var dateFormat = DateFormat('MMMM yyyy', 'id_ID');

    final pelanggan = Provider.of<PelangganProvider>(context, listen: true);
    var jumlahPelanggan = pelanggan.pelanggans.length;

    // Get the current month and year in Indonesian language
    String currentMonthYear = dateFormat.format(DateTime.now());

    // Extract the month and year from the currentMonthYear string
    List<String> dateParts = currentMonthYear.split(' ');
    int currentMonth = DateFormat.MMMM('id_ID').parse(dateParts[0]).month;
    int currentYear = int.parse(dateParts[1]);

    // Filter the pendataans list by the current month and year
    List<PendataanModel> pendataansThisMonth =
        pendataanProvider.pendataansOnline.where((pendataan) {
      DateTime createdAtDate = DateTime.parse(pendataan.created_at
          .toString()); // Assuming createdAt is a String in the format 'yyyy-MM-dd'
      return createdAtDate.month == currentMonth &&
          createdAtDate.year == currentYear;
    }).toList();

    // Get the count of pendataans in the current month
    int jumlahPendataan = 0;

    int percentage;
    if (jumlahPelanggan != 0) {
      percentage = ((jumlahPendataan / jumlahPelanggan) * 100).toInt();
    } else {
      percentage = 0; // Set percentage to 0 when there are no customers.
    }

    final pelangganProvider =
        Provider.of<PelangganProvider>(context, listen: false);
    final pelanggans = pelangganProvider.pelanggans;

    void noPelanggan() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child: SizedBox(
              height: 330,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/nopelanggan.svg',
                    height: 120,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Whoops!",
                    style: primaryTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semiBold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Tidak ditemukan pelanggan. \nUnduh pelanggan terlebih dahulu",
                    style: secondaryTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: regular,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        backgroundColor: primaryDarkColor),
                    child: Text(
                      "OK",
                      style: secondaryTextStyle.copyWith(
                        fontSize: 12,
                        color: whiteColor,
                        fontWeight: regular,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    }

    // LOGOUT HANDLE
    // handleLogout() async {
    //   setState(() {
    //     isLoading = true;
    //   });

    //   showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (BuildContext context) {
    //       return const Center(
    //         child: CircularProgressIndicator(
    //           color: primaryColor,
    //         ),
    //       );
    //     },
    //   );

    //   if (await authProvider.logout(
    //     token: user.token!,
    //   )) {
    //     Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         backgroundColor: Colors.red,
    //         content: Text(
    //           'Gagal Logout!',
    //           textAlign: TextAlign.center,
    //         ),
    //       ),
    //     );
    //   }
    // }


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
                          userData?.nama ?? "Loading...",
                          style: blueTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: semiBold,
                          ),
                        ),
                      ],
                    ),
                    // IconButton(
                    //     icon: const Icon(Icons.favorite),
                    //     onPressed: handleLogout),
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
                                      percent: percentage / 100,
                                      center: Text(
                                        "$percentage%",
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
                                          "$currentMonthYear",
                                          style: blueTextStyle.copyWith(
                                            fontSize: 12,
                                            color: blueTextColor,
                                            fontWeight: semiBold,
                                          ),
                                        ),
                                        Text(
                                          "Total : $jumlahPendataan / $jumlahPelanggan",
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
                                              onTap: () {
                                                if (pelanggans.isNotEmpty) {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          QrScreen.routeName);
                                                } else {
                                                  noPelanggan();
                                                }
                                              },
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
                                              onTap: () {
                                                if (pelanggans.isNotEmpty) {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          PendataanInputScreen
                                                              .routeName);
                                                } else {
                                                  noPelanggan();
                                                }
                                              },
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
                                              onTap: () async {
                                                bool isConnected =
                                                    await checkInternetConnection();
                                                if (isConnected) {
                                                  pendataanProvider
                                                      .syncPendataanToAPI();
                                                } else {
                                                  showNoInternetConnectionPopup();
                                                }
                                              },
                                              child: const Icon(
                                                Icons.sync,
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
                                              onTap: () async {
                                                bool isConnected =
                                                    await checkInternetConnection();
                                                if (isConnected) {
                                                  pendataanProvider
                                                      .getPendataansAll();
                                                } else {
                                                  showNoInternetConnectionPopup();
                                                }
                                              },
                                              child: const Icon(
                                                Icons.update,
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
                                            // Text(
                                            //   "Pelanggan baru : -",
                                            //   style:
                                            //       secondaryTextStyle.copyWith(
                                            //     fontSize: 9,
                                            //     color: secondaryTextColor,
                                            //     fontWeight: regular,
                                            //   ),
                                            // ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                bool isConnected =
                                                    await checkInternetConnection();
                                                if (isConnected) {
                                                  Provider.of<PelangganProvider>(
                                                          context,
                                                          listen: false)
                                                      .downloadPelanggans();
                                                } else {
                                                  showNoInternetConnectionPopup();
                                                }
                                              },
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

                                  //Unduh data riwayat
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
                                          'assets/fitursispam_update.svg',
                                          width: 80,
                                        ),
                                        const Spacer(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "Update Pendataan Server",
                                              style:
                                                  secondaryTextStyle.copyWith(
                                                fontSize: 12,
                                                color: blueTextColor,
                                                fontWeight: semiBold,
                                              ),
                                            ),
                                            Text(
                                              "Data pendataan dari server",
                                              style:
                                                  secondaryTextStyle.copyWith(
                                                fontSize: 9,
                                                color: secondaryTextColor,
                                                fontWeight: regular,
                                              ),
                                            ),
                                            // Text(
                                            //   "Jumlah pendataan : -",
                                            //   style:
                                            //       secondaryTextStyle.copyWith(
                                            //     fontSize: 9,
                                            //     color: secondaryTextColor,
                                            //     fontWeight: regular,
                                            //   ),
                                            // ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                bool isConnected =
                                                    await checkInternetConnection();
                                                if (isConnected) {
                                                  pendataanProvider
                                                      .getPendataansAll();
                                                } else {
                                                  showNoInternetConnectionPopup();
                                                }
                                              },
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
                                                'Update Data',
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
                                            // Text(
                                            //   "Data belum disinkron : -",
                                            //   style:
                                            //       secondaryTextStyle.copyWith(
                                            //     fontSize: 9,
                                            //     color: secondaryTextColor,
                                            //     fontWeight: regular,
                                            //   ),
                                            // ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                bool isConnected =
                                                    await checkInternetConnection();
                                                if (isConnected) {
                                                  pendataanProvider
                                                      .syncPendataanToAPI();
                                                } else {
                                                  showNoInternetConnectionPopup();
                                                }
                                              },
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
