import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_model.dart';

class SafePhotoViewer extends StatelessWidget {
  const SafePhotoViewer({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: CachedNetworkImage(
            fit: BoxFit.cover,
            width: 45,
            height: 45,
            imageUrl: user.photoUrl!,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const CircleAvatar(
                  radius: 50,
                  child: Image(image: AssetImage('assets/default.png')),
                )));
  }
}