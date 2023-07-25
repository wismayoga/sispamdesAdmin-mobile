import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sispamdes/models/user_model.dart';
import 'package:sispamdes/providers/auth_provider.dart';
import 'package:sispamdes/services/auth_service.dart';
import 'package:sispamdes/theme.dart';
import 'package:sispamdes/utils/shared_preferences.dart';
import 'package:sispamdes/widget/loading_button.dart';
import '../widget/custom_form_field.dart';
import '../widget/custom_button.dart';

class ProfilEditScreen extends StatefulWidget {
  const ProfilEditScreen({super.key});

  static const routeName = "/profileditscreen";

  @override
  State<ProfilEditScreen> createState() => _ProfilEditScreenState();
}

class _ProfilEditScreenState extends State<ProfilEditScreen> {
  final formkey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController namaController = TextEditingController(text: '');
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController nomorhpController = TextEditingController(text: '');
  TextEditingController alamatController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    getUserData().then((userData) {
      if (userData != null) {
        setState(() {
          namaController.text = userData.nama.toString();
          emailController.text = userData.email.toString();
          nomorhpController.text = userData.nomor_hp.toString();
          alamatController.text = userData.alamat.toString();
        });
      }
    });
  }

  Future<UserModel?> getUserData() async {
    UserPreferences userPreferences = UserPreferences();
    UserModel? userData = await userPreferences.getUser();
    return userData;
  }

  @override
  Widget build(BuildContext context) {
    // HANDLE INPUT
    handleInput() async {
      setState(() {
        isLoading = true;
      });

      if (await AuthService().editProfil(
        nama: namaController.text,
        email: emailController.text,
        nomor_hp: nomorhpController.text,
        alamat: alamatController.text,
      )) {
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (context) => const ProfilEditScreen()));
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Profil Berhasil Diubah!',
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Profil Gagal Diubah!',
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
                          "Ubah Profil",
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
                    //container foto profil
                    Column(
                      children: [
                        Stack(
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
                                    String fotoProfil =
                                        (snapshot.data?.foto_profil ?? '');
                                    return Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.network(
                                          fotoProfil,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        (loadingProgress
                                                                .expectedTotalBytes ??
                                                            1)
                                                    : null,
                                              ),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(Icons.error),
                                        ),
                                      ),
                                    );
                                  }
                                }),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: primaryColor,
                                  border: Border.all(
                                    color: whiteColor,
                                    width: 2,
                                  ),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: whiteColor,
                                    size: 15,
                                  ),
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(16.0),
                                                  topRight:
                                                      Radius.circular(16.0)),
                                            ),
                                            child: Wrap(
                                              alignment: WrapAlignment.end,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.end,
                                              children: [
                                                ListTile(
                                                  leading:
                                                      const Icon(Icons.camera_alt),
                                                  title: const Text('Camera'),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    AuthProvider().uploadImage(
                                                        ImageSource.camera);
                                                        
                                                  },
                                                ),
                                                ListTile(
                                                  leading:
                                                      const Icon(Icons.image),
                                                  title: const Text('Gallery'),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    AuthProvider().uploadImage(
                                                        ImageSource.gallery);
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 35,
                    ),
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
                      title: "Email",
                      hint: 'Email',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
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
                            text: 'Kirim',
                            color: primaryColor,
                            press: () {
                              handleInput();
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
