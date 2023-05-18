import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/button.dart';

class CommentShimmerItem extends StatelessWidget {
  const CommentShimmerItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: secondaryColor.withOpacity(0.2),
      highlightColor: secondaryColor.withOpacity(0.1),
      child: ListTile(
        minVerticalPadding: 0,
        leading: const CircleAvatar(radius: 25),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Expanded(
              child: CustomContainer(widget: SizedBox(), color: secondaryColor),
            ),
            SizedBox(width: 5),
            CustomContainer(widget: SizedBox(), color: secondaryColor),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            CustomContainer(
                width: double.infinity,
                widget: SizedBox(),
                color: secondaryColor),
          ],
        ),
      ),
    );
  }
}
