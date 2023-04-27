import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/default_text.dart';

import 'add_friend_item.dart';

class FriendSuggestions extends StatelessWidget {
  const FriendSuggestions({
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
                DefaultText(text: 'Friend suggestions', color: secondaryColor),
              ],
            ),
            const DefaultText(text: 'See more', color: linkColor)
          ],
        ),
        defaultSpace,
        const AddFriendItem(),
        const AddFriendItem()
      ],
    );
  }
}
