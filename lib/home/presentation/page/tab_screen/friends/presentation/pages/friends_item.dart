import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class FriendsItem extends StatelessWidget {
  const FriendsItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage('assets/default1.jpg'),
          ),
          const SizedBox(width: 15),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    HeaderText(
                        text: 'Alyssa Mae Keith',
                        color: secondaryColor,
                        size: 16),
                    SmallText(text: '1w ', color: lightColor)
                  ],
                ),
                const SizedBox(height: 5),
                const SmallText(text: 'Friends since 2021', color: lightColor)
              ],
            ),
          )
        ],
      ),
    );
  }
}
