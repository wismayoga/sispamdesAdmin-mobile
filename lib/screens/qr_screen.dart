import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sispamdes/screens/pendatan_input.dart';
import 'dart:developer';

import 'package:sispamdes/theme.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({super.key});
  // const QrScreen({required this.scannedResult, Key? key}) : super(key: key);
  static const routeName = "/qrscreen";
  // final String? scannedResult;

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  void _stopScanner() {
    if (controller != null) {
      controller!.stopCamera();
    }
    controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cool QR Scanner',
          style: blueTextStyle.copyWith(
            fontSize: 14,
            fontWeight: semiBold,
          ),
        ),
        centerTitle: true,
        backgroundColor: whiteColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: blueTextColor, // Set the color of the back button icon here
          ),
          onPressed: () {
            // Add functionality to navigate back here
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                        'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  else
                    const Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Adjust the radius to make it more or less rounded
                              ),
                            ),
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                // return Text('Flash: ${snapshot.data}');
                                final isFlashOn = snapshot.data == true;
                                return Row(
                                  children: [
                                    isFlashOn
                                        ? const Icon(Icons.flashlight_on_sharp,
                                            size: 18, color: Colors.yellow)
                                        : const Icon(Icons.flashlight_off_sharp,
                                            size: 18),
                                    Text(
                                      "Flash",
                                      style: blueTextStyle.copyWith(
                                        fontSize: 12,
                                        fontWeight: semiBold,
                                        color: whiteColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                );
                              },
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Adjust the radius to make it more or less rounded
                              ),
                            ),
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  // return Text(' ${describeEnum(snapshot.data!)} ');
                                  return Row(
                                    children: [
                                      const Icon(Icons.cameraswitch_rounded,
                                          size: 18),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        "Kamera",
                                        style: blueTextStyle.copyWith(
                                          fontSize: 12,
                                          fontWeight: semiBold,
                                          color: whiteColor,
                                        ),
                                      )
                                    ],
                                  );
                                } else {
                                  return const Text('loading');
                                }
                              },
                            )),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: primaryColor,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;

        String scannedCode = _extractCodeFromUrl(result!.code ?? '');
        _stopScanner();
        Navigator.of(context).pushReplacementNamed(
          PendataanInputScreen.routeName,
          arguments: scannedCode,
        );
      });
    });
  }

  String _extractCodeFromUrl(String url) {
    List<String> urlParts = url.split('/');
    String code = urlParts.last;
    return code;
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
