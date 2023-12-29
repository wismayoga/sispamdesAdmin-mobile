import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sispamdes/models/pelanggan_model.dart';
import 'package:sispamdes/providers/pelanggan_provider.dart';
import 'package:sispamdes/theme.dart';
import 'package:sispamdes/widget/loading_button.dart';
import '../widget/custom_form_field.dart';
import '../widget/custom_button.dart';

class PelangganEditScreen extends StatefulWidget {
  const PelangganEditScreen({super.key});

  static const routeName = "/pelangganedit";

  @override
  State<PelangganEditScreen> createState() => _PelangganEditScreenState();
}

class _PelangganEditScreenState extends State<PelangganEditScreen> {
  final formkey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController namaController = TextEditingController(text: '');
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController nomorhpController = TextEditingController(text: '');
  TextEditingController alamatController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final pelanggan =
        ModalRoute.of(context)!.settings.arguments as PelangganModel;
    namaController.text = pelanggan.nama.toString();
    nomorhpController.text = pelanggan.nomor_hp.toString();
    alamatController.text = pelanggan.alamat.toString();
  }

  @override
  Widget build(BuildContext context) {
    // HANDLE INPUT
    handleInput() async {
      setState(() {
        isLoading = true;
      });
      
      final pelanggan =
        ModalRoute.of(context)!.settings.arguments as PelangganModel;
      if (await PelangganProvider().editProfil(
        namaController.text,
        nomorhpController.text,
        alamatController.text,
        pelanggan.email.toString(),
        pelanggan.id.toString()
      )) {
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (context) => const ProfilEditScreen()));
        await Provider.of<PelangganProvider>(context, listen: false).getPelanggans();
        Navigator.pop(context);
        Navigator.pop(context);
      

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Data Pelanggan Berhasil Diubah!',
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Data Pelanggan Gagal Diubah!',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }

      setState(() {
        isLoading = false;
      });
    }

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
                          "Ubah Data Pelanggan",
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
                  children: [
                    //container form
                    CustomFormField(
                      title: 'Nama',
                      hint: 'Nama',
                      controller: namaController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field cannot be empty';
                        }
                        // Add other validation rules here if needed
                        return null; // Return null if the input is valid
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    CustomFormField(
                      title: "Nomor HP",
                      hint: 'Nomor HP',
                      controller: nomorhpController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field cannot be empty';
                        }
                        // Add other validation rules here if needed
                        return null; // Return null if the input is valid
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    CustomFormField(
                      title: "Alamat",
                      hint: 'Alamat',
                      controller: alamatController,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field cannot be empty';
                        }
                        // Add other validation rules here if needed
                        return null; // Return null if the input is valid
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    isLoading
                        ? const LoadingButton(
                            color: primaryColor,
                          )
                        : CustomButton(
                            text: 'Simpan',
                            color: primaryColor,
                            press: () async {
                              await handleInput();
                              // Navigator.pop(context);
                              // await Provider.of<PelangganProvider>(context,
                              //         listen: false)
                              //     .downloadPelanggans();

                              // After the download is complete, navigate back to the previous screen
                              
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
