import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';

class ProfilePhoto extends StatelessWidget {
  final double? size;
  final double? radius;
  const ProfilePhoto({
    super.key,
    required this.user,
    this.size,
    this.radius,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(360),
        child: CachedNetworkImage(
            fit: BoxFit.cover,
            width: size ?? 45,
            height: size ?? 45,
            imageUrl: user.photoUrl ?? 'null',
            progressIndicatorBuilder: (context, url, progress) =>
                const SizedBox(),
            errorWidget: (context, url, error) => Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: primaryColor,
                ),
                child: const Image(
                  image: AssetImage('assets/default.png'),
                  fit: BoxFit.cover,
                ))));
  }
}
