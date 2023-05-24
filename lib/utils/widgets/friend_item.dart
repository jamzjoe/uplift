import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class FriendItem extends StatelessWidget {
  const FriendItem({
    super.key,
    required this.userFriendship,
  });
  final UserModel userFriendship;

  @override
  Widget build(BuildContext context) {
    UserModel user = userFriendship;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          ProfilePhoto(user: user, radius: 15),
          const SizedBox(width: 15),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HeaderText(
                            text: user.displayName ?? 'User',
                            color: secondaryColor,
                            size: 18,
                          ),
                          const SizedBox(height: 5),
                          SmallText(
                              text:
                                  'Friends since ${user.createdAt!.toDate().year}',
                              color: lightColor),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
