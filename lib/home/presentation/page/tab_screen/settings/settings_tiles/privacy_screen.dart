import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/get_prayer_request/get_prayer_request_bloc.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  _PrivacyScreenState createState() => _PrivacyScreenState();
}

bool light = false;
String privacyText = 'Public';

class _PrivacyScreenState extends State<PrivacyScreen> {
  @override
  void initState() {
    checkPrivacy();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const HeaderText(
            text: 'Prayer Intentions Privacy', color: darkColor),
      ),
      body: SafeArea(
        child: ListTile(
          leading: const Icon(CupertinoIcons.lock_circle_fill, size: 35),
          subtitle: Row(
            children: [
              !light
                  ? const Icon(
                      CupertinoIcons.globe,
                      color: primaryColor,
                      size: 20,
                    )
                  : const Icon(CupertinoIcons.lock_shield,
                      color: primaryColor, size: 20),
              const SizedBox(width: 5),
              SmallText(text: privacyText, color: linkColor),
            ],
          ),
          title: const DefaultText(
              text: 'Who can see my prayer intentions?', color: darkColor),
          trailing: Transform.scale(
            scale: 0.8,
            child: Switch(
              value: light,
              activeColor: primaryColor,
              onChanged: (bool value) {
                updatePrivacy(value ? 'private' : 'public');
                setState(() {
                  light = value;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updatePrivacy(String status) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userID).get();

    if (userDoc.exists) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userID)
          .update({'privacy': status}).then((value) {
        checkPrivacy();
        refreshFeed();
      }).catchError((error) => log('Error updating privacy: $error'));
    } else {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userID)
          .set({'privacy': status}).then((value) {
        checkPrivacy();
        refreshFeed();
        log('Privacy field created and updated successfully!');
      }).catchError((error) => log('Error creating privacy field: $error'));
    }
  }

  void refreshFeed() {
    BlocProvider.of<GetPrayerRequestBloc>(context)
        .add(GetPostRequestList(userID, limit: 30));
  }

  Future<void> checkPrivacy() async {
    final UserModel? userModel =
        await PrayerRequestRepository().getUserRecord(userID);
    if (userModel!.privacy != null) {
      bool status = userModel.privacy! == 'private';
      setState(() {
        light = status;
        if (status == true) {
          privacyText = "Private";
        } else {
          privacyText = "Public";
        }
      });
    }
  }
}
