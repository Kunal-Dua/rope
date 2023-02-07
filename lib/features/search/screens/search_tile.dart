import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rope/features/user_profile/screens/user_profile_screen.dart';
import 'package:rope/models/user_model.dart';
import 'package:rope/theme/pallete.dart';

class SearchTile extends ConsumerWidget {
  final UserModel user;
  const SearchTile({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserProfileScreen(userModel: user)),
        );
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.profileUrl),
        radius: 30,
      ),
      title: Text(
        user.name,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '@${user.name}',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            user.bio,
            style: const TextStyle(
              // fontSize: 16,
              color: Pallete.whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
