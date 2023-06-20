import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uplift/constant/constant.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class GcashQR extends StatefulWidget {
  const GcashQR({super.key});

  @override
  State<GcashQR> createState() => _GcashQRState();
}

final ScreenshotController screenshotController = ScreenshotController();

class _GcashQRState extends State<GcashQR> {
  bool isScreenShoting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const HeaderText(text: 'Uplift Gcash QR', color: whiteColor),
        iconTheme: const IconThemeData(color: whiteColor),
        backgroundColor: const Color(0xff025CE6),
      ),
      body: Screenshot(
        controller: screenshotController,
        child: Container(
          color: const Color(0xff025CE6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  clipBehavior: Clip.none,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(1000),
                          ),
                          child: const Image(
                              width: 80,
                              image: NetworkImage(
                                  'https://www.gcash.com/wp-content/uploads/2019/07/gcash-logo.png'))),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaultSpace,
                          defaultSpace,
                          QrImageView(
                            data:
                                "00020101021127830012com.p2pqrpay0111GXCHPHM2XXX02089996440303152170200000006560417DWQM4TK3JDNY5K0FJ5204601653036085802PH5915J** CR*****N J.6007Payatas6104123463049300",
                            gapless: true,
                            version: QrVersions.auto,
                            size: 200,
                            eyeStyle: const QrEyeStyle(
                                eyeShape: QrEyeShape.circle,
                                color: primaryColor),
                            embeddedImage: const AssetImage(
                                'assets/uplift_colored_logo.png'),
                            embeddedImageStyle:
                                const QrEmbeddedImageStyle(color: whiteColor),
                          ),
                          defaultSpace,
                          const SmallText(
                            textAlign: TextAlign.center,
                            text:
                                'Scan this QR Code to your Gcash app to create donation payment.',
                            color: secondaryColor,
                          ),
                          defaultSpace,
                          Image.asset('assets/uplift_colored_logo.png',
                              width: 60),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future saveAndShare() async {
    setState(() {
      isScreenShoting = true;
    });
    final Uint8List? imageBytes =
        await screenshotController.capture().whenComplete(() {
      setState(() {
        isScreenShoting = !isScreenShoting;
      });
    });
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/qr_uplift.png');
    image.writeAsBytes(imageBytes!);

    await Share.shareFiles([image.path]);
  }
}
