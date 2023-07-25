import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sispamdes/models/pendataan_model.dart';
import 'package:sispamdes/providers/pendataan_provider.dart';
import 'package:sispamdes/screens/riwayatdetail.dart';
import '../theme.dart';

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
  List<bool> isSelected = [true, false, false];
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final pendataanProvider = Provider.of<PendataanProvider>(context, listen: true);
    final List<PendataanModel> pendataans = pendataanProvider.pendataans;
 
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
                                        child: Text('Disinkron',
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
                                    // to select or deselect when pressed
                                    onPressed: (int newIndex) {
                                      setState(() {
                                        // looping through the list of booleans values
                                        for (int index = 0;
                                            index < isSelected.length;
                                            index++) {
                                          // checking for the index value
                                          if (index == newIndex) {
                                            // one button is always set to true
                                            isSelected[index] = true;
                                          } else {
                                            // other two will be set to false and not selected
                                            isSelected[index] = false;
                                          }
                                        }
                                      });
                                    },
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
                                    height: 350,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: pendataans.length,
                                      itemBuilder: (BuildContext ctx, index) {
                                        final pendataan = pendataans[index];
                                        return Card(
                                            key: ValueKey(pendataan.id),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 0, vertical: 3),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(3)),

                                            // The color depends on this is selected or not
                                            color: whiteColor,
                                            child: ListTile(
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                    RiwayatDetail.routeName,
                                                arguments: pendataan);
                                              },
                                              title: Text(
                                                pendataan.id.toString(),
                                                style:
                                                    secondaryTextStyle.copyWith(
                                                  fontSize: 14,
                                                  color: primaryTextColor,
                                                  fontWeight: medium,
                                                ),
                                              ),
                                              subtitle: Text(
                                                "${pendataan.total_harga} | Total : ${pendataan.total_penggunaan} | Harga : Rp. ${pendataan.total_harga}.",
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                    secondaryTextStyle.copyWith(
                                                  fontSize: 10,
                                                  color: secondaryTextColor,
                                                  fontWeight: regular,
                                                ),
                                              ),
                                              trailing: SizedBox(
                                                width: 30,
                                                height: 30,
                                                child: Ink(
                                                  decoration: ShapeDecoration(
                                                    color: primaryColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    child: Center(
                                                      child: IconButton(
                                                          iconSize: 15,
                                                          icon: const Icon(Icons
                                                              .sync_outlined),
                                                          color: whiteColor,
                                                          onPressed: () {
                                                            //logic to open POPUP window
                                                            pendataanProvider.getPendataans();
                                                          }),
                                                    ),
                                                  ),
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
