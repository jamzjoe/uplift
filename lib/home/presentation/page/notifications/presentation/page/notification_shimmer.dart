import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/button.dart';

class NotificationShimmer extends StatelessWidget {
  const NotificationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: Colors.white.withOpacity(.8),
      baseColor: secondaryColor.withOpacity(0.2),
      child: const CopyItem(),
    );
  }
}

class CopyItem extends StatelessWidget {
  const CopyItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: lightColor.withOpacity(0.5),
          ),
          const SizedBox(width: 15),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomContainer(
                    widget: const SizedBox(),
                    color: lightColor.withOpacity(0.5),
                    width: MediaQuery.of(context).size.width - 150),
                defaultSpace,
                CustomContainer(
                    widget: const SizedBox(),
                    color: lightColor.withOpacity(0.5),
                    width: 150),
              ],
            ),
          )
        ],
      ),
    );
  }
}
