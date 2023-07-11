import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/home/presentation/page/home_screen.dart';
import 'package:uplift/authentication/presentation/pages/introduction/presentation/introduction_screen.dart';
import 'package:uplift/utils/services/start_up_services.dart';
import '../../../authentication/presentation/bloc/authentication/authentication_bloc.dart';

import 'splash_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
final StartUpServices startUpServices = StartUpServices();

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    startUpServices.initialize(flutterLocalNotificationsPlugin, context);
    startUpServices.firebaseBackgroundNotif(context);
    startUpServices.initializeDynamicLinks(context);
    super.initState();
  }

  int index = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Ensure the state is kept alive
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) async {
        startUpServices.userStatus(
            state,
            context,
            () => setState(() {
                  index = 0;
                }));
      },
      builder: (context, state) {
        if (state is UserIsIn) {
          final UserJoinedModel userJoinedModel = state.userJoinedModel;
          return UpliftMainScreen(userJoinedModel: userJoinedModel);
        } else if (state is UserIsOut) {
          return const IntroductionScreen();
        } else if (state is Loading) {
          return const SplashScreen();
        } else {
          return const Text('Error');
        }
      },
    );
  }

  void onChangedTab(int value) {
    setState(() {
      index = value;
    });
  }
}
