import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sispamdes/models/pelanggan_model.dart';
import 'package:sispamdes/models/pendataan_model.dart';
import 'package:sispamdes/providers/pelanggan_provider.dart';
import 'package:sispamdes/theme.dart';

class RiwayatDetail extends StatelessWidget {
  const RiwayatDetail({super.key});
  static const routeName = "/riwayatdetailscreen";
  @override
  Widget build(BuildContext context) {
    final pendataan =
        ModalRoute.of(context)!.settings.arguments as PendataanModel;
    String userId = pendataan.id_pelanggan.toString();

    final pelangganProvider = Provider.of<PelangganProvider>(context);

    // Find the specific user by user_id
    PelangganModel user = pelangganProvider.pelanggans.firstWhere(
        (user) => user.id.toString() == userId);

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
                          "Detail Riwayat Pendataan",
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
                                              user.id != null
                                                  ? user.id.toString()
                                                  : '-',
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
                                                user.nama.toString(),
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
                                                user.alamat.toString(),
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
                                    "Detail Pendataan",
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
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: backgroundColor
                                                  .withOpacity(1),
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 20,
                                              child: SvgPicture.asset(
                                                'assets/biodata_kalender.svg',
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
                                                  "Bulan Lalu",
                                                  style: secondaryTextStyle
                                                      .copyWith(
                                                    fontSize: 12,
                                                    color: secondaryTextColor,
                                                    fontWeight: medium,
                                                  ),
                                                ),
                                                
                                                Text(
                                                
                                                  pendataan.created_at !=
                                                          null
                                                      ? pendataan
                                                          .created_at
                                                          .toString()
                                                      : '-',
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
                                      
                                      const SizedBox(height: 5),
                                      Container(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: backgroundColor
                                                  .withOpacity(1),
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 20,
                                              child: SvgPicture.asset(
                                                'assets/biodata_kalender.svg',
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
                                                  "Bulan Ini",
                                                  style: secondaryTextStyle
                                                      .copyWith(
                                                    fontSize: 12,
                                                    color: secondaryTextColor,
                                                    fontWeight: medium,
                                                  ),
                                                ),
                                                Text(
                                                  pendataan.nilai_meteran.toString(),
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
                                      const SizedBox(height: 5),
                                      Container(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: backgroundColor
                                                  .withOpacity(1),
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 20,
                                              child: SvgPicture.asset(
                                                'assets/biodata_penggunaan.svg',
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
                                                  "Penggunaan",
                                                  style: secondaryTextStyle
                                                      .copyWith(
                                                    fontSize: 12,
                                                    color: secondaryTextColor,
                                                    fontWeight: medium,
                                                  ),
                                                ),
                                                Text(
                                                  pendataan.total_penggunaan.toString(),
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
                                      const SizedBox(height: 5),
                                      Container(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: backgroundColor
                                                  .withOpacity(1),
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 20,
                                              child: SvgPicture.asset(
                                                'assets/biodata_harga.svg',
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
                                                  "Total Harga",
                                                  style: secondaryTextStyle
                                                      .copyWith(
                                                    fontSize: 12,
                                                    color: secondaryTextColor,
                                                    fontWeight: medium,
                                                  ),
                                                ),
                                                Text(
                                                  "Rp. ${pendataan.total_harga},-",
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
                                      const SizedBox(height: 5),
                                      Container(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: backgroundColor
                                                  .withOpacity(1),
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 20,
                                              child: SvgPicture.asset(
                                                'assets/biodata_foto.svg',
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
                                                  "Foto Pendataan",
                                                  style: secondaryTextStyle
                                                      .copyWith(
                                                    fontSize: 12,
                                                    color: secondaryTextColor,
                                                    fontWeight: medium,
                                                  ),
                                                ),
                                                Text(
                                                  pendataan.foto_meteran.toString(),
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
                                      //button edit dan sinkron
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            onPressed: () {},
                                            style: TextButton.styleFrom(
                                              foregroundColor: whiteColor,
                                              backgroundColor:
                                                  secondaryTextColor,
                                              textStyle:
                                                  secondaryTextStyle.copyWith(
                                                fontSize: 12,
                                                color: secondaryTextColor,
                                                fontWeight: semiBold,
                                              ),
                                            ),
                                            child: const Text(
                                              'Edit',
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          TextButton(
                                            onPressed: () {},
                                            style: TextButton.styleFrom(
                                              foregroundColor: whiteColor,
                                              backgroundColor: primaryColor,
                                              textStyle:
                                                  secondaryTextStyle.copyWith(
                                                fontSize: 12,
                                                color: secondaryTextColor,
                                                fontWeight: semiBold,
                                              ),
                                            ),
                                            child: const Text(
                                              'Sinkron',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
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
