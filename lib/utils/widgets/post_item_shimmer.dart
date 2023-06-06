import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/default_text.dart';


class PostItemShimmerLoading extends StatefulWidget {
  const PostItemShimmerLoading({super.key});

  @override
  State<PostItemShimmerLoading> createState() => _PostItemShimmerLoadingState();
}

class _PostItemShimmerLoadingState extends State<PostItemShimmerLoading> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Shimmer.fromColors(
          highlightColor: Colors.white.withOpacity(.8),
          baseColor: secondaryColor.withOpacity(0.2),
          child: 
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                const Header(),
                const ContentShimmer(),
                const Space(),
                Row(
                  children: [
                    Container(
                      height: 30,
                      width: 70,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: primaryColor),
                    ),
                    const SizedBox(width: 10),
                     Container(
                      height: 30,
                      width: 120,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: primaryColor.withOpacity(0.4)),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: primaryColor.withOpacity(0.4)),
                    ),
                  ],
                )
      
            ],
          )
          
          ),
    );
  }
}

class ContentShimmer extends StatelessWidget {
  const ContentShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomContainer(widget: SizedBox(), color: primaryColor, width: double.infinity),
        Space(),
        CustomContainer(widget: SizedBox(), color: primaryColor, width: double.infinity),
        Space(),
        CustomContainer(widget: SizedBox(), color: primaryColor, width: 150)
      ],
    );
  }
}

class Space extends StatelessWidget {
  const Space({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 10);
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CircleAvatar(
      radius: 18,
      backgroundImage: AssetImage('assets/default.png'),
    ),
          
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
   CustomContainer(widget: SizedBox(), color: primaryColor, width: 100),
   Space(),
   CustomContainer(widget: SizedBox(), color: primaryColor, width: 80),
    
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PopupMenuButton(
    padding: EdgeInsets.zero,
    icon: const Icon(
      CupertinoIcons.ellipsis,
      size: 15,
      color: darkColor,
    ),
    itemBuilder: (context) => [
      PopupMenuItem(
          onTap: () async {
            
          },
          child: ListTile(
            dense: true,
            leading: Icon(CupertinoIcons.exclamationmark_bubble_fill,
                color: Colors.red[300]),
            title: const DefaultText(
                text: 'Report Post', color: darkColor),
          )),
      PopupMenuItem(
          onTap: () async {
       
          },
          child: ListTile(
            dense: true,
            leading: Icon(CupertinoIcons.bell_circle_fill,
                color: Colors.red[300]),
            title: const DefaultText(
                text: 'Set reminder for this post', color: darkColor),
          )),
      PopupMenuItem(
          onTap: () async {
            Future.delayed(
                const Duration(milliseconds: 300),
                () {});
          },
          child: ListTile(
            dense: true,
            leading: Icon(CupertinoIcons.delete_left_fill,
                color: Colors.red[300]),
            title: const DefaultText(
                text: 'Delete Post', color: darkColor),
          ))
    ],
            ),
          ],
        )
      ],
    );
  }
}
