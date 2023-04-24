import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class PostItem extends StatelessWidget {
  const PostItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.5),
      color: whiteColor,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        children: [
          //Profile, Name and Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      HeaderText(
                        text: 'Michael Mendez',
                        color: secondaryColor,
                        size: 18,
                      ),
                      SmallText(text: 'Just now', color: lightColor)
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  PopupMenuButton(
                    icon: const Icon(Icons.more_horiz),
                    itemBuilder: (context) => [],
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.close))
                ],
              )
            ],
          ),
          defaultSpace,
          //Description
          const DefaultText(
              text:
                  'Vorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis.',
              color: secondaryColor),
          defaultSpace,

          //Likes and Views Count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  CircleAvatar(
                    radius: 10,
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
