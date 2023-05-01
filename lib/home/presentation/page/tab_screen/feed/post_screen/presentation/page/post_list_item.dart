import 'package:flutter/material.dart';

import 'post_item.dart';

class PostListItem extends StatelessWidget {
  const PostListItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 125),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        children: const [
          PostItem(),
          PostItem(),
          PostItem(),
          PostItem(),
          PostItem(),
          PostItem(),
          PostItem(),
        ],
      ),
    );
  }
}
