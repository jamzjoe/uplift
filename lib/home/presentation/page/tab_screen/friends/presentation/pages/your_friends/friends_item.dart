import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class FriendsItem extends StatelessWidget {
  const FriendsItem({
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
                  backgroundImage: AssetImage('assets/default.png'),
                )
              : CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl!),
                ),
          const SizedBox(width: 15),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HeaderText(
                      text: user.displayName ?? 'User',
                      color: secondaryColor,
                      size: 18,
                    ),
                    const SmallText(text: '1w ', color: lightColor)
                  ],
                ),
                const SizedBox(height: 5),
                SmallText(
                    text: 'Friends since ${user.createdAt!.toDate().year}',
                    color: lightColor)
              ],
            ),
          )
        ],
      ),
    );
  }
}
