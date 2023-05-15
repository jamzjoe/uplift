import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/default_text.dart';

import '../../data/model/prayer_request_model.dart';

class PostText extends StatelessWidget {
  const PostText({
    super.key,
    required this.prayerRequest,
  });

  final PrayerRequestPostModel prayerRequest;

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = prayerRequest.imageUrls!.isEmpty;
    const padding = EdgeInsets.symmetric(vertical: 60, horizontal: 20);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        !isEmpty
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: DefaultText(
                  textAlign: TextAlign.start,
                  text: prayerRequest.text!,
                  color: secondaryColor,
                  overflow: TextOverflow.clip,
                ),
              )
            : Container(
                width: double.infinity,
                padding: padding,
                decoration: const BoxDecoration(color: secondaryColor),
                child: DefaultText(
                  textAlign: TextAlign.center,
                  text: prayerRequest.text!,
                  color: whiteColor,
                  overflow: TextOverflow.clip,
                ),
              ),
      ],
    );
  }
}
