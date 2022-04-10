import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQrBookCardPage extends StatefulWidget {
  const ScanQrBookCardPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanQrBookCardPageState();
}

class _ScanQrBookCardPageState extends State<ScanQrBookCardPage> {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Color(0x44000000),
          // automaticallyImplyLeading: false,
          elevation: 0,
          title: Text('QR SCAN'),
          centerTitle: true,
          actions: [
            // ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //         padding: const EdgeInsets.all(0),
            //         shape: CircleBorder(),
            //         visualDensity: VisualDensity(horizontal: -4, vertical: -4)),
            //     onPressed: () => Navigator.pop(context),
            //     child: Icon(Icons.close))
            FutureBuilder<bool?>(
              future: controller?.getFlashStatus(),
              builder: (context, snapshot) {
                bool isFlashOn = snapshot.data ?? false;
                return IconButton(
                    onPressed: () async {
                      await controller?.toggleFlash();
                      setState(() {});
                    },
                    icon: Icon(
                      isFlashOn ? Icons.flash_on : Icons.flash_off,
                      color: isFlashOn ? Colors.blue : null,
                    ));
              },
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(flex: 9, child: _buildQrView(context)),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      // Text('โปรดสแกน QR และวางตำแหน่งให้อยู่ในกรอบสีแดง'),
                      // if (result != null)
                      //   // ElevatedButton(onPressed: (){}, child: Text('เพิ่มนามบัตรนี้'))
                      //   Text(
                      //       'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                      // else
                      Text('โปรดสแกน QR และวางตำแหน่งให้อยู่ในกรอบสีแดง'),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: <Widget>[
                      //     Container(
                      //       margin: const EdgeInsets.all(8),
                      //       child: ElevatedButton(
                      //           onPressed: () async {
                      //             await controller?.toggleFlash();
                      //             setState(() {});
                      //           },
                      //           child: FutureBuilder(
                      //             future: controller?.getFlashStatus(),
                      //             builder: (context, snapshot) {
                      //               return Text('Flash: ${snapshot.data}');
                      //             },
                      //           )),
                      //     ),
                      //   ],
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: <Widget>[
                      //     Container(
                      //       margin: const EdgeInsets.all(8),
                      //       child: ElevatedButton(
                      //         onPressed: () async {
                      //           await controller?.pauseCamera();
                      //         },
                      //         child: const Text('pause',
                      //             style: TextStyle(fontSize: 20)),
                      //       ),
                      //     ),
                      //     Container(
                      //       margin: const EdgeInsets.all(8),
                      //       child: ElevatedButton(
                      //         onPressed: () async {
                      //           await controller?.resumeCamera();
                      //         },
                      //         child: const Text('resume',
                      //             style: TextStyle(fontSize: 20)),
                      //       ),
                      //     )
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      cameraFacing: CameraFacing.back,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red.shade400,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
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
        // Future.delayed(Duration(milliseconds: 100));
        print(result!.code);

        if (result != null) {
          controller.pauseCamera();
          // controller.stopCamera();
          //   // Navigator.of(context).pop(result);
          Navigator.pop(context, result!.code);
        }
      });
    });
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
