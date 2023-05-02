import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import '../../../../../constant/constant.dart';
import '../../../../../utils/widgets/header_text.dart';
import 'event_item.dart';
import 'event_list.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const HeaderText(text: 'Events', color: secondaryColor),
        actions: [
          IconButton(
            icon: const Icon(Ionicons.search),
            onPressed: () {},
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        children: [
          const SmallText(text: "Today's March 24th", color: lightColor),
          const HeaderText(text: 'Nearby event', color: secondaryColor),
          defaultSpace,
          SizedBox(
            height: 150,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 20,
                itemBuilder: (context, index) {
                  return const EventItem();
                }),
          ),
          const SizedBox(height: 30),
          const HeaderText(text: 'Upcoming Event', color: secondaryColor),
          const SizedBox(height: 5),
          const EventList()
        ],
      ),
    );
  }
}
