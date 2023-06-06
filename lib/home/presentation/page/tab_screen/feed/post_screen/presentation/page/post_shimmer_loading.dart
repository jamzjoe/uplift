import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uplift/constant/constant.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      children:  [
       Shimmer.fromColors(
          highlightColor: Colors.white.withOpacity(.8),
          baseColor: secondaryColor.withOpacity(0.2),
         child: Container(
                        height: 120,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: primaryColor.withOpacity(0.4)),
                      ),
       ),
        const PostItemShimmerLoading(),
        const PostItemShimmerLoading(),
        const PostItemShimmerLoading(),
        const PostItemShimmerLoading()
      ],
    );
  }
}
