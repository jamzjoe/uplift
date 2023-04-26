import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uplift/authentication/domain/repository/auth_repository.dart';
import 'package:uplift/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/post_screen/presentation/bloc/post_prayer_request/post_prayer_request_bloc.dart';
import 'package:uplift/utils/router/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(AuthRepository()),
        ),
        BlocProvider<PostPrayerRequestBloc>(
            create: (context) => PostPrayerRequestBloc()),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        title: 'Uplift Development',
        theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(primaryColor))),
          appBarTheme: const AppBarTheme(surfaceTintColor: whiteColor),
          bottomSheetTheme: const BottomSheetThemeData(
              surfaceTintColor: whiteColor,
              elevation: 2,
              shape: RoundedRectangleBorder()),
          dividerTheme:
              DividerThemeData(color: secondaryColor.withOpacity(0.2)),
          floatingActionButtonTheme:
              const FloatingActionButtonThemeData(backgroundColor: whiteColor),
          bottomAppBarTheme:
              const BottomAppBarTheme(surfaceTintColor: whiteColor),
          colorSchemeSeed: Colors.lightBlue,
          useMaterial3: true,
        ),
      ),
    );
  }
}
