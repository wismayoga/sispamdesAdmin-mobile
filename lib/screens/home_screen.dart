import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sispamdes/screens/pendatan_input.dart';
import 'package:sispamdes/screens/profil.dart';
import 'package:sispamdes/screens/qr_screen.dart';
import './navbar_icon_custom_icons.dart';
import '../theme.dart';
import './home.dart';
import './riwayat.dart';
import './pelanggan.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = "/homescreen";
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final screen = [
    const Center(child: Home()),
    const Center(child: Riwayat()),
    // const Center(child: Text("3")),
    const Center(child: PelangganScreen()),
    const Center(child: ProfilScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0.01,
              blurRadius: 2,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: BottomAppBar(
          elevation: 0,
          color: Colors.transparent,
          child: SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconBottomBar(
                      text: "Home",
                      icon: NavbarIconCustom.home,
                      selected: _selectedIndex == 0,
                      size: 20,
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      }),
                  IconBottomBar(
                      text: "Riwayat",
                      icon: Icons.history,
                      selected: _selectedIndex == 1,
                      size: 25,
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      }),
                  IconButton(
                    iconSize: 35,
                    icon: const Icon(Icons.add_circle_outline),
                    color: primaryColor,
                    onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: SizedBox(
                                height: 220,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 20),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Input Pendataan",
                                        style: secondaryTextStyle.copyWith(
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
                                          //button scan qr
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pushReplacementNamed(QrScreen.routeName);
                                            },
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 72,
                                                  height: 72,
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(
                                                                0.05), // Shadow color
                                                        spreadRadius:
                                                            0.01, // Spread radius
                                                        blurRadius:
                                                            5, // Blur radius
                                                        offset: const Offset(0,
                                                            1), // Offset in the x, y direction
                                                      ),
                                                    ],
                                                    border: Border.all(
                                                        color: primaryColor,
                                                        width: 1.0,
                                                        style:
                                                            BorderStyle.solid),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: whiteColor,
                                                  ),
                                                  child: Center(
                                                      child: SvgPicture.asset(
                                                          'assets/input_scan.svg')),
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  "Scan QR",
                                                  style: secondaryTextStyle
                                                      .copyWith(
                                                    fontSize: 12,
                                                    color: secondaryTextColor,
                                                    fontWeight: semiBold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          //button search
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pushReplacementNamed(PendataanInputScreen.routeName);
                                            },
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 72,
                                                  height: 72,
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(
                                                                0.05), // Shadow color
                                                        spreadRadius:
                                                            0.01, // Spread radius
                                                        blurRadius:
                                                            5, // Blur radius
                                                        offset: const Offset(0,
                                                            1), // Offset in the x, y direction
                                                      ),
                                                    ],
                                                    border: Border.all(
                                                        color: primaryColor,
                                                        width: 1.0,
                                                        style:
                                                            BorderStyle.solid),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: whiteColor,
                                                  ),
                                                  child: Center(
                                                      child: SvgPicture.asset(
                                                          'assets/input_search.svg')),
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  "Search Data",
                                                  style: secondaryTextStyle
                                                      .copyWith(
                                                    fontSize: 12,
                                                    color: secondaryTextColor,
                                                    fontWeight: semiBold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ));
                        }),
                  ),
                  IconBottomBar(
                      text: "Pelanggan",
                      icon: Icons.people,
                      selected: _selectedIndex == 2,
                      size: 25,
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 2;
                        });
                      }),
                  IconBottomBar(
                      text: "Profil",
                      icon: Icons.person,
                      selected: _selectedIndex == 3,
                      size: 25,
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 3;
                        });
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({
    super.key,
  });

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.01,
            blurRadius: 2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: BottomAppBar(
        elevation: 0,
        color: Colors.transparent,
        child: SizedBox(
          height: 56,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconBottomBar(
                    text: "Home",
                    icon: NavbarIconCustom.home,
                    selected: _selectedIndex == 0,
                    size: 35,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    }),
                IconBottomBar(
                    text: "Riwayat",
                    icon: Icons.history,
                    selected: _selectedIndex == 1,
                    size: 25,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    }),
                IconBottomBar(
                    text: "Add",
                    icon: Icons.add,
                    selected: _selectedIndex == 2,
                    size: 25,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 2;
                      });
                    }),
                IconBottomBar(
                    text: "Pelanggan",
                    icon: Icons.people,
                    selected: _selectedIndex == 3,
                    size: 25,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 3;
                      });
                    }),
                IconBottomBar(
                    text: "Profil",
                    icon: Icons.person,
                    selected: _selectedIndex == 4,
                    size: 25,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 4;
                      });
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//Bottom Bar
class IconBottomBar extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool selected;
  final double size;
  final Function() onPressed;

  const IconBottomBar(
      {required this.text,
      required this.icon,
      required this.selected,
      required this.size,
      required this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: size,
            color: selected || size == 35 ? primaryColor : secondaryColor,
          )),
      Text(
        text,
        style: secondaryTextStyle.copyWith(
          fontSize: 12,
          fontWeight: regular,
          height: .1,
          color: selected ? primaryColor : secondaryColor,
        ),
      )
    ]);
  }
}
