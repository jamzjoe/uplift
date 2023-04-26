import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: CachedNetworkImage(
            fit: BoxFit.cover,
            width: 40,
            height: 40,
            imageUrl: user.photoURL ?? 'null',
            progressIndicatorBuilder: (context, url, progress) =>
                CircularProgressIndicator(value: progress.progress),
            errorWidget: (context, url, error) => const CircleAvatar(
                  radius: 50,
                  child: Image(image: AssetImage('assets/default.png')),
                )));
  }
}
