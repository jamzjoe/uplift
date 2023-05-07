import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friends_item_shimmer.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class FriendsItem extends StatelessWidget {
  const FriendsItem({
    super.key,
    required this.friendShipModel,
    required this.user,
  });
  final FriendShipModel friendShipModel;
  final User user;

  @override
  Widget build(BuildContext context) {
    CollectionReference reference =
        FirebaseFirestore.instance.collection('Users');
    return FutureBuilder(
        future: user.uid == friendShipModel.receiver
            ? reference.doc(friendShipModel.sender!).get()
            : reference.doc(friendShipModel.receiver!).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const FriendsShimmerItem(
              type: 'text',
            );
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      SmallText(
                          text:
                              'Friends since ${friendShipModel.timestamp!.toDate().year}',
                          color: lightColor)
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
