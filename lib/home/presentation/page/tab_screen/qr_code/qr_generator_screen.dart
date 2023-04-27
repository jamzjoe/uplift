import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGeneratorScreen extends StatefulWidget {
  const QRGeneratorScreen({super.key, required this.user});
  final User user;

  @override
  State<QRGeneratorScreen> createState() => _QRGeneratorScreenState();
}

class _QRGeneratorScreenState extends State<QRGeneratorScreen> {
  @override
  Widget build(BuildContext context) {
    final User user = widget.user;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: whiteColor),
        backgroundColor: primaryColor,
        title: const HeaderText(text: 'My QR Code', color: whiteColor),
        actions: [
          Tooltip(
            message: 'Show this QR to and scan to another UpLift user.',
            child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.info_circle_fill,
                  color: whiteColor,
                )),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(user.photoURL!),
                  ),
                  defaultSpace,
                  HeaderText(
                      text: user.displayName!, color: secondaryColor, size: 18),
                  SmallText(
                      text: user.emailVerified
                          ? 'User Verified'
                          : 'Not Verified User',
                      color: linkColor)
                ],
              ),
              defaultSpace,
              defaultSpace,
              QrImage(
                  foregroundColor: secondaryColor,
                  data: user.uid,
                  version: QrVersions.auto,
                  size: 250),
              defaultSpace,
              defaultSpace,
              ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    CupertinoIcons.qrcode_viewfinder,
                    color: whiteColor,
                  ),
                  label: const DefaultText(
                      text: 'Scan QR Code', color: whiteColor)),
            ],
          ),
        ),
      ),
    );
  }
}
