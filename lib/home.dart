import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/default_text.dart';

import 'authentication/presentation/bloc/authentication/authentication_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});
  final User user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final User user = widget.user;
    return Scaffold(
        appBar: AppBar(
          title: const Image(
            image: AssetImage('assets/uplift-logo.png'),
            width: 80,
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.search,
                size: 30,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20, left: 10),
              child: Icon(
                Icons.notifications,
                size: 30,
              ),
            )
          ],
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.photoURL!),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    decoration: BoxDecoration(
                        color: const Color(0xffF6F6F6),
                        border:
                            Border.all(color: secondaryColor.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(60)),
                    child: const DefaultText(
                        text: 'What would you like us to pray for?',
                        color: secondaryColor),
                  )),
                  const SizedBox(width: 5),
                  const Image(
                    image: AssetImage('assets/gallery.png'),
                    width: 30,
                  )
                ],
              ),
            )
          ],
        ));
  }

  void signOut() {
    BlocProvider.of<AuthenticationBloc>(context).add(SignOutRequested());
  }
}
