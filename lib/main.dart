import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(MaterialApp(
    home: qrcode(),
    debugShowCheckedModeBanner: false,
  ));
}

class qrcode extends StatefulWidget {
  const qrcode({Key? key}) : super(key: key);

  @override
  State<qrcode> createState() => _qrcodeState();
}

class _qrcodeState extends State<qrcode> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  final Controller = TextEditingController();
  QRViewController? controller;

  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: TabBar(
          unselectedLabelColor: Colors.black,
          labelColor: Colors.blue,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: Colors.grey),
          tabs: [
            Tab(
              icon: Icon(
                Icons.qr_code_scanner,
              ),
              text: 'Scan Qr Code',
            ),
            Tab(
              icon: Icon(
                Icons.qr_code,
              ),
              text: 'Create QR Code',
            )
          ],
        ),
        body: TabBarView(
          children: [
            Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                      overlay: QrScannerOverlayShape(
                        borderColor: Theme.of(context).accentColor,
                        borderRadius: 10,
                        borderLength: 20,
                        borderWidth: 10,
                        cutOutSize: MediaQuery.of(context).size.width * 0.8,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: (result != null)
                          ? Text(
                              'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                          : Text('Scan a code'),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      QrImage(
                        data: Controller.text,
                        size: 200,
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      buildTextFild(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildTextFild(BuildContext context) => TextField(
        controller: Controller,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: 'Enter the data',
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Theme.of(context).accentColor,
            ),
          ),
          suffixIcon: IconButton(
            color: Theme.of(context).accentColor,
            onPressed: () {
              setState(() {});
            },
            icon: Icon(
              Icons.done_all,
              size: 30,
            ),
          ),
        ),
      );

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
