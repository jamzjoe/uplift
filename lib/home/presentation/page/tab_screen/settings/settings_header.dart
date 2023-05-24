import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/friends_feed.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/get_prayer_request/get_prayer_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friends_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/settings/count_details.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class SettingsProfileHeader extends StatelessWidget {
  const SettingsProfileHeader({
    Key? key,
    required this.userJoinedModel,
  }) : super(key: key);

  final UserJoinedModel userJoinedModel;
  

  @override
  Widget build(BuildContext context) {
    final user = userJoinedModel.user;
    final userModel = userJoinedModel.userModel;

    final bioController = TextEditingController(text: userModel.bio ?? '');

    return Container(
      padding: const EdgeInsets.all(20),
      color: whiteColor,
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                  onTap: () => context.pushNamed('photo_view',
                      extra: userModel.photoUrl ?? ''),
                  child: ProfilePhoto(user: userModel, radius: 15)),
              const SizedBox(width: 10),
              Flexible(
                child: GestureDetector(
                  onTap: () async {
                    showPopProfile(context, userModel);
                  },
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
                            onTap: () => context.pushNamed('qr_generator2',
                                extra: userModel),
                            child: const Icon(Ionicons.qr_code,
                                size: 15, color: lightColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          defaultSpace,
          GestureDetector(
            onTap: () async => showPopProfile(context, userModel),
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
                            count: state.prayerRequestPostModel.length);
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
                        return CountAndName(details: 'Followers', count: data);
                      }
                      return const CountAndName(details: 'Followers', count: 0);
                    },
                  ),
                  const VerticalDivider(),
                  FutureBuilder(
                    future: FriendsRepository()
                        .fetchApprovedFollowingRequest(user.uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data!.length;
                        return CountAndName(details: 'Following', count: data);
                      }
                      return const CountAndName(details: 'Following', count: 0);
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
                onTap: () =>
                    context.pushNamed('edit-profile', extra: userJoinedModel),
                widget: SmallText(text: 'Edit profile', color: lighter),
                color: lighter.withOpacity(0.1),
              ),
            ],
          ),
          defaultSpace,
          TextFormField(
            controller: bioController,
            keyboardType: TextInputType.text,
            autofocus: false,
            onFieldSubmitted: (value) {
              userJoinedModel.userModel.bio = bioController.text;
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(SignIn(userJoinedModel));
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(UpdateBio(user.uid, bioController.text));
            },
            maxLines: 2,
            textAlign: TextAlign.center,
            maxLength: 40,
            decoration: const InputDecoration(
              hintText: 'Write your bio here...',
              contentPadding: EdgeInsets.symmetric(horizontal: 100),
              border: UnderlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }

  void showPopProfile(BuildContext context, UserModel userModel) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      context: context,
      builder: (context) {
        return FriendsFeed(userModel: userModel, isSelf: true, currentUser: userModel);
      },
    );
  }
}
