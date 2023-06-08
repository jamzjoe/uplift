import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/qr_code/profile.dart';
import 'package:uplift/utils/services/auth_services.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/pop_up.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class QRReaderScreen extends StatefulWidget {
  const QRReaderScreen({super.key, required this.userJoinedModel});
  final UserModel userJoinedModel;

  @override
  State<QRReaderScreen> createState() => _QRReaderScreenState();
}

class _QRReaderScreenState extends State<QRReaderScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = widget.userJoinedModel;

    return LoaderOverlay(
      overlayColor: secondaryColor,
      overlayOpacity: 0.8,
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: whiteColor),
          backgroundColor: primaryColor,
          title: const HeaderText(text: 'QR Reader', color: whiteColor),
          actions: [
            Tooltip(
              message:
                  'This QR code scanner help to find your friend in an easy way.',
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    CupertinoIcons.info_circle_fill,
                    color: whiteColor,
                  )),
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  QRView(
                    overlay: QrScannerOverlayShape(
                        borderColor: primaryColor,
                        overlayColor: Colors.black.withOpacity(0.9)),
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                  const Positioned(
                      top: 50,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: DefaultText(
                            text: "Make sure the QR code is within the frame.",
                            color: whiteColor),
                      )),
                  Positioned(
                      bottom: 80,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Center(
                            child: (result != null)
                                ? ElevatedButton.icon(
                                    icon: const Icon(
                                      CupertinoIcons.person_add_solid,
                                      color: whiteColor,
                                    ),
                                    onPressed: () async {
                                      context.loaderOverlay.show();
                                      final UserModel? userModel;
                                      if (result!.code! !=
                                          await AuthServices.userID()) {
                                        try {
                                          userModel = await AuthServices()
                                              .getUserRecord(
                                                  result!.code.toString());
                                          if (context.mounted) {
                                            context.loaderOverlay.hide();
                                            CustomDialog.showCustomDialog(
                                                context,
                                                UserProfile(user: userModel));
                                          }
                                        } catch (e) {
                                          if (context.mounted) {
                                            context.loaderOverlay.hide();
                                            CustomDialog.showErrorDialog(
                                                context,
                                                'User not found or please check your internet connection!',
                                                "Request failed",
                                                'Confirm');
                                          }
                                        }
                                      } else {
                                        if (context.mounted) {
                                          context.loaderOverlay.hide();
                                          CustomDialog.showErrorDialog(
                                              context,
                                              'You cannot add yourself!',
                                              "Request failed",
                                              'Confirm');
                                        }
                                      }
                                    },
                                    label: const DefaultText(
                                        text: 'Confirm Add', color: whiteColor))
                                : ElevatedButton.icon(
                                    icon: Icon(
                                      CupertinoIcons.person_add_solid,
                                      color: whiteColor.withOpacity(0.5),
                                    ),
                                    onPressed: null,
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                secondaryColor
                                                    .withOpacity(0.8))),
                                    label: DefaultText(
                                        text: 'Confirm Add',
                                        color: whiteColor.withOpacity(0.5))),
                          ),
                          defaultSpace,
                          GestureDetector(
                            onTap: () async {
                              context.pop();
                              context.pushNamed('qr_generator',
                                  extra: widget.userJoinedModel);
                              context.loaderOverlay.hide();
                            },
                            child: const Column(
                              children: [
                                Icon(
                                  CupertinoIcons.qrcode_viewfinder,
                                  size: 50,
                                  color: whiteColor,
                                ),
                                SmallText(
                                    text: 'Generate QR Code', color: whiteColor)
                              ],
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
