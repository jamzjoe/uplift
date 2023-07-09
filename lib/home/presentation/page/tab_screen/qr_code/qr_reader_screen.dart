import 'dart:developer';
import 'dart:io';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
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
  const QRReaderScreen({Key? key, required this.userJoinedModel})
      : super(key: key);
  final UserModel userJoinedModel;

  @override
  State<QRReaderScreen> createState() => _QRReaderScreenState();
}

class _QRReaderScreenState extends State<QRReaderScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool popUpIsShown = false;
  final GlobalKey _toolTipKey = GlobalKey();

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
    if (result != null && !popUpIsShown) {
      showPopUpProfile(context);
    }

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
            GestureDetector(
                onTap: () {
                  final dynamic toolTip = _toolTipKey.currentState;
                  toolTip.ensureTooltipVisible();
                },
                child: Tooltip(
                  key: _toolTipKey,
                  message:
                      "This QR code scanner helps find your friend in an easy way.",
                  child: const IconButton(
                    onPressed: null,
                    icon: Icon(
                      CupertinoIcons.info_circle_fill,
                      color: whiteColor,
                    ),
                  ),
                ))
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
                      overlayColor: Colors.black.withOpacity(0.9),
                    ),
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
                        color: whiteColor,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            context.pop();
                            context.pushNamed(
                              'qr_generator',
                              extra: widget.userJoinedModel,
                            );
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
                                text: 'Generate QR Code',
                                color: whiteColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showPopUpProfile(BuildContext context) async {
    context.loaderOverlay.show();
    setState(() {
      popUpIsShown = true;
    });
    final UserModel? userModel;
    if (result!.code! != await AuthServices.userID()) {
      final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks
          .instance
          .getDynamicLink(Uri.parse(result!.code!));
      final scannedUser = initialLink!.link.path.split('/')[2];
      try {
        userModel = await AuthServices().getUserRecord(scannedUser);
        if (context.mounted) {
          context.loaderOverlay.hide();
          CustomDialog.showCustomDialog(context,
              UserProfile(user: userModel, currentUser: widget.userJoinedModel),
              dismissable: true);
        }
      } catch (e) {
        if (context.mounted) {
          context.loaderOverlay.hide();
          CustomDialog.showErrorDialog(
            context,
            'User not found or please check your internet connection!',
            'Request failed',
            'Confirm',
          );
        }
      }
      return;
    } else {
      if (context.mounted) {
        context.loaderOverlay.hide();
        CustomDialog.showErrorDialog(
          context,
          'You cannot add yourself!',
          'Request failed',
          'Confirm',
        );
      }
      return;
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      log('listening');
      if (popUpIsShown == false) {
        setState(() {
          result = scanData;
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
