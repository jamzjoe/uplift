import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class AddFriendItem extends StatelessWidget {
  const AddFriendItem({
    super.key,
    required this.user,
  });
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          user.photoUrl == null
              ? const CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('assets/default1.jpg'),
                )
              : CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(user.photoUrl!),
                ),
          const SizedBox(width: 15),
          Flexible(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HeaderText(
                        text: user.displayName ?? 'Anonymous User',
                        color: secondaryColor,
                        size: 16),
                    const SmallText(text: '1w ', color: lightColor)
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
