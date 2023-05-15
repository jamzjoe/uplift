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
    return DefaultText(
      textAlign: TextAlign.start,
      text: prayerRequest.text!,
      color: secondaryColor,
      overflow: TextOverflow.clip,
    );
  }
}
