import 'package:flutter/material.dart';
import 'package:uplift/home/presentation/page/post_screen/presentation/page/post_item.dart';

class PostListItem extends StatelessWidget {
  const PostListItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        PostItem(),
        PostItem(),
        PostItem(),
        PostItem(),
        PostItem(),
        PostItem(),
        PostItem(),
      ],
    );
  }
}
