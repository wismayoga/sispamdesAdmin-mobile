import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart'; 
import 'package:sispamdes/theme.dart';

class OCRScreen extends StatefulWidget {
  const OCRScreen({super.key});
  static const routeName = "/ocrscreen";

  @override
  State<OCRScreen> createState() => _OCRScreenState();
}

class _OCRScreenState extends State<OCRScreen> {
  String text = "";
  final StreamController<String> controller = StreamController<String>();

  void setText(value) {
    controller.add(value);
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundColor,
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
                          "Scan OCR",
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

            //ocr body
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ScalableOCR(
                    paintboxCustom: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 4.0
                      ..color = const Color.fromARGB(153, 102, 160, 241),
                    // boxLeftOff: 4,
                    // boxBottomOff: 2.7,
                    // boxRightOff: 4,
                    // boxTopOff: 2.7,
                    boxLeftOff: 5.5,
                    boxBottomOff: 3.5,
                    boxRightOff: 5.5,
                    boxTopOff: 3.5,
                    boxHeight: MediaQuery.of(context).size.height / 5,
                    getScannedText: (value) {
                      setText(value);
                    }),
                StreamBuilder<String>(
                  stream: controller.stream,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return Result(
                        text: snapshot.data != null ? snapshot.data! : "");
                  },
                )
              ],
            ),
          ],
        )),
      ),
    );
  }
}

class Result extends StatelessWidget {
  const Result({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'OCR: $text',
          style: primaryTextStyle.copyWith(
            fontSize: 16,
            fontWeight: semiBold,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Submit untuk melanjutkan input OCR',
          style: primaryTextStyle.copyWith(
            fontSize: 12,
            fontWeight: semiBold,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: SizedBox(
            height: 55,
            width: MediaQuery.of(context).size.width / 2.5,
            child: TextButton(
              onPressed: () {
                var nilaiMeteran = text.replaceAll(RegExp(r'[^0-9]'), '');
                if (nilaiMeteran.isNotEmpty) {
                  //make PendataanInputScreen nilaiMeteran = nilaiMeteran
                  // Navigator.of(context).pushNamed(
                  //   PendataanInputScreen.routeName,
                  //   arguments: nilaiMeteran,
                  // );
                  Navigator.pop(context, nilaiMeteran);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        'Silahkan pindai nilai meteran terlebih dahulu!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Submit',
                style: whiteTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semiBold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
