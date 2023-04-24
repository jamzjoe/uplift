import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const HeaderText(text: 'Friends', color: secondaryColor),
        actions: [
          IconButton(
            icon: const Icon(Ionicons.search),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: ListView(
          children: [
            Row(
              children: [
                CustomButton(
                    widget: const DefaultText(
                        text: 'Suggestions', color: secondaryColor),
                    color: lightColor.withOpacity(0.2)),
                const SizedBox(width: 15),
                CustomButton(
                    widget: const DefaultText(
                        text: 'Your friends', color: secondaryColor),
                    color: lightColor.withOpacity(0.2))
              ],
            ),
            Divider(
              color: primaryColor.withOpacity(0.2),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    DefaultText(text: 'Friend request', color: secondaryColor),
                    SizedBox(width: 5),
                    HeaderText(text: '45', color: primaryColor, size: 18)
                  ],
                ),
                const DefaultText(text: 'See all', color: linkColor)
              ],
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      const CircleAvatar(radius: 25),
                      const SizedBox(width: 15),
                      Flexible(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                DefaultText(
                                    text: 'Alyssa Mae Keith',
                                    color: secondaryColor),
                                SmallText(text: '1w ', color: lightColor)
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 7, horizontal: 15),
                                    decoration: BoxDecoration(
                                        color: linkColor,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: const Center(
                                      child: DefaultText(
                                          text: 'Confirm', color: whiteColor),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 7, horizontal: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: lightColor.withOpacity(0.2),
                                    ),
                                    child: const Center(
                                      child: DefaultText(
                                          text: 'Delete',
                                          color: secondaryColor),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
