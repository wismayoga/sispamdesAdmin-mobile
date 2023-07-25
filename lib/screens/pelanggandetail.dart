import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sispamdes/models/pelanggan_model.dart';
import 'package:sispamdes/models/pendataan_model.dart';
import 'package:sispamdes/screens/riwayatdetail.dart';
import 'package:sispamdes/services/resource_service.dart';
import 'package:sispamdes/theme.dart';

class PelangganDetail extends StatefulWidget {
  const PelangganDetail({super.key});
  static const routeName = "/pelanggandetailscreen";

  @override
  State<PelangganDetail> createState() => _PelangganDetailState();
}

class _PelangganDetailState extends State<PelangganDetail> {
  final List<Map> data =
      List.generate(100, (index) => {'id': index, 'name': 'Item $index'});
  bool statusPendataan = false;
  List<PendataanModel> pendataans = [];

  @override
  void initState() {
    getPendataans();
    super.initState();
  }

  getPendataans() async {
    var res = await ResourceService().getPendataans();
    setState(() {
      pendataans = res.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pelanggan =
        ModalRoute.of(context)!.settings.arguments as PelangganModel;
    checkPendataanStatus() {
      final now = DateTime.now();
      final thisMonth = DateTime(now.year, now.month);

      bool hasPendataan = pendataans.any((pendataan) {
        final pendataanDate = DateTime.parse(pendataan.created_at.toString());
        return pendataan.id_pelanggan == pelanggan.id.toString() &&
            pendataanDate.year == thisMonth.year &&
            pendataanDate.month == thisMonth.month;
      });

      setState(() {
        statusPendataan = hasPendataan;
      });
    }

    checkPendataanStatus();

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
                          "Detail Pelanggan",
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
                                    "Biodata",
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
                          //container biodata
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
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: backgroundColor.withOpacity(1),
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          child: SvgPicture.asset(
                                            'assets/biodata_id.svg',
                                            height: 15,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "ID Pelanggan",
                                              style:
                                                  secondaryTextStyle.copyWith(
                                                fontSize: 12,
                                                color: secondaryTextColor,
                                                fontWeight: medium,
                                              ),
                                            ),
                                            Text(
                                              "${pelanggan.id}",
                                              style:
                                                  secondaryTextStyle.copyWith(
                                                fontSize: 12,
                                                color: secondaryTextColor,
                                                fontWeight: semiBold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: backgroundColor.withOpacity(1),
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          child: SvgPicture.asset(
                                            'assets/biodata_nama.svg',
                                            height: 18,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Nama",
                                                style:
                                                    secondaryTextStyle.copyWith(
                                                  fontSize: 12,
                                                  color: secondaryTextColor,
                                                  fontWeight: medium,
                                                ),
                                              ),
                                              Text(
                                                "${pelanggan.nama}",
                                                style:
                                                    secondaryTextStyle.copyWith(
                                                  fontSize: 12,
                                                  color: secondaryTextColor,
                                                  fontWeight: semiBold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: backgroundColor.withOpacity(1),
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          child: SvgPicture.asset(
                                            'assets/biodata_alamat.svg',
                                            height: 18,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Alamat",
                                                style:
                                                    secondaryTextStyle.copyWith(
                                                  fontSize: 12,
                                                  color: secondaryTextColor,
                                                  fontWeight: medium,
                                                ),
                                              ),
                                              Text(
                                                "${pelanggan.alamat}",
                                                style:
                                                    secondaryTextStyle.copyWith(
                                                  fontSize: 12,
                                                  color: secondaryTextColor,
                                                  fontWeight: semiBold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: backgroundColor.withOpacity(1),
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          child: SvgPicture.asset(
                                            'assets/biodata_telepon.svg',
                                            height: 18,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Nomor HP",
                                              style:
                                                  secondaryTextStyle.copyWith(
                                                fontSize: 12,
                                                color: secondaryTextColor,
                                                fontWeight: medium,
                                              ),
                                            ),
                                            Text(
                                              "${pelanggan.nomor_hp}",
                                              style:
                                                  secondaryTextStyle.copyWith(
                                                fontSize: 12,
                                                color: secondaryTextColor,
                                                fontWeight: semiBold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: backgroundColor.withOpacity(1),
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          child: ColorFiltered(
                                            colorFilter: const ColorFilter.mode(
                                                primaryColor, BlendMode.srcIn),
                                            child: SvgPicture.asset(
                                              'assets/biodata_kalender.svg',
                                              height: 18,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Status Pendataan Bulan Ini",
                                              style:
                                                  secondaryTextStyle.copyWith(
                                                fontSize: 12,
                                                color: secondaryTextColor,
                                                fontWeight: medium,
                                              ),
                                            ),
                                            statusPendataan
                                                ? Text(
                                                    "Sudah",
                                                    style: secondaryTextStyle
                                                        .copyWith(
                                                      fontSize: 12,
                                                      color: primaryColor,
                                                      fontWeight: semiBold,
                                                    ),
                                                  )
                                                : Text(
                                                    "Belum",
                                                    style: secondaryTextStyle
                                                        .copyWith(
                                                      fontSize: 12,
                                                      color: secondaryTextColor,
                                                      fontWeight: semiBold,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  //button ubah
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: 60,
                                        height: 30,
                                        child: TextButton(
                                          onPressed: () {},
                                          style: TextButton.styleFrom(
                                            foregroundColor: whiteColor,
                                            backgroundColor: secondaryTextColor,
                                            textStyle:
                                                secondaryTextStyle.copyWith(
                                              fontSize: 10,
                                              color: secondaryTextColor,
                                              fontWeight: semiBold,
                                            ),
                                          ),
                                          child: const Text(
                                            'Edit',
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
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
                                    "Pendataan Terakhir",
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
                              //container Pendataan terakhir
                              SizedBox(
                                height: 300,
                                child: ListView.builder(
                                  itemCount: pendataans.length,
                                  itemBuilder: (BuildContext ctx, index) {
                                    PendataanModel pendataan =
                                        pendataans[index];
                                    if (pendataan.id_pelanggan !=
                                        pelanggan.id.toString()) {
                                      return Container();
                                    }
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
                                                RiwayatDetail.routeName);
                                          },
                                          title: Text(
                                            pendataan.created_at.toString(),
                                            style: secondaryTextStyle.copyWith(
                                              fontSize: 14,
                                              color: primaryTextColor,
                                              fontWeight: medium,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "15-06-2023 | Total : 34 | Harga : Rp. 35.000.",
                                            overflow: TextOverflow.ellipsis,
                                            style: secondaryTextStyle.copyWith(
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
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                child: Center(
                                                  child: IconButton(
                                                      iconSize: 15,
                                                      icon: const Icon(
                                                          Icons.sync_outlined),
                                                      color: whiteColor,
                                                      onPressed: () {
                                                        //logic to open POPUP window
                                                      }),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ));
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 15,
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
