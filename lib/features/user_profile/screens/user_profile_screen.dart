import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rope/core/common/error_page.dart';
import 'package:rope/core/common/loading_page.dart';
import 'package:rope/features/user_profile/controller/user_profile_controller.dart';
import 'package:rope/features/user_profile/widgets/user_profile.dart';
import 'package:rope/models/user_model.dart';

class UserProfileScreen extends ConsumerWidget {
  final UserModel userModel;
  const UserProfileScreen({super.key, required this.userModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(getUpdatedUserProvider(userModel.uid)).when(
            data: (data) {
              return UserProfile(user: data);
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: (() => const Loader()),
          ),
    );
  }
}
