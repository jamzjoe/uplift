import 'package:flutter/material.dart';
import 'package:uplift/utils/widgets/post_item_shimmer.dart';

class PostShimmerLoading extends StatefulWidget {
  const PostShimmerLoading({super.key});

  @override
  State<PostShimmerLoading> createState() => _PostShimmerLoadingState();
}

class _PostShimmerLoadingState extends State<PostShimmerLoading> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        PostItemShimmerLoading(),
        PostItemShimmerLoading(),
        PostItemShimmerLoading(),
        PostItemShimmerLoading()
      ],
    );
  }
}
