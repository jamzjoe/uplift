import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import '../../../../constant/constant.dart';
import '../../../../utils/widgets/header_text.dart';

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
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Column(
              children: const [
                HeaderText(text: 'Upcoming Event', color: secondaryColor)
              ],
            ),
            const SizedBox(height: 5),
            Expanded(child: ListView.builder(
              itemBuilder: (context, index) {
                return const UpcomingEventItem();
              },
            ))
          ],
        ),
      ),
    );
  }
}

class UpcomingEventItem extends StatelessWidget {
  const UpcomingEventItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      height: 80,
      child: Row(
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.cover)),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      DefaultText(
                          text: 'Museum Week Fest', color: secondaryColor),
                      SmallText(text: 'By James Cameron', color: lightColor),
                    ],
                  ),
                  const SmallText(
                      text: 'May 21, 09:00 pm  OnSite', color: lightColor)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class EventItem extends StatelessWidget {
  const EventItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 250,
      height: 150,
      decoration: BoxDecoration(
          image: const DecorationImage(
              image: AssetImage('assets/background.png'),
              colorFilter: ColorFilter.mode(Colors.black, BlendMode.screen),
              fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                decoration: BoxDecoration(
                    color: whiteColor, borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Ionicons.flag, size: 15),
                    SizedBox(width: 5),
                    SmallText(
                        text: 'San Isidro Labrador', color: secondaryColor),
                  ],
                ),
              ),
            ],
          ),
          const CustomButton(
              width: double.infinity,
              widget: Center(
                  child: DefaultText(text: 'Join Event', color: whiteColor)),
              color: linkColor)
        ],
      ),
    );
  }
}
