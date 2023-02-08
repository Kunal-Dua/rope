import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rope/core/common/loading_page.dart';
import 'package:rope/core/constants/constants.dart';
import 'package:rope/features/auth/controller/auth_controller.dart';
import 'package:rope/features/user_profile/controller/user_profile_controller.dart';
import 'package:rope/features/user_profile/screens/user_profile_screen.dart';
import 'package:rope/theme/pallete.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(getCurrentUserDataProvider).value;

    if (currentUser == null) {
      const Loader();
    }

    return SafeArea(
      child: Drawer(
        backgroundColor: Pallete.backgroundColor,
        child: Column(children: [
          ListTile(
            leading: const Icon(
              Icons.person,
              size: 30,
            ),
            title: const Text(
              "My profile",
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      UserProfileScreen(userModel: currentUser!),
                ),
              );
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              Constants.svgVerifiedIcon,
              width: 30,
              height: 30,
            ),
            title: const Text(
              "Get Verified",
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            onTap: () {
              ref
                  .watch(userProfileControllerProvider.notifier)
                  .updateUserProfile(
                    context: context,
                    userModel: currentUser!,
                    bannerImg: null,
                    profileImg: null,
                    name: "",
                    bio: "",
                    verified: true,
                  );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              size: 30,
            ),
            title: const Text(
              "Logout",
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            onTap: () {},
          ),
        ]),
      ),
    );
  }
}
