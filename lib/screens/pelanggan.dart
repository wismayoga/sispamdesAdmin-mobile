import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sispamdes/models/pelanggan_model.dart';
import 'package:sispamdes/models/pendataan_model.dart';
import 'package:sispamdes/providers/pelanggan_provider.dart';
import 'package:sispamdes/providers/pendataan_provider.dart';
import 'package:sispamdes/screens/pelanggandetail.dart';
import 'package:sispamdes/theme.dart';

class PelangganScreen extends StatefulWidget {
  const PelangganScreen({super.key});
  static const routeName = "/pelangganscreen";

  @override
  State<PelangganScreen> createState() => _PelangganScreenState();
}

class _PelangganScreenState extends State<PelangganScreen> {
  List<bool> isSelected = [true, false, false];
  final TextEditingController _searchController = TextEditingController();
  List<PelangganModel> filteredPelanggans = [];
  List<PelangganModel> pelanggans = []; // Move the declaration here

  @override
  void initState() {
    super.initState();

    // Load the data here
    final pelangganProvider =
        Provider.of<PelangganProvider>(context, listen: false);
    pelanggans = pelangganProvider.pelanggans;
    filteredPelanggans = pelanggans; // Set the initial data

    // Other init tasks if needed
  }

  @override
  void dispose() {
    // _isMounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pelangganProvider = Provider.of<PelangganProvider>(context);
    final List<PelangganModel> pelanggans = pelangganProvider.pelanggans;
    final pendataanProvider = Provider.of<PendataanProvider>(context);
    final List<PendataanModel> pendataans = pendataanProvider.pendataans;

    void handleToggle(int newIndex) {
      setState(() {
        isSelected =
            List.generate(isSelected.length, (index) => index == newIndex);
        isSelected[newIndex] = true;

        final now = DateTime.now();
        final thisMonth = DateTime(now.year, now.month);

        if (isSelected[0]) {
          filteredPelanggans = pelanggans;
        } else if (isSelected[1]) {
          filteredPelanggans = pelanggans.where((pelanggan) {
            return pendataans.any((pendataan) {
              final pendataanDate =
                  DateTime.parse(pendataan.created_at.toString());
              return pendataan.id_pelanggan == pelanggan.id.toString() &&
                  pendataanDate.year == thisMonth.year &&
                  pendataanDate.month == thisMonth.month;
            });
          }).toList();
        } else if (isSelected[2]) {
          filteredPelanggans = pelanggans.where((pelanggan) {
            return pendataans.every((pendataan) {
              final pendataanDate =
                  DateTime.parse(pendataan.created_at.toString());
              return pendataan.id_pelanggan != pelanggan.id.toString() ||
                  !(pendataanDate.year == thisMonth.year &&
                      pendataanDate.month == thisMonth.month);
            });
          }).toList();
        }
      });
    }

    void handleSearch(String query) {
      setState(() {
        if (query.isEmpty) {
          handleToggle(isSelected.indexOf(true));
        } else {
          final filteredBySearch = pelanggans
              .where((pelanggan) => pelanggan.nama
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .toList();
          handleToggle(isSelected.indexOf(true));
          filteredPelanggans = filteredPelanggans
              .where((pelanggan) => filteredBySearch.contains(pelanggan))
              .toList();
        }
      });
    }

    return Scaffold(
      body: Container(
        color: greyColor,
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
                        "Pelanggan",
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
                      Column(
                        children: [
                          //Sort Data
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Sort Pelanggan",
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
                          //container sort
                          Container(
                              constraints: const BoxConstraints(maxHeight: 35),
                              decoration: const BoxDecoration(
                                  color: whiteColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
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
                                // to select or deselect when pressed
                                onPressed: handleToggle,
                                // add widgets for which the users need to toggle
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24.5,
                                    ),
                                    child: Text('Semua',
                                        style: TextStyle(
                                          fontSize: 12,
                                        )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24.5,
                                    ),
                                    child: Text('Didata',
                                        style: TextStyle(fontSize: 12)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24.5,
                                    ),
                                    child: Text('Belum',
                                        style: TextStyle(fontSize: 12)),
                                  ),
                                ],

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
                                    "List Pelanggan",
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
                              //container search
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  // Add padding around the search bar
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 0),
                                  // Use a Material design search bar
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: (value) {
                                      setState(() {
                                        handleSearch(value);
                                      });
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(0),

                                      hintText: 'Nama Pelanggan',
                                      hintStyle: secondaryTextStyle.copyWith(
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
                                        onPressed: () {},
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
                              // list pelanggan
                              SizedBox(
                                height: 350,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: filteredPelanggans.length,
                                  itemBuilder: (BuildContext ctx, index) {
                                    final pelanggan = filteredPelanggans[index];
                                    return Card(
                                        key: ValueKey(pelanggan.id),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 3),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(3)),

                                        // The color depends on this is selected or not
                                        color: whiteColor,
                                        child: ListTile(
                                          leading: const CircleAvatar(
                                            backgroundImage: AssetImage(
                                                'assets/profile.jpg'),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                PelangganDetail.routeName,
                                                arguments: pelanggan);
                                          },
                                          title: Text(
                                            pelanggan.nama.toString(),
                                            style: secondaryTextStyle.copyWith(
                                              fontSize: 14,
                                              color: primaryTextColor,
                                              fontWeight: medium,
                                            ),
                                          ),
                                          subtitle: Text(
                                            " ${pelanggan.id}  | ${pelanggan.nomor_hp} | ${pelanggan.alamat}",
                                            overflow: TextOverflow.ellipsis,
                                            style: secondaryTextStyle.copyWith(
                                              fontSize: 10,
                                              color: secondaryTextColor,
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
            ))
          ],
        )),
      ),
    );
  }
}
