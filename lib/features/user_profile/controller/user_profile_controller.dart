import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rope/core/utils.dart';
import 'package:rope/core/providers/storage_repository.dart';
import 'package:rope/features/auth/repository/auth_repository.dart';
import 'package:rope/features/tweet/repository/tweet_repository.dart';
import 'package:rope/models/tweet_model.dart';
import 'package:rope/models/user_model.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
    tweetRepository: ref.watch(tweetProvider),
    storageRepository: ref.watch(storageRepositoryProvider),
    authRepository: ref.watch(authRepositoryProvider),
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
  final TweetRepository _tweetRepository;
  final StorageRepository _storageRepository;
  final AuthRepository _authRepository;

  UserProfileController({
    required TweetRepository tweetRepository,
    required StorageRepository storageRepository,
    required AuthRepository authRepository,
  })  : _tweetRepository = tweetRepository,
        _storageRepository = storageRepository,
        _authRepository = authRepository,
        super(false);

  void updateUserProfile({
    required BuildContext context,
    required UserModel userModel,
    required File? bannerImg,
    required File? profileImg,
    required String name,
    required String bio,
  }) async {
    state = true;
    if (bannerImg != null) {
      final bannerUrl = await _storageRepository.uploadImage(
          images: ([bannerImg]), uid: userModel.uid);

      final res = await _authRepository.updateUserBannerPic(
          userModel: userModel, bannerPic: bannerUrl[0]);

      res.fold((l) => showSnackBar(context, l.message), (r) => null);
    }

    if (profileImg != null) {
      final profileUrl = await _storageRepository.uploadImage(
          images: ([profileImg]), uid: userModel.uid);

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
  }
}
