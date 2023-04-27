import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class AddFriendItem extends StatelessWidget {
  const AddFriendItem({
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
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 15),
                        decoration: BoxDecoration(
                            color: linkColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: const Center(
                          child: DefaultText(
                              text: 'Add friend', color: whiteColor),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
