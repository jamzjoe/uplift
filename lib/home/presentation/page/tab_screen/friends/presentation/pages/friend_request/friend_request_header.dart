import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/utils/widgets/header_text.dart';

import '../../../../../../../../constant/constant.dart';
import '../../../../../../../../utils/widgets/default_text.dart';

class FriendRequestHeader extends StatelessWidget {
  const FriendRequestHeader({
    super.key,
    required this.friendRequestCount,
  });
  final int friendRequestCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const HeaderText(
              text: 'Friend request',
              color: secondaryColor,
              size: 18,
            ),
            const SizedBox(width: 5),
            HeaderText(
                text: friendRequestCount.toString(),
                color: primaryColor,
                size: 18)
          ],
        ),
        GestureDetector(
            onTap: () => context.pushNamed('friend_request'),
            child: const DefaultText(text: 'See all', color: linkColor))
      ],
    );
  }
}
