import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uplift/constant/constant.dart';

class PostPhotoViewer extends StatelessWidget {
  const PostPhotoViewer({super.key, required this.path, this.radius});
  final String path;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed('photo_view', extra: path),
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 15)),
          clipBehavior: Clip.hardEdge,
          child: CachedNetworkImage(
              fit: BoxFit.cover,
              width: double.infinity,
              height: 400,
              imageUrl: path,
              placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: secondaryColor.withOpacity(0.2),
                  highlightColor: secondaryColor.withOpacity(0.1),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(radius ?? 15),
                      color: primaryColor.withOpacity(0.2),
                    ),
                    width: double.infinity,
                  )),
              errorWidget: (context, url, error) => const SizedBox())),
    );
  }
}
