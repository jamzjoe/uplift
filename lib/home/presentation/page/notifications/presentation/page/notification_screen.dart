import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/notifications/presentation/bloc/notification_bloc/notification_bloc.dart';
import 'package:uplift/home/presentation/page/notifications/presentation/page/notification_shimmer.dart';
import 'package:uplift/utils/services/auth_services.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/no_data_text.dart';

import 'notification_item.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key, required this.currentUser});
  final UserModel currentUser;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const HeaderText(text: 'Notifications', color: darkColor),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  onTap: () => markAllAsRead(widget.currentUser.userId!),
                  child: TextButton.icon(
                      label: const DefaultText(
                          text: 'Mark all as read', color: secondaryColor),
                      onPressed: null,
                      icon: const Icon(
                        Icons.mark_email_read,
                        color: primaryColor,
                      )),
                ),
                PopupMenuItem(
                  onTap: () => deleteAll(widget.currentUser.userId!),
                  child: TextButton.icon(
                      label: const DefaultText(
                          text: 'Delete all', color: secondaryColor),
                      onPressed: null,
                      icon: const Icon(
                        Icons.remove_circle,
                        color: primaryColor,
                      )),
                ),
              ];
            },
          )
        ],
      ),
      body: BlocConsumer<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is NotificationLoadingSuccess) {}
        },
        builder: (context, state) {
          if (state is NotificationLoading) {
            return ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: 15,
                itemBuilder: (context, index) {
                  return const NotificationShimmer();
                });
          }
          if (state is NotificationLoadingSuccess) {
            final data = state.notifications;
            if (data.isEmpty) {
              return const Center(
                  child: NoDataMessage(text: 'No notifications yet!'));
            }
            return RefreshIndicator(
              onRefresh: () async {
                final String userID = await AuthServices.userID();
                if (context.mounted) {
                  BlocProvider.of<NotificationBloc>(context)
                      .add(RefreshListOfNotification(userID, false));
                }
              },
              child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider(
                      thickness: 0.5,
                      color: secondaryColor.withOpacity(0.2),
                    );
                  },
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.notifications.length,
                  itemBuilder: (context, index) => NotificationItem(
                        notificationModel: data[index],
                        currentUser: widget.currentUser,
                      )),
            );
          }
          return ListView.builder(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: 15,
              itemBuilder: (context, index) {
                return const NotificationShimmer();
              });
        },
      ),
    );
  }

  void markAllAsRead(String userID) async {
    log("Tap");
    BlocProvider.of<NotificationBloc>(context).add(MarkAllAsRead(userID));
  }

  void deleteAll(String userID) async {
    BlocProvider.of<NotificationBloc>(context).add(ClearNotification(userID));
  }
}
