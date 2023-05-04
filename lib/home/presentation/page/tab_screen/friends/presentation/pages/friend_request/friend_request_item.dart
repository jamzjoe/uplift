import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friends_item_shimmer.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import '../../../data/model/friendship_model.dart';

class FriendRequestItem extends StatelessWidget {
  const FriendRequestItem({
    super.key,
    required this.friendShip,
  });
  final FriendShipModel friendShip;

  @override
  Widget build(BuildContext context) {
    CollectionReference reference =
        FirebaseFirestore.instance.collection('Users');
    return FutureBuilder(
        future: reference.doc(friendShip.sender!).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const FriendsShimmerItem();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                snapshot.data!['photo_url'] == null
                    ? const CircleAvatar(
                        backgroundImage: AssetImage('assets/default.png'),
                      )
                    : CircleAvatar(
                        backgroundImage:
                            NetworkImage(snapshot.data!['photo_url']),
                      ),
                const SizedBox(width: 15),
                Flexible(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HeaderText(
                            text: snapshot.data!['display_name'] ?? 'User',
                            color: secondaryColor,
                            size: 18,
                          ),
                          const SmallText(text: '1w ', color: lightColor)
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
                                    text: 'Delete', color: secondaryColor),
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
          );
        });
  }
}
