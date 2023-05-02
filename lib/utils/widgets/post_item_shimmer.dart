import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class PostItemShimmerLoading extends StatefulWidget {
  const PostItemShimmerLoading({super.key});

  @override
  State<PostItemShimmerLoading> createState() => _PostItemShimmerLoadingState();
}

class _PostItemShimmerLoadingState extends State<PostItemShimmerLoading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      color: whiteColor,
      child: Shimmer.fromColors(
          highlightColor: Colors.white.withOpacity(.8),
          baseColor: secondaryColor.withOpacity(0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Profile, Name and Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/default1.jpg'),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          CustomContainer(
                              width: 100,
                              widget: SizedBox(),
                              color: lightColor),
                          SizedBox(height: 5),
                          CustomContainer(
                              width: 45, widget: SizedBox(), color: lightColor),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      PopupMenuButton(
                        icon: const Icon(Icons.more_horiz),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              child: ListTile(
                            onTap: () {},
                            dense: true,
                            leading: const Icon(CupertinoIcons.bookmark_fill),
                            title: Container(),
                          ))
                        ],
                      ),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.close))
                    ],
                  )
                ],
              ),
              defaultSpace,
              //Description
              const CustomContainer(
                  width: double.infinity,
                  widget: SizedBox(),
                  color: lightColor),
              const SizedBox(height: 5),
              //Description
              const CustomContainer(
                  width: double.infinity,
                  widget: SizedBox(),
                  color: lightColor),
              //Description
              const SizedBox(height: 5),
              const CustomContainer(
                  width: 90, widget: SizedBox(), color: lightColor),
              defaultSpace,

              //Likes and Views Count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      CircleAvatar(
                        radius: 10,
                        backgroundImage: AssetImage('assets/default.png'),
                      ),
                      SizedBox(width: 5),
                      CustomContainer(
                          width: 50, widget: SizedBox(), color: lightColor),
                    ],
                  ),
                  const CustomContainer(
                      width: 50, widget: SizedBox(), color: lightColor),
                ],
              ),

              const Divider(),
              Row(
                children: [
                  TextButton.icon(
                      onPressed: () {},
                      icon: const Image(
                        image: AssetImage('assets/pray.png'),
                        width: 30,
                      ),
                      label: SmallText(
                        text: 'Prayed',
                        color: secondaryColor.withOpacity(0.8),
                      )),
                  TextButton.icon(
                      onPressed: () {},
                      icon: const Image(
                        image: AssetImage('assets/share.png'),
                        width: 30,
                      ),
                      label: SmallText(
                        text: 'Share',
                        color: secondaryColor.withOpacity(0.8),
                      ))
                ],
              )
            ],
          )),
    );
  }
}
