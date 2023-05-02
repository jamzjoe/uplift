import 'package:flutter/material.dart';

import 'upcoming_event_item.dart';

class EventList extends StatelessWidget {
  const EventList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        children: const [
          UpcomingEventItem(),
          UpcomingEventItem(),
          UpcomingEventItem(),
          UpcomingEventItem(),
          UpcomingEventItem(),
          UpcomingEventItem(),
          UpcomingEventItem(),
          UpcomingEventItem()
        ],
      ),
    );
  }
}
