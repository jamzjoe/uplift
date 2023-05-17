import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:photo_view/photo_view.dart';
import 'package:uplift/constant/constant.dart';

class PhotoViewScreen extends StatelessWidget {
  const PhotoViewScreen({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: PhotoView(
        loadingBuilder: (context, event){
          return const SpinKitFadingCircle(color: primaryColor);
        },
        imageProvider: NetworkImage(url),
      ),
    );
  }
}
