import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class EventItem extends StatelessWidget {
  const EventItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 250,
      height: 150,
      decoration: BoxDecoration(
          image: const DecorationImage(
              image: NetworkImage(
                  'https://lakansining.files.wordpress.com/2017/07/1987-san-isidro-labrador-parish-church-philand-drive-tandang-sora.jpg'),
              colorFilter: ColorFilter.mode(Colors.black, BlendMode.screen),
              fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                decoration: BoxDecoration(
                    color: whiteColor, borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Ionicons.flag, size: 15),
                    SizedBox(width: 5),
                    SmallText(
                        text: 'San Isidro Labrador', color: secondaryColor),
                  ],
                ),
              ),
            ],
          ),
          const CustomContainer(
              width: double.infinity,
              widget: Center(
                  child: DefaultText(text: 'Join Event', color: whiteColor)),
              color: linkColor)
        ],
      ),
    );
  }
}
