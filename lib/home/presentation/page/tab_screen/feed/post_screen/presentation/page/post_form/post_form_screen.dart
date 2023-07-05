import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/notifications/presentation/bloc/notification_bloc/notification_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/post_prayer_request/post_prayer_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/approved_friends_bloc/approved_friends_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/same_intention_bloc/same_intentions_suggestion_bloc.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class PostFormScreen extends StatefulWidget {
  const PostFormScreen({super.key, required this.user, this.isPickImage});
  final UserJoinedModel user;
  final bool? isPickImage;

  @override
  State<PostFormScreen> createState() => _PostFormScreenState();
}

class _PostFormScreenState extends State<PostFormScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  Color buttonColor = secondaryColor.withOpacity(0.5);
  String postType = "unanonymous";
  String selectedPrayerIntention = 'Personal';

  // List of prayer intentions titles
  List<String> prayerIntentions = [
    'Personal',
    'Family',
    'Community',
    'Global',
    'Gratitude',
    'Healing',
    'Faith',
    'Vocational',
    'Special'
    // Add more prayer intentions titles as needed
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = widget.user.user;
    final UserModel userModel = widget.user.userModel;

    return BlocListener<PostPrayerRequestBloc, PostPrayerRequestState>(
      listener: (context, state) {
        if (state is PostPrayerRequestSuccess) {}
      },
      child: Form(
        key: _key,
        child: Scaffold(
          appBar: AppBar(
            title: const HeaderText(text: 'Create post', color: darkColor),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomContainer(
                    onTap: () async {
                      if (_key.currentState!.validate()) {
                        List<UserFriendshipModel> friends = [];
                        final bloc =
                            BlocProvider.of<ApprovedFriendsBloc>(context);
                        final state = bloc.state;
                        if (state is ApprovedFriendsSuccess2) {
                          friends = state.approvedFriendList
                              .map((e) => e.userFriendshipModel)
                              .toList();
                        }
                        BlocProvider.of<PostPrayerRequestBloc>(context).add(
                            PostPrayerRequestActivity(
                                user,
                                controller.text,
                                postType == 'anonymous' ? 'Anonymous' : '',
                                friends,
                                selectedPrayerIntention,
                                context));
                        BlocProvider.of<SameIntentionsSuggestionBloc>(context)
                            .add(FetchSameIntentionEvent(userID));
                        context.pop();
                      }
                    },
                    widget: const DefaultText(text: 'Post', color: whiteColor),
                    color: buttonColor),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfilePhoto(user: userModel, radius: 15),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeaderText(
                          text: userModel.displayName ?? 'Anonymous User',
                          color: postType != "unanonymous"
                              ? darkColor.withOpacity(0.5)
                              : darkColor,
                          size: 18,
                        ),
                        const SizedBox(height: 5),
                        GestureDetector(
                          onTap: () {
                            if (postType == "unanonymous") {
                              setState(() {
                                postType = "anonymous";
                              });
                            } else {
                              setState(() {
                                postType = "unanonymous";
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                                color: postType == "unanonymous"
                                    ? lighter.withOpacity(0.4)
                                    : lighter,
                                borderRadius: BorderRadius.circular(60)),
                            child: const Row(
                              children: [
                                Image(
                                  image: AssetImage('assets/incognito.png'),
                                  width: 20,
                                ),
                                SizedBox(width: 5),
                                SmallText(
                                    text: 'Post Anonymously', color: whiteColor)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                defaultSpace,
                SizedBox(
                  width: double.infinity,
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: selectedPrayerIntention,
                    hint: const Text('Select Prayer Intention'),
                    onChanged: (value) {
                      setState(() {
                        selectedPrayerIntention = value ?? '';
                      });
                    },
                    items: prayerIntentions.map((String intention) {
                      return DropdownMenuItem<String>(
                        value: intention,
                        child: Text(intention),
                      );
                    }).toList(),
                  ),
                ),
                defaultSpace,
                Expanded(
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (value) {
                      if (value.length > 5) {
                        setState(() {
                          buttonColor = primaryColor;
                        });
                      } else if (value.length < 5) {
                        setState(() {
                          buttonColor = secondaryColor.withOpacity(0.4);
                        });
                      }
                    },
                    validator: (value) => value!.length < 5 ? '' : null,
                    controller: controller,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 20),
                        hintText: 'Write something you want to pray for...',
                        border:
                            UnderlineInputBorder(borderSide: BorderSide.none)),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
