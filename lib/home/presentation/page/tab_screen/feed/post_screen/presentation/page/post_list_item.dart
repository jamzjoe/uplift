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
      child: Column(
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
