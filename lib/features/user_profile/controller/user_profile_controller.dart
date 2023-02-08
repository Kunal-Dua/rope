import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rope/core/enums/notification_type_enums%20copy.dart';
import 'package:rope/core/utils.dart';
import 'package:rope/core/providers/storage_repository.dart';
import 'package:rope/features/auth/repository/auth_repository.dart';
import 'package:rope/features/notification/controller/notification_controller.dart';
import 'package:rope/features/tweet/repository/tweet_repository.dart';
import 'package:rope/models/tweet_model.dart';
import 'package:rope/models/user_model.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
    tweetRepository: ref.watch(tweetProvider),
    storageRepository: ref.watch(storageRepositoryProvider),
    authRepository: ref.watch(authRepositoryProvider),
    notificationController: ref.watch(notificationControllerProvider.notifier),
  );
});

final getUserTweetProvider =
    StreamProvider.family<List<TweetModel>, String>((ref, uid) {
  final doc = ref.watch(tweetProvider);
  return doc.getUserTweets(uid);
});

final getUpdatedUserProvider =
    StreamProvider.family<UserModel, String>((ref, uid) {
  final doc = ref.watch(authRepositoryProvider);
  return doc.getUpdatedUserProfileData(uid);
});

class UserProfileController extends StateNotifier<bool> {
  // ignore: unused_field
  final TweetRepository _tweetRepository;
  final StorageRepository _storageRepository;
  final AuthRepository _authRepository;
  final NotificationController _notificationController;

  UserProfileController({
    required TweetRepository tweetRepository,
    required StorageRepository storageRepository,
    required AuthRepository authRepository,
    required NotificationController notificationController,
  })  : _tweetRepository = tweetRepository,
        _storageRepository = storageRepository,
        _authRepository = authRepository,
        _notificationController = notificationController,
        super(false);

  void updateUserProfile({
    required BuildContext context,
    required UserModel userModel,
    required File? bannerImg,
    required File? profileImg,
    required String name,
    required String bio,
    bool? verified,
  }) async {
    state = true;
    if (bannerImg != null) {
      final bannerUrl =
          await _storageRepository.uploadImage(images: ([bannerImg]));

      final res = await _authRepository.updateUserBannerPic(
          userModel: userModel, bannerPic: bannerUrl[0]);

      res.fold((l) => showSnackBar(context, l.message), (r) => null);
    }

    if (profileImg != null) {
      final profileUrl =
          await _storageRepository.uploadImage(images: ([profileImg]));

      final res = await _authRepository.updateUserProfilePic(
          userModel: userModel, profileUrl: profileUrl[0]);

      state = false;
      res.fold((l) => showSnackBar(context, l.message), (r) => null);
    }

    if (name.isNotEmpty) {
      final res = await _authRepository.updateUserProfileName(
          userModel: userModel, name: name);

      state = false;

      res.fold((l) => showSnackBar(context, l.message), (r) => null);
    }

    if (bio.isNotEmpty) {
      final res = await _authRepository.updateUserProfileBio(
          userModel: userModel, bio: bio);
      state = false;
      res.fold((l) => showSnackBar(context, l.message), (r) => null);
    }

    if (verified!) {
      final res = await _authRepository.updateUserToVerified(
          userModel: userModel, verified: verified);
      state = false;
      res.fold((l) => showSnackBar(context, l.message),
          (r) => showSnackBar(context, "User verified"));
    }
  }

  void followUser({
    required BuildContext context,
    required UserModel user,
    required UserModel currentUser,
  }) async {
    if (currentUser.following.contains(user.uid)) {
      user.followers.remove(currentUser.uid);
      currentUser.following.remove(user.uid);
    } else {
      user.followers.add(currentUser.uid);
      currentUser.following.add(user.uid);
    }

    user = user.copyWith(followers: user.followers);
    currentUser = currentUser.copyWith(following: currentUser.following);

    final res = await _authRepository.addToFollowers(user: user);
    res.fold((l) => showSnackBar(context, l.message), (r) async {
      final res2 = await _authRepository.addToFollowing(user: currentUser);
      res2.fold((l) => showSnackBar(context, l.message), (r) {
        _notificationController.createNotification(
          text: '${user.name} followed you',
          postId: '',
          uid: user.uid,
          notificationType: NotificationType.follow,
        );
      });
    });
  }
}
