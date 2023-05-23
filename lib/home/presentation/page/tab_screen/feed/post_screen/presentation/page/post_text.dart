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
    String title = '';
    if (widget.prayerRequest.title == null) {
      title = '';
    } else {
      title = widget.prayerRequest.title!;
    }
    final bool isEmpty = widget.prayerRequest.imageUrls!.isEmpty;
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
                child: SeeMoreText(
                    text: widget.prayerRequest.text!.trim(),
                    maxLines: 2,
                    color: secondaryColor),
              )
            : Container(
                decoration: BoxDecoration(
                    border: Border.symmetric(
                        horizontal: BorderSide(
                            color: lighter.withOpacity(0.1), width: .5))),
                width: double.infinity,
                padding: padding,
                child: Column(
                  children: [
                    SeeMoreText(
                        text: widget.prayerRequest.text!.trim(),
                        maxLines: 10,
                        color: darkColor),
                  ],
                ),
              ),
      ],
    );
  }
}
