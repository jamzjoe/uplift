import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/get_prayer_request/get_prayer_request_bloc.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import '../../../../../../../../constant/constant.dart';
import '../../../../../../../../utils/widgets/default_text.dart';

class PostItem extends StatefulWidget {
  const PostItem({
    super.key,
    required this.postModel,
  });
  final PostModel postModel;

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.postModel.userModel;
    final prayerRequest = widget.postModel.prayerRequestPostModel;
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
              user.photoUrl == null
                  ? const CircleAvatar(
                      backgroundImage: AssetImage('assets/default.png'),
                    )
                  : CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl!),
                    ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderText(
                      text: user.displayName ?? 'User',
                      color: secondaryColor,
                      size: 18,
                    ),
                    const SmallText(text: 'Just now', color: lightColor)
                  ],
                ),
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
                      )),
                      PopupMenuItem(
                          child: ListTile(
                        onTap: () {},
                        dense: true,
                        leading: const Icon(CupertinoIcons.delete_left_fill),
                        title: const DefaultText(
                            text: 'Delete Post', color: secondaryColor),
                      ))
                    ],
                  ),
                ],
              )
            ],
          ),
          defaultSpace,
          DefaultText(text: prayerRequest.text!, color: secondaryColor),
          defaultSpace,

          //Likes and Views Count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 10,
                    backgroundImage: AssetImage('assets/default.png'),
                  ),
                  const SizedBox(width: 5),
                  SmallText(
                      text: prayerRequest.reactions!.users!.length.toString(),
                      color: lightColor)
                ],
              ),
            ],
          ),

          const Divider(),
          Row(
            children: [
              TextButton.icon(
                  onPressed: () {
                    BlocProvider.of<GetPrayerRequestBloc>(context)
                        .add(AddReaction(user.userId!, prayerRequest.postId!));
                  },
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
