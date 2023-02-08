import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rope/core/constants/constants.dart';
import 'package:rope/core/enums/notification_type_enums%20copy.dart';
import 'package:rope/models/notification_model.dart';
import 'package:rope/theme/pallete.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: notification.notificationType == NotificationType.follow
          ? const Icon(
              Icons.person,
              color: Pallete.blueColor,
            )
          : notification.notificationType == NotificationType.like
              ? SvgPicture.asset(
                  Constants.svgLikeFilled,
                  color: Pallete.redColor,
                  height: 20,
                )
              : notification.notificationType == NotificationType.retweet
                  ? SvgPicture.asset(
                      Constants.svgRetweetIcon,
                      color: Pallete.whiteColor,
                      height: 20,
                    )
                  : null,
      title: Text(notification.text),
    );
  }
}
