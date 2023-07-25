import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sispamdes/models/pelanggan_model.dart';
import 'package:sispamdes/providers/pelanggan_provider.dart';
import 'package:sispamdes/providers/pendataan_provider.dart';
import 'package:sispamdes/screens/pendataan_ocr.dart';
import 'package:sispamdes/theme.dart';
import 'package:sispamdes/widget/custom_button.dart';
import 'package:sispamdes/widget/loading_button.dart';
import '../widget/custom_form_field.dart';
import 'package:dropdown_search/dropdown_search.dart';

class PendataanInputScreen extends StatefulWidget {
  final String nilaiMeteran;
  final String scanData;
  const PendataanInputScreen(
      {Key? key, this.nilaiMeteran = '', this.scanData = ''})
      : super(key: key);
  static const routeName = "/inputscreen";

  @override
  State<PendataanInputScreen> createState() => _PendataanInputScreenState();
}

class _PendataanInputScreenState extends State<PendataanInputScreen> {
  final formkey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController bulanlaluController = TextEditingController(text: '0');
  TextEditingController bulaniniController = TextEditingController(text: '');
  // String? selectedValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final String? scannedData =
        ModalRoute.of(context)?.settings.arguments as String?;
    if (scannedData != null) {
      final pelangganProvider =
          Provider.of<PelangganProvider>(context, listen: false);
      final pelanggan = pelangganProvider.pelanggans.firstWhere(
        (pelanggan) => pelanggan.id.toString() == scannedData,
      );

      final pendataanProvider =
          Provider.of<PendataanProvider>(context, listen: false);
      final lastMonthData = pendataanProvider.getLastMonthData(pelanggan.id);

      if (lastMonthData != null) {
        bulanlaluController.text = lastMonthData.nilai_meteran.toString();
      } else {
        bulanlaluController.text = '0';
      }

      // bulaniniController.text = widget.nilaiMeteran;
    }
  }

  File? _image;
  dynamic captureImage;
  String? pelangganSelected = '';

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        captureImage =  pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendataanProvider = Provider.of<PendataanProvider>(context);
    final pelangganProvider = Provider.of<PelangganProvider>(context);
    final List<PelangganModel> pelanggans = pelangganProvider.pelanggans;
    final String? scannedData =
        ModalRoute.of(context)?.settings.arguments as String?;

    void updateBulanLaluController(String selectedPelangganId) {
      final pendataanProvider =
          Provider.of<PendataanProvider>(context, listen: false);
      final lastMonthData =
          pendataanProvider.getLastMonthData(int.parse(selectedPelangganId));

      if (lastMonthData != null) {
        bulanlaluController.text = lastMonthData.nilai_meteran.toString();
      } else {
        bulanlaluController.text = '0';
      }
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
                          "Input Pendataan",
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Form Pendataan",
                      style: secondaryTextStyle.copyWith(
                        fontSize: 12,
                        color: secondaryColor,
                        fontWeight: regular,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DropdownSearch<dynamic>(
                      validator: (value) => "Pilih Pelanggan",
                      popupProps: const PopupProps.menu(
                        menuProps: MenuProps(
                          backgroundColor: whiteColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusDirectional.only(
                                  bottomStart: Radius.circular(12),
                                  bottomEnd: Radius.circular(12))),
                        ),
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                        ),
                        showSelectedItems: true,
                      ),
                      items: pelangganProvider.pelanggans
                          .where((pelanggan) => pelanggan.role == "Pelanggan")
                          .map((pelanggan) => pelanggan.nama)
                          .toList(),
                      clearButtonProps: const ClearButtonProps(
                        icon: Icon(Icons.clear, size: 20),
                        color: secondaryTextColor,
                        isVisible: false,
                      ),
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          fillColor: whiteColor,
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(color: primaryColor)),
                          filled: true,
                          labelText: "Pelanggan",
                          hintText: "Pilih pelanggan",
                        ),
                      ),
                      onChanged: (selectedItem) {
                        final pelangganId = pelanggans
                            .firstWhere(
                                (pelanggan) => pelanggan.nama == selectedItem)
                            .id
                            .toString();
                        pelangganSelected = pelangganId;
                        updateBulanLaluController(pelangganId);
                      },
                      compareFn: (item, selectedItem) => item == selectedItem,
                      selectedItem: scannedData != null
                          ? pelanggans
                              .firstWhere((pelanggan) =>
                                  pelanggan.id.toString() == scannedData)
                              .nama
                          : null,
                    ),
                    const SizedBox(height: 20),
                    CustomFormField(
                      title: 'Bulan Lalu',
                      hint: 'Bulan lalu',
                      isReadOnly: true,
                      controller: bulanlaluController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field cannot be empty';
                        }
                        // Add other validation rules here if needed
                        return null; // Return null if the input is valid
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.60,
                          child: TextFormField(
                            cursorColor: primaryTextColor,
                            keyboardType: TextInputType.number,
                            controller: bulaniniController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              // NULL
                              if (value!.isEmpty) {
                                return "";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Bulan Ini',
                              labelStyle: secondaryTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: semiBold,
                              ),
                              suffixStyle: primaryTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: regular,
                              ),
                              errorStyle: const TextStyle(height: 0),
                              contentPadding: const EdgeInsets.fromLTRB(
                                  20.0, 0.0, 20.0, 0.0),
                              hintText: 'Bulan ini',
                              hintStyle: secondaryTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: regular,
                              ),
                              fillColor: whiteColor,
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: primaryTextColor),
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () async {
                            final returnedData = await Navigator.of(context)
                                .pushNamed(OCRScreen.routeName);
                            setState(() {
                              bulaniniController.text = returnedData.toString();
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: 50,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: primaryTextColor,
                                )),
                            child: SvgPicture.asset(
                              'assets/input_ocr.svg',
                              color: primaryColor,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    //foto
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        TextButton(
                          onPressed: _getImageFromGallery,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.grey.withOpacity(0.1)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    6), // Adjust the radius as needed
                                side: const BorderSide(
                                    color: Colors.grey,
                                    width: 1.5), // Border color and width
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/input_camera.svg',
                                  width: 20,
                                ),
                                Text(
                                  'Ambil Gambar',
                                  style: secondaryTextStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: semiBold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        _image != null
                            ? Image.file(
                                _image!,
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 50,
                                width: 50,
                                color: Colors.grey[300],
                                child: Icon(Icons.image,
                                    size: 50, color: Colors.grey[600]),
                              ),
                      ],
                    ),

                    //button simpan
                    const SizedBox(
                      height: 40,
                    ),
                    isLoading
                        ? const LoadingButton(
                            color: primaryColor,
                          )
                        : CustomButton(
                            text: 'Submit',
                            color: primaryColor,
                            press: () async {
                              Navigator.pop(context);
                              await PendataanProvider()
                                  .postPendataan(pelangganSelected, captureImage, int.parse(bulaniniController.text) );
                              pendataanProvider.getPendataans();
                              
                            },
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
