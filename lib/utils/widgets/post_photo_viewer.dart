import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uplift/constant/constant.dart';

class PostPhotoViewer extends StatelessWidget {
  const PostPhotoViewer({super.key, required this.path});
  final String path;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250,
              imageUrl: path,
              placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: secondaryColor.withOpacity(0.2),
                  highlightColor: secondaryColor.withOpacity(0.1),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: primaryColor,
                    ),
                    height: 250,
                    width: double.infinity,
                  )),
              errorWidget: (context, url, error) => const SizedBox())),
    );
  }
}
