import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class UpcomingEventItem extends StatelessWidget {
  const UpcomingEventItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                    image: NetworkImage(
                        'https://lakansining.files.wordpress.com/2017/07/1987-san-isidro-labrador-parish-church-philand-drive-tandang-sora.jpg'),
                    fit: BoxFit.cover)),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      DefaultText(
                          text: 'Museum Week Fest', color: secondaryColor),
                      SmallText(text: 'By James Cameron', color: lightColor),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const SmallText(
                      text: 'May 21, 09:00 pm  OnSite', color: lightColor)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
