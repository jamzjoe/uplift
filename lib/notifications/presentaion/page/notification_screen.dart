import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const HeaderText(text: 'Notifications', color: secondaryColor),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Ionicons.search),
          )
        ],
      ),
      body: ListView.builder(
          itemBuilder: (context, index) => const NotificationItem()),
    );
  }
}

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25,
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              DefaultText(
                  text: 'John Doe post a prayer request.',
                  color: secondaryColor),
              SmallText(text: '12 minutes ago', color: lightColor)
            ],
          )
        ],
      ),
    );
  }
}
