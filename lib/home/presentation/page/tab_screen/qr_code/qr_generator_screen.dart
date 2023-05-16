import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class QRGeneratorScreen extends StatefulWidget {
  const QRGeneratorScreen({super.key, required this.user});
  final UserModel user;

  @override
  State<QRGeneratorScreen> createState() => _QRGeneratorScreenState();
}

class _QRGeneratorScreenState extends State<QRGeneratorScreen> {
  @override
  Widget build(BuildContext context) {
    final UserModel user = widget.user;
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: whiteColor),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.qrcode_viewfinder),
            onPressed: () {
              context.pop();
            },
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              clipBehavior: Clip.none,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                  color: whiteColor, borderRadius: BorderRadius.circular(20)),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Positioned(
                      top: -80,
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(1000)),
                          child:
                              ProfilePhoto(user: user, radius: 100, size: 80))),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      defaultSpace,
                      HeaderText(
                          text: user.displayName ?? 'Anonymous User',
                          color: secondaryColor,
                          size: 18),
                      defaultSpace,
                      defaultSpace,
                      QrImage(
                          foregroundColor: secondaryColor,
                          data: user.userId!,
                          version: QrVersions.auto,
                          size: 220),
                      defaultSpace,
                      const SmallText(
                          text: 'Share QR code so others can follow you',
                          color: secondaryColor),
                      defaultSpace,
                      Image.asset('assets/uplift-logo.png', width: 60),
                    ],
                  )
                ],
              ),
            ),
          ),
          defaultSpace,
          TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.share, color: whiteColor),
              label: const DefaultText(text: 'Share to', color: whiteColor)),
        ],
      ),
    );
  }
}
