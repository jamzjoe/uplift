import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import '../../../../../../../../constant/constant.dart';
import '../../../../../../../../utils/widgets/default_text.dart';
import '../../data/model/prayer_request_model.dart';

class PostItem extends StatefulWidget {
  const PostItem({
    super.key,
    required this.postModel,
  });
  final PrayerRequestPostModel postModel;

  @override
  State<PostItem> createState() => _PostItemState();
}

UserModel userModel = UserModel();

class _PostItemState extends State<PostItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      color: whiteColor,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Profile, Name and Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  userModel.photoUrl == null
                      ? const CircleAvatar(
                          backgroundImage: AssetImage('assets/default.png'),
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(userModel.photoUrl!),
                        ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderText(
                        text: userModel.displayName ?? 'User',
                        color: secondaryColor,
                        size: 18,
                      ),
                      const SmallText(text: 'Just now', color: lightColor)
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
                        title: const DefaultText(
                            text: 'Save Post', color: secondaryColor),
                      ))
                    ],
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.close))
                ],
              )
            ],
          ),
          defaultSpace,
          DefaultText(text: widget.postModel.text!, color: secondaryColor),
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
                  SmallText(text: 'Joe +12K', color: lightColor)
                ],
              ),
              const SmallText(text: '1K Views', color: lightColor)
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
      ),
    );
  }
}
