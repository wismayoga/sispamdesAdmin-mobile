import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sispamdes/models/user_model.dart';
import 'package:sispamdes/providers/auth_provider.dart';
import 'package:sispamdes/screens/bantuan.dart';
import 'package:sispamdes/screens/profil_edit.dart';
import 'package:sispamdes/screens/profil_ubahsandi.dart';
import 'package:sispamdes/screens/syaratdanketentuan.dart';
import 'package:sispamdes/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sispamdes/utils/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});
  static const routeName = "/profilscreen";

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final formkey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<UserModel?> getUserData() async {
    UserPreferences userPreferences = UserPreferences();
    UserModel? userData = await userPreferences.getUser();
    return userData;
  }

  @override
  Widget build(BuildContext context) {
    // final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // final user = authProvider.user;

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
                  SvgPicture.asset('assets/nointernet.svg', height: 120,),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Profil Saya",
                        style: blueTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: semiBold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                )),
            Expanded(
                child: SingleChildScrollView(
              child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  width: double.infinity,
                  // height: 500,
                  child: Column(
                    children: [
                      FutureBuilder<UserModel?>(
                          future: getUserData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // If still loading, show a loading indicator
                              return const CircularProgressIndicator(
                                color: primaryColor,
                              );
                            } else if (snapshot.hasError) {
                              // If there's an error, handle it accordingly
                              return Text('Error: ${snapshot.error}');
                            } else {
                              // If data is available, use it here
                              String namaPengguna = (snapshot.data?.nama ?? '')
                                  .toString()
                                  .toUpperCase();
                              String idPengguna =
                                  (snapshot.data?.id ?? '').toString();
                              String fotoProfil =
                                  (snapshot.data?.foto_profil ?? '');

                              return Column(
                                children: [
                                  //container foto profil
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: CachedNetworkImage(
                                            imageUrl: fotoProfil,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  //nama dan id
                                  Column(
                                    children: [
                                      Text(
                                        namaPengguna,
                                        style: blueTextStyle.copyWith(
                                          fontSize: 16,
                                          fontWeight: semiBold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        idPengguna,
                                        style: secondaryTextStyle.copyWith(
                                          fontSize: 14,
                                          fontWeight: semiBold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }
                          }),

                      const SizedBox(
                        height: 35,
                      ),

                      //container list pilihan profil
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              bool isConnected =
                                  await checkInternetConnection();
                              if (isConnected) {
                                Navigator.of(context)
                                    .pushNamed(ProfilEditScreen.routeName);
                              } else {
                                showNoInternetConnectionPopup();
                              }
                            },
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
                                    'assets/profil_ubahprofil.svg',
                                    width: 20,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "Ubah Profil",
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
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(UbahSandiScreen.routeName);
                            },
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
                                    'assets/profil_sandi.svg',
                                    width: 20,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "Ubah Kata Sandi",
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
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(SyaratScreen.routeName);
                            },
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
                                    'assets/profil_syarat.svg',
                                    width: 20,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "Syarat dan Ketentuan",
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
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(BantuanScreen.routeName);
                            },
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
                                    'assets/profil_bantuan.svg',
                                    width: 20,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "Pusat Bantuan",
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
                            onTap: () {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        child: SizedBox(
                                          height: 220,
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 20, top: 20),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Yakin Logout?",
                                                  style: secondaryTextStyle
                                                      .copyWith(
                                                    fontSize: 14,
                                                    color: primaryTextColor,
                                                    fontWeight: medium,
                                                  ),
                                                ),
                                                const Divider(
                                                  color: greyColor,
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    //button logout
                                                    Column(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            // handleLogout();
                                                          },
                                                          child: Container(
                                                            width: 72,
                                                            height: 72,
                                                            decoration:
                                                                BoxDecoration(
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.05), // Shadow color
                                                                  spreadRadius:
                                                                      0.01, // Spread radius
                                                                  blurRadius:
                                                                      5, // Blur radius
                                                                  offset: const Offset(
                                                                      0,
                                                                      1), // Offset in the x, y direction
                                                                ),
                                                              ],
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .red,
                                                                  width: 1.0,
                                                                  style:
                                                                      BorderStyle
                                                                          .solid),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              color: whiteColor,
                                                            ),
                                                            child: Center(
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                              'assets/profil_logout.svg',
                                                              width: 40,
                                                              colorFilter:
                                                                  const ColorFilter
                                                                          .mode(
                                                                      Colors
                                                                          .red,
                                                                      BlendMode
                                                                          .srcIn),
                                                            )),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 3,
                                                        ),
                                                        Text(
                                                          "Logout",
                                                          style:
                                                              secondaryTextStyle
                                                                  .copyWith(
                                                            fontSize: 12,
                                                            color:
                                                                secondaryTextColor,
                                                            fontWeight:
                                                                semiBold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ));
                                  });
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/profil_logout.svg',
                                  width: 20,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Logout",
                                  style: secondaryTextStyle.copyWith(
                                      fontSize: 14,
                                      fontWeight: regular,
                                      color:
                                          secondaryTextColor.withOpacity(0.7)),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ))
          ],
        )),
      ),
    );
  }
}
