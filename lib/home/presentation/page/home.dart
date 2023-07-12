import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/notifications/data/model/payload_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/explore/presentation/bloc/explore_get_prayer_request/explore_get_prayer_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/explore/presentation/explore_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/feed_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/prayer_request_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/post_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/get_prayer_request/get_prayer_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/full_post_view/full_post_view.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/presentation/encourage_bloc/encourage_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/approved_friends_bloc/approved_friends_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friend_request_bloc/friend_request_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friends_suggestion_bloc/friends_suggestions_bloc_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/same_intention_bloc/same_intentions_suggestion_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friends_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/friends_feed.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/your_friends_screen.dart';
import 'package:uplift/home/presentation/page/tab_screen/settings/settings_screen.dart';
import 'package:uplift/home/presentation/page/tabbar_material_widget.dart';
import 'package:uplift/authentication/presentation/pages/introduction/presentation/introduction_screen.dart';
import 'package:uplift/utils/widgets/keep_alive.dart';
import '../../../authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'notifications/presentation/bloc/notification_bloc/notification_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'tab_screen/feed/post_screen/data/model/post_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    initialize(flutterLocalNotificationsPlugin);
    firebaseBackgroundNotif();
    initializeDynamicLinks();
    
    super.initState();
  }

  int index = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Ensure the state is kept alive

    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) async {
        userStatus(state, context);
      },
      builder: (context, state) {
        if (state is UserIsIn) {
          final UserJoinedModel userJoinedModel = state.userJoinedModel;
          return Scaffold(
            key: _scaffoldKey,
            extendBody: true,
            body: IndexedStack(
              index: index,
              children: [
                KeepAlivePage(
                  child: FeedScreen(user: userJoinedModel),
                ),
                KeepAlivePage(
                  child: FriendsScreen(currentUser: userJoinedModel.userModel),
                ),
                KeepAlivePage(
                  child: ExploreScreen(user: userJoinedModel.userModel),
                ),
                const KeepAlivePage(child: SettingsScreen())
              ],
            ),
            bottomNavigationBar: TabBarMaterialWidget(
              index: index,
              onChangedTab: onChangedTab,
              user: userJoinedModel.userModel,
            ),
          );
        } else if (state is UserIsOut) {
          return const IntroductionScreen();
        } else if (state is Loading) {
          return const Scaffold(
            backgroundColor: primaryColor,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    SpinKitRipple(
                      color: whiteColor,
                      size: 200,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      left: 0,
                      bottom: 0,
                      child: Center(
                        child: Image(
                          image: AssetImage('assets/uplift-logo-white.png'),
                          width: 80,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return const Text('Error');
        }
      },
    );
  }

  void userStatus(AuthenticationState state, BuildContext context) {
    if (state is UserIsIn) {
      final String currentUserID = state.userJoinedModel.userModel.userId!;
      FlutterNativeSplash.remove();
      BlocProvider.of<GetPrayerRequestBloc>(context)
          .add(GetPostRequestList(currentUserID));
      BlocProvider.of<NotificationBloc>(context)
          .add(FetchListOfNotification(currentUserID));
      BlocProvider.of<FriendRequestBloc>(context)
          .add(FetchFriendRequestEvent(currentUserID));
      BlocProvider.of<FriendsSuggestionsBlocBloc>(context)
          .add(FetchUsersEvent(currentUserID));
      BlocProvider.of<ApprovedFriendsBloc>(context)
          .add(FetchApprovedFriendRequest(currentUserID));
      BlocProvider.of<SameIntentionsSuggestionBloc>(context)
          .add(FetchSameIntentionEvent(currentUserID));
      BlocProvider.of<ExploreBloc>(context)
          .add(GetExplorePrayerRequestList(currentUserID));
    } else if (state is UserIsOut) {
      // Handle user logged out state
      // You can navigate to a login screen or show a different UI
      setState(() {
        index = 0;
      });
    }
  }

  void onChangedTab(int value) {
    setState(() {
      index = value;
    });
  }

  Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        const AndroidInitializationSettings('@drawable/ic_notification');
    var iosInitialize = const DarwinInitializationSettings();
    var initializeSettings =
        InitializationSettings(android: androidInitialize, iOS: iosInitialize);
    flutterLocalNotificationsPlugin.initialize(initializeSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveNotificationResponse);
  }

  void firebaseBackgroundNotif() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      if (message == null) return;

      final payload = message.data['data'];
      final data = jsonDecode(payload!);
      final notifType = data['type'];

      if (notifType == notificationType.comment.name) {
        final postId = data['post_id'];
        final postUserID = data['post_user_id'];
        final postModel =
            await PostRepository().getEachPrayerIntention(postId, postUserID);
        final userID = FirebaseAuth.instance.currentUser!.uid;
        final currentUser =
            await PrayerRequestRepository().getUserRecord(userID);
        openPrayerIntention(context, postModel!.userModel,
            postModel.prayerRequestPostModel, currentUser!);
      } else if (notifType == notificationType.friend_request.name) {
        final currentUser =
            await PrayerRequestRepository().getUserRecord(data['current_user']);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => YourFriendsScreen(user: currentUser!),
          ),
        );
      } else if (notifType == notificationType.post.name ||
          notifType == notificationType.react.name) {
        final decodedPayload = jsonDecode(payload);
        final timestampString = decodedPayload['date'];
        final timestamp = Timestamp.fromDate(DateTime.parse(timestampString));
        final text = decodedPayload['text'];
        final userId = decodedPayload['user_id'];
        final postId = decodedPayload['post_id'];
        final customName = decodedPayload['custom_name'];
        final title = decodedPayload['title'];

        final data = PrayerRequestPostModel(
          date: timestamp,
          text: text,
          userId: userId,
          postId: postId,
          name: customName,
          title: title,
        );

        final userID = FirebaseAuth.instance.currentUser!.uid;
        final currentUser =
            await PrayerRequestRepository().getUserRecord(userID);
        final postUser = await PrayerRequestRepository().getUserRecord(userId);
        openPrayerIntention(context, postUser!, data, currentUser!);
      }
    });
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final payload = notificationResponse.payload;

    if (payload != null) {
      debugPrint('notification payload: $payload');
      log('My payload:$payload');
    }

    final data = jsonDecode(payload!);
    final notifType = data['type'];

    if (notifType == notificationType.comment.name) {
      final postId = data['post_id'];
      final postUserID = data['post_user_id'];
      final postModel =
          await PostRepository().getEachPrayerIntention(postId, postUserID);
      final userID = FirebaseAuth.instance.currentUser!.uid;
      final currentUser = await PrayerRequestRepository().getUserRecord(userID);
      openPrayerIntention(context, postModel!.userModel,
          postModel.prayerRequestPostModel, currentUser!);
    } else if (notifType == notificationType.friend_request.name) {
      final currentUser =
          await PrayerRequestRepository().getUserRecord(data['current_user']);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => YourFriendsScreen(user: currentUser!),
        ),
      );
    } else if (notifType == notificationType.post.name ||
        notifType == notificationType.react.name) {
      final decodedPayload = jsonDecode(payload);
      final timestampString = decodedPayload['date'];
      final timestamp = Timestamp.fromDate(DateTime.parse(timestampString));
      final text = decodedPayload['text'];
      final userId = decodedPayload['user_id'];
      final postId = decodedPayload['post_id'];
      final customName = decodedPayload['custom_name'];
      final title = decodedPayload['title'];

      final data = PrayerRequestPostModel(
        date: timestamp,
        text: text,
        userId: userId,
        postId: postId,
        name: customName,
        title: title,
      );

      final userID = FirebaseAuth.instance.currentUser!.uid;
      final currentUser = await PrayerRequestRepository().getUserRecord(userID);
      final postUser = await PrayerRequestRepository().getUserRecord(userId);
      openPrayerIntention(context, postUser!, data, currentUser!);
    }
  }

  void openPrayerIntention(BuildContext context, UserModel user,
      PrayerRequestPostModel data, UserModel currentUser) {
    BlocProvider.of<EncourageBloc>(context)
        .add(FetchEncourageEvent(data.postId!));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullPostView(
            postModel: PostModel(user, data), currentUser: currentUser),
      ),
    );
  }

  void initializeDynamicLinks() async {
    // Check if you received the link via `getInitialLink` first
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();

    if (initialLink != null) {
      final userID = FirebaseAuth.instance.currentUser!.uid;
      final currentUser = await PrayerRequestRepository().getUserRecord(userID);
      final Uri deepLink = initialLink.link;
      // Example of using the dynamic link to push the user to a different screen
      final List<String> splittedData = deepLink.path.split('/');
      // context.pushNamed('test', extra: '$postId$postUserID');
      if (splittedData[1] == 'profile') {
        final scannedUserID = splittedData[2];
        final scannedUser =
            await PrayerRequestRepository().getUserRecord(scannedUserID);
        final ScrollController scrollController = ScrollController();
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FriendsFeed(
                  userModel: scannedUser!,
                  currentUser: currentUser!,
                  scrollController: scrollController),
            ));
      } else if (splittedData[1] == 'share') {
        final postId = splittedData[2];
        final postUserID = splittedData[3];
        // context.pushNamed('test', extra: '$postId$postUserID');
        final postModel =
            await PostRepository().getEachPrayerIntention(postId, postUserID);

        // ignore: use_build_context_synchronously
        openPrayerIntention(context, postModel!.userModel,
            postModel.prayerRequestPostModel, currentUser!);
      }
    }

    FirebaseDynamicLinks.instance.onLink.listen(
      (pendingDynamicLinkData) async {
        final userID = FirebaseAuth.instance.currentUser!.uid;
        final currentUser =
            await PrayerRequestRepository().getUserRecord(userID);
        // Set up the `onLink` event listener next as it may be received here
        final Uri deepLink = pendingDynamicLinkData.link;
        final List<String> splittedData = deepLink.path.split('/');

        if (splittedData[1] == 'profile') {
          final scannedUserID = splittedData[2];
          final scannedUser =
              await PrayerRequestRepository().getUserRecord(scannedUserID);
          final ScrollController scrollController = ScrollController();
          // ignore: use_build_context_synchronously
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FriendsFeed(
                    userModel: scannedUser!,
                    currentUser: currentUser!,
                    scrollController: scrollController),
              ));
        } else if (splittedData[1] == 'share') {
          final postId = splittedData[2];
          final postUserID = splittedData[3];
          // context.pushNamed('test', extra: '$postId$postUserID');
          final postModel =
              await PostRepository().getEachPrayerIntention(postId, postUserID);

          // ignore: use_build_context_synchronously
          openPrayerIntention(context, postModel!.userModel,
              postModel.prayerRequestPostModel, currentUser!);
        }
      },
    );
  }
}
