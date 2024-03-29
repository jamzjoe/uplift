import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/see_more_text.dart';

import '../../data/model/prayer_request_model.dart';

class PostText extends StatefulWidget {
  const PostText({
    super.key,
    required this.prayerRequest,
  });

  final PrayerRequestPostModel prayerRequest;

  @override
  State<PostText> createState() => _PostTextState();
}

class _PostTextState extends State<PostText> {
  @override
  Widget build(BuildContext context) {
    
    return Container(
      padding: const EdgeInsets.all(10),
      child: SeeMoreText(
          text: widget.prayerRequest.text!.trim(),
          maxLines: 5,
          color: darkColor),
    );
  }
}
