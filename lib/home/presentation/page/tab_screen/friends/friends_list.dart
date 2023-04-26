import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/friends_item.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';

class FriendsList extends StatelessWidget {
  const FriendsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                DefaultText(text: 'Your friends', color: secondaryColor),
                SizedBox(width: 5),
                HeaderText(text: '1,500', color: primaryColor, size: 18)
              ],
            ),
            const DefaultText(text: 'See all', color: linkColor)
          ],
        ),
        const FriendsItem(),
        const FriendsItem(),
        const FriendsItem(),
        const FriendsItem(),
        const FriendsItem(),
        const FriendsItem(),
        const FriendsItem(),
        const FriendsItem(),
        const FriendsItem(),
        const FriendsItem(),
        const FriendsItem(),
        const FriendsItem()
      ],
    );
  }
}
