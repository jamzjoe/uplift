import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/get_prayer_request/get_prayer_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friends_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/settings/count_details.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/pop_up.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class SettingsProfileHeader extends StatefulWidget {
  const SettingsProfileHeader({
    Key? key,
    required this.userJoinedModel,
  }) : super(key: key);

  final UserJoinedModel userJoinedModel;

  @override
  State<SettingsProfileHeader> createState() => _SettingsProfileHeaderState();
}

class _SettingsProfileHeaderState extends State<SettingsProfileHeader> {
  bool editMode = true;
  @override
  Widget build(BuildContext context) {
    final user = widget.userJoinedModel.user;
    final userModel = widget.userJoinedModel.userModel;

    final bioController = TextEditingController(text: userModel.bio ?? '');

    return GestureDetector(
      onTap: () {
        uploadBio(bioController, context, user);
      },
      child: Container(
        color: whiteColor,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => context.pushNamed('edit-profile',
                  extra: widget.userJoinedModel),
              child: Row(
                children: [
                  ProfilePhoto(user: userModel, radius: 15),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeaderText(
                          text: userModel.displayName ?? '',
                          color: lighter,
                          size: 18,
                        ),
                        Row(
                          children: [
                            SmallText(
                              text: userModel.emailAddress ?? '',
                              color: lightColor,
                            ),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () => context.pushNamed('qr_generator',
                                  extra: userModel),
                              child: const Icon(Ionicons.qr_code,
                                  size: 15, color: lightColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            defaultSpace,
            GestureDetector(
              onTap: () async => showPopProfile(context, userModel, userModel),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BlocBuilder<GetPrayerRequestBloc, GetPrayerRequestState>(
                      builder: (context, state) {
                        if (state is LoadingPrayerRequesListSuccess) {
                          return CountAndName(
                              details: 'Prayer Intentions',
                              count: state.length ?? 0);
                        } else {
                          return const CountAndName(
                              details: 'Prayer Intentions', count: 0);
                        }
                      },
                    ),
                    const VerticalDivider(),
                    FutureBuilder(
                      future: FriendsRepository()
                          .fetchApprovedFollowerFriendRequest(user.uid),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data!.length;
                          return CountAndName(
                              details: 'Followers', count: data);
                        }
                        return const CountAndName(
                            details: 'Followers', count: 0);
                      },
                    ),
                    const VerticalDivider(),
                    FutureBuilder(
                      future: FriendsRepository()
                          .fetchApprovedFollowingRequest(user.uid),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data!.length;
                          return CountAndName(
                              details: 'Following', count: data);
                        }
                        return const CountAndName(
                            details: 'Following', count: 0);
                      },
                    ),
                  ],
                ),
              ),
            ),
            defaultSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomContainer(
                  onTap: () => context.pushNamed('edit-profile',
                      extra: widget.userJoinedModel),
                  widget: SmallText(text: 'Edit profile', color: lighter),
                  color: whiteColor,
                ),
              ],
            ),
            defaultSpace,
            editMode
                ? Padding(
                    padding: const EdgeInsets.only(left: 45),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        bioController.text.isEmpty
                            ? const SmallText(
                                text: 'Write your bio here', color: darkColor)
                            : SmallText(
                                text: bioController.text, color: darkColor),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                editMode = !editMode;
                              });
                            },
                            icon: const Icon(CupertinoIcons.pencil))
                      ],
                    ),
                  )
                : TextFormField(
                    autofocus: false,
                    maxLength: 150,
                    onEditingComplete: () {
                      uploadBio(bioController, context, user);
                    },
                    onFieldSubmitted: (value) {
                      setState(() {
                        editMode = !editMode;
                      });
                      uploadBio(bioController, context, user);
                    },
                    decoration: const InputDecoration(
                        hintText: 'Type here...', helperText: 'Bio'),
                    textAlign: TextAlign.center,
                    controller: bioController,
                    style: const TextStyle(fontSize: 14),
                  )
          ],
        ),
      ),
    );
  }

  void uploadBio(
      TextEditingController bioController, BuildContext context, User user) {
    setState(() {
      editMode = !editMode;
    });
    FocusScope.of(context).unfocus();

    widget.userJoinedModel.userModel.bio = bioController.text;
    BlocProvider.of<AuthenticationBloc>(context)
        .add(SignIn(widget.userJoinedModel));
    BlocProvider.of<AuthenticationBloc>(context)
        .add(UpdateBio(user.uid, bioController.text));
  }

  void showPopProfile(
      BuildContext context, UserModel userModel, UserModel currentUser) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    CustomDialog().showProfile(context, currentUser, userModel);
  }
}
