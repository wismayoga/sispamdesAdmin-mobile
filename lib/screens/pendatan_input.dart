import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sispamdes/models/pelanggan_model.dart';
import 'package:sispamdes/models/pendataan_model.dart';
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
    print('iniscandata');
    print(scannedData);
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
    final pickedFile = await picker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        captureImage = pickedFile;
      });
    }
  }

  bool _validateForm() {
    final form = formkey.currentState;
    if (form == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Isi form yang kosong!'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (!form.validate()) {
      // Show snackbar or toast to inform the user about the validation errors.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Isi form yang kosong!'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (_image == null) {
      // Show snackbar or toast to inform the user to capture an image.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gambar belum diambil!'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final pendataanProvider = Provider.of<PendataanProvider>(context);
    final List<PendataanModel> pendataans = pendataanProvider.pendataans;
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
                child: Form(
                  key: formkey,
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
                        validator: (selectedItem) {
                          if (selectedItem == null || selectedItem.isEmpty) {
                            return 'Pilih pelanggan terlebih dahulu';
                          }
                          return null;
                        },
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
                        compareFn: (item, selectedItem) => item == selectedItem,
                        selectedItem: scannedData == null
                            ? null
                            : pelanggans
                                .firstWhere((pelanggan) =>
                                    pelanggan.id.toString() == scannedData)
                                .nama,
                        onChanged: (selectedItem) {
                          if (selectedItem != null) {
                            final pelangganId = pelanggans
                                .firstWhere((pelanggan) =>
                                    pelanggan.nama == selectedItem)
                                .id
                                .toString();
                            pelangganSelected = pelangganId;
                            print('iniselectedPelanggan');
                            print(pelangganSelected);
                            updateBulanLaluController(pelangganId);
                          } else {
                            pelangganSelected = null;
                          }
                        },
                      ),
                      const SizedBox(height: 25),
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
                      const SizedBox(height: 25),
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
                                bulaniniController.text =
                                    returnedData.toString();
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: 50,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: primaryTextColor.withOpacity(0.65),
                                  )),
                              child: SvgPicture.asset(
                                'assets/input_ocr.svg',
                                color: secondaryTextColor.withOpacity(1),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 25),
                      //foto
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          TextButton(
                            onPressed: _getImageFromGallery,
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white.withOpacity(0.6)),
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
                              ? Row(
                                  children: [
                                    const Icon(
                                      Icons.done_rounded,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      "Diambil",
                                      style: blueTextStyle.copyWith(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: regular,
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    const Icon(
                                      Icons.image_not_supported_rounded,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      "Belum diambil",
                                      style: blueTextStyle.copyWith(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: regular,
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),

                      //button simpan
                      const SizedBox(
                        height: 60,
                      ),
                      isLoading
                          ? const LoadingButton(
                              color: primaryColor,
                            )
                          : CustomButton(
                              text: 'Submit',
                              color: primaryColor,
                              press: () async {
                                if (_validateForm()) {
                                  // The form is valid and the image is captured. Continue with submission.
                                  setState(() {
                                    isLoading =
                                        true; // Set isLoading to true before form submission.
                                  });
                                  final pendataanProvider =
                                      Provider.of<PendataanProvider>(context,
                                          listen: false);

                                  // Check if a Pendataan record exists for the selected Pelanggan and current month
                                  final pendataanExist = pendataanProvider
                                      .pendataans
                                      .any((pendataan) {
                                    final pendataanDate = DateTime.parse(
                                        pendataan.created_at.toString());
                                    final currentDate = DateTime.now().toUtc();
                                    return pendataan.id_pelanggan !=
                                            pelangganSelected &&
                                        pendataanDate.month !=
                                            currentDate.month &&
                                        pendataanDate.year != currentDate.year;
                                  });

                                  if (pendataanExist) {
                                    // Show the warning Snackbar
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Pendataan bulan ini sudah dilakukan!'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } else if (int.parse(
                                          bulaniniController.text) <
                                      int.parse(bulanlaluController.text)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Pendataan bulan ini lebih kecil dari bulan lalu!!'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } else {
                                    // Continue with the normal flow
                                    Navigator.pop(context);
                                    print(
                                        'ini pelanggan selecterd $pelangganSelected $scannedData');

                                    await PendataanProvider()
                                        .postPendataanLocal(
                                      scannedData ?? pelangganSelected,
                                      captureImage,
                                      int.parse(bulaniniController.text) ,
                                      int.parse(bulaniniController.text) -
                                          int.parse(bulanlaluController.text),
                                    );
                                    pendataanProvider.getPendataans();
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ))
          ],
        )),
      ),
    );
  }
}
