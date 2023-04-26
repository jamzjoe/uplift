import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/friend_request_item.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';

class FriendRequestList extends StatelessWidget {
  const FriendRequestList({
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
                DefaultText(text: 'Friend request', color: secondaryColor),
                SizedBox(width: 5),
                HeaderText(text: '45', color: primaryColor, size: 18)
              ],
            ),
            const DefaultText(text: 'See all', color: linkColor)
          ],
        ),
        const FriendRequestItem(),
        const FriendRequestItem(),
        const FriendRequestItem(),
        const FriendRequestItem(),
        const FriendRequestItem()
      ],
    );
  }
}
