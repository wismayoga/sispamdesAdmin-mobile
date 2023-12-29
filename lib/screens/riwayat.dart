import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sispamdes/models/pelanggan_model.dart';
import 'package:sispamdes/models/pendataan_model.dart';
import 'package:sispamdes/providers/pelanggan_provider.dart';
import 'package:sispamdes/providers/pendataan_provider.dart';
import 'package:sispamdes/screens/riwayatdetail.dart';
import '../theme.dart';
import 'package:intl/intl.dart';

//home
class Riwayat extends StatefulWidget {
  const Riwayat({
    super.key,
  });
  static const routeName = "/riwayatscreen";
  @override
  State<Riwayat> createState() => _RiwayatState();
}

class _RiwayatState extends State<Riwayat> {
  List<bool> isSelected = [true, false];
  final TextEditingController _searchController = TextEditingController();
  List<PendataanModel> filteredPendataans = [];
  List<PendataanModel> pendataans = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final pendataanProvider =
        Provider.of<PendataanProvider>(context, listen: true);
    final List<PendataanModel> pendataans =
        pendataanProvider.pendataans + pendataanProvider.pendataansOnline;
    filteredPendataans = pendataans
        .where((pendataan) => pendataan.status_pembayaran != "Unpaid")
        .toList();
  }

  @override
  void dispose() {
    // _isMounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pendataanProvider =
        Provider.of<PendataanProvider>(context, listen: true);
    final List<PendataanModel> pendataans =
        pendataanProvider.pendataans + pendataanProvider.pendataansOnline;
    final pelangganProvider =
        Provider.of<PelangganProvider>(context, listen: true);
    final List<PelangganModel> pelanggans = pelangganProvider.pelanggans;

    filteredPendataans.sort((a, b) => b.created_at!.compareTo(a.created_at.toString()));


    // Function to handle search on pendataans list
    void getFilteredPendataans(int newIndex) {
      setState(() {
        isSelected =
            List.generate(isSelected.length, (index) => index == newIndex);
        isSelected[newIndex] = true;
        if (isSelected[0]) {
          // Show "Disinkron" data
          filteredPendataans = pendataans
              .where((pendataan) => pendataan.status_pembayaran != "Unpaid")
              .toList();
        } else {
          // Show "Belum" data with status_pembayaran = "Unpaid"
          filteredPendataans = pendataans
              .where((pendataan) => pendataan.status_pembayaran == "Unpaid")
              .toList();
        }
      });
      // Sort the filtered pendataans by date
    filteredPendataans.sort((a, b) => b.created_at!.compareTo(a.created_at.toString()));
    }

    void handleSearch(String query) {
      setState(() {
        if (query.isEmpty) {
          getFilteredPendataans(isSelected.indexOf(true));
        } else {
          filteredPendataans = pendataans.where((pendataan) {
            final pelanggan = pelanggans.firstWhere(
              (pelanggan) => pelanggan.id.toString() == pendataan.id_pelanggan,
            );
            return pelanggan != null &&
                pelanggan.nama!.toLowerCase().contains(query.toLowerCase());
          }).toList();
        }
      });
    }

    return Container(
      color: greyColor,
      child: SafeArea(
        child: Column(
          children: [
            header(),
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
                              //Sort Data
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Sort",
                                        style: secondaryTextStyle.copyWith(
                                          fontSize: 12,
                                          color: secondaryColor,
                                          fontWeight: regular,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              //Container Progres Pendataan
                              Container(
                                  constraints:
                                      const BoxConstraints(maxHeight: 35),
                                  decoration: const BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: ToggleButtons(
                                    // list of booleans
                                    isSelected: isSelected,
                                    // text color of selected toggle
                                    selectedColor: Colors.white,
                                    // text color of not selected toggle
                                    color: blueTextColor,
                                    // fill color of selected toggle
                                    fillColor: primaryColor,
                                    // when pressed, splash color is seen
                                    splashColor: secondaryColor,
                                    // long press to identify highlight color
                                    highlightColor: primaryDarkColor,
                                    // if consistency is needed for all text style
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    // border properties for each toggle
                                    renderBorder: true,
                                    borderColor: primaryColor,
                                    borderWidth: 1.5,
                                    borderRadius: BorderRadius.circular(10),
                                    selectedBorderColor: primaryColor,
                                    onPressed: getFilteredPendataans,

                                    // add widgets for which the users need to toggle
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 34.5,
                                        ),
                                        child: Text('Disinkron',
                                            style: TextStyle(fontSize: 12)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 40.5,
                                        ),
                                        child: Text('Belum',
                                            style: TextStyle(fontSize: 12)),
                                      ),
                                    ],
                                    // to select or deselect when pressed

                                    // onPressed: (int newIndex) {
                                    //   setState(() {
                                    //     // looping through the list of booleans values
                                    //     for (int index = 0;
                                    //         index < isSelected.length;
                                    //         index++) {
                                    //       // checking for the index value
                                    //       if (index == newIndex) {
                                    //         // one button is always set to true
                                    //         isSelected[index] = true;
                                    //       } else {
                                    //         // other two will be set to false and not selected
                                    //         isSelected[index] = false;
                                    //       }
                                    //     }
                                    //   });
                                    // },
                                  )),
                              const SizedBox(
                                height: 15,
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
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  //search button
                                  Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: whiteColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                      // Add padding around the search bar
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0),
                                      // Use a Material design search bar
                                      child: TextField(
                                        controller: _searchController,
                                        onChanged: (query) {
                                          setState(() {
                                            handleSearch(query);
                                          });
                                        },
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(0),

                                          hintText: 'Nama Pelanggan',
                                          hintStyle:
                                              secondaryTextStyle.copyWith(
                                            fontSize: 14,
                                            color: secondaryTextColor,
                                            fontWeight: regular,
                                          ),
                                          // Add a clear button to the search bar
                                          suffixIcon: IconButton(
                                            icon: const Icon(Icons.clear),
                                            iconSize: 20,
                                            onPressed: () =>
                                                _searchController.clear(),
                                          ),
                                          // Add a search icon or button to the search bar
                                          prefixIcon: IconButton(
                                            icon: const Icon(Icons.search),
                                            iconSize: 25,
                                            onPressed: () {
                                              // Perform the search here
                                            },
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),

                                  //list pendataan
                                  SizedBox(
                                    height: 400,
                                    child: filteredPendataans.isEmpty
                                        ? SizedBox(
                                          height: 330,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 30,),
                                              SvgPicture.asset(
                                                'assets/nopelanggan.svg',
                                                height: 120,
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                "Tidak Ditemukan!",
                                                style: primaryTextStyle
                                                    .copyWith(
                                                  fontSize: 16,
                                                  fontWeight: semiBold,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "Lakukan pendataan atau update data dari server",
                                                style: secondaryTextStyle
                                                    .copyWith(
                                                  fontSize: 12,
                                                  fontWeight: regular,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        )
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                filteredPendataans.length,
                                            itemBuilder:
                                                (BuildContext ctx, index) {
                                              final pendataan =
                                                  filteredPendataans[index];

                                              final PelangganModel pelanggan =
                                                  pelanggans.firstWhere(
                                                (pelanggan) =>
                                                    pelanggan.id.toString() ==
                                                    pendataan.id_pelanggan,
                                                orElse: () => PelangganModel(
                                                    id: 1,
                                                    role: 'Pelanggan',
                                                    email:
                                                        'Pelanggan@gmail.com',
                                                    nama: 'Tidak Ditemukan',
                                                    status: 'Aktif',
                                                    foto_profil: '',
                                                    nomor_hp: '',
                                                    alamat: ''),
                                              );

                                              // Build the title string
                                              final String title =
                                                  "${pelanggan.nama}";
                                              return Card(
                                                  key: ValueKey(pendataan.id),
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 0,
                                                      vertical: 3),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3)),

                                                  // The color depends on this is selected or not
                                                  color: whiteColor,
                                                  child: ListTile(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                              RiwayatDetail
                                                                  .routeName,
                                                              arguments:
                                                                  pendataan);
                                                    },
                                                    title: Text(
                                                      title,
                                                      style: secondaryTextStyle
                                                          .copyWith(
                                                        fontSize: 14,
                                                        color: primaryTextColor,
                                                        fontWeight: medium,
                                                      ),
                                                    ),
                                                    subtitle: Text(
                                                      "${DateFormat('dd-MM-yyyy').format(DateTime.parse(pendataan.created_at.toString()))} | Total: ${pendataan.total_penggunaan} | Harga: Rp. ${pendataan.total_harga}.",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: secondaryTextStyle
                                                          .copyWith(
                                                        fontSize: 10,
                                                        color:
                                                            secondaryTextColor,
                                                        fontWeight: regular,
                                                      ),
                                                    ),
                                                  ));
                                            },
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

// HEADER
Widget header() {
  return Container(
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
            offset: const Offset(0, 0), // changes the position of the shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Riwayat Pendataan",
            style: blueTextStyle.copyWith(
              fontSize: 14,
              fontWeight: semiBold,
            ),
          ),
        ],
      ));
}
