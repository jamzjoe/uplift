import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class SeeMoreText extends StatefulWidget {
  final String text;
  final int maxLines;
  final Color? color;

  const SeeMoreText(
      {super.key, required this.text, required this.maxLines, this.color});

  @override
  _SeeMoreTextState createState() => _SeeMoreTextState();
}

class _SeeMoreTextState extends State<SeeMoreText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textSpan = TextSpan(
      text: widget.text,
      style: TextStyle(
          color: widget.color!.withOpacity(0.85),
          height: 1.4,
          fontSize: 14,
          fontFamily: 'Quicksand'),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: isExpanded ? null : widget.maxLines,
    );
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width);

    final isTextOverflowed = textPainter.didExceedMaxLines;

    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: RichText(
              textAlign: TextAlign.justify,
              text: textSpan,
              maxLines: isExpanded ? null : widget.maxLines,
              overflow:
                  isTextOverflowed ? TextOverflow.ellipsis : TextOverflow.clip,
            ),
          ),
          if (isTextOverflowed)
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: SmallText(
                  fontStyle: FontStyle.italic,
                  text: isExpanded ? 'See less' : 'See more',
                  color: linkColor),
            ),
        ],
      ),
    );
  }
}
