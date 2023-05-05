import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/default_text.dart';

class FriendsShimmerItem extends StatelessWidget {
  const FriendsShimmerItem({
    super.key,
    this.type,
  });
  final String? type;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: Colors.white.withOpacity(.8),
      baseColor: secondaryColor.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
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
                  Visibility(
                    visible: type == 'text',
                    child: CustomContainer(
                        widget: const SizedBox(),
                        color: lightColor.withOpacity(0.5)),
                  ),
                  Visibility(
                    visible: type == 'button',
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                          color: lightColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(5)),
                      child: const Center(
                        child: DefaultText(
                            text: 'Sent request', color: whiteColor),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
