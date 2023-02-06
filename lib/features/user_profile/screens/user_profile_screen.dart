import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rope/features/user_profile/widgets/user_profile.dart';

class UserProfileScreen extends ConsumerWidget {
  final user;
  const UserProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: UserProfile(user: user),
    );
  }
}
