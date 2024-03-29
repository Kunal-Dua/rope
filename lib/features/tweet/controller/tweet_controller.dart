// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rope/core/enums/notification_type_enums%20copy.dart';
import 'package:rope/core/enums/tweet_type_enums.dart';
import 'package:rope/core/providers/storage_repository.dart';
import 'package:rope/core/utils.dart';
import 'package:rope/features/auth/controller/auth_controller.dart';
import 'package:rope/features/notification/controller/notification_controller.dart';
import 'package:rope/features/tweet/repository/tweet_repository.dart';
import 'package:rope/models/tweet_model.dart';
import 'package:rope/models/user_model.dart';
import 'package:uuid/uuid.dart';

final tweetControllerProvider =
    StateNotifierProvider<TweetController, bool>((ref) {
  // ignore: unused_local_variable
  final tweetRepository = ref.watch(tweetProvider);

  return TweetController(
    ref: ref,
    tweetRepository: ref.watch(tweetProvider),
    storageRepository: ref.watch(storageRepositoryProvider),
    notificationController: ref.watch(notificationControllerProvider.notifier),
  );
});

final getTweetsProvider = FutureProvider((ref) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweets();
});

final getUpdatedTweetsProvider =
    StreamProvider.autoDispose<List<TweetModel>>((ref) {
  final tweet = ref.watch(tweetProvider);
  return tweet.getUpdatedTweet();
});

final getRepliedTweets = StreamProvider.family
    .autoDispose<List<TweetModel>, TweetModel>((ref, tweet) {
  final doc = ref.watch(tweetProvider);
  return doc.getRepliesFromTweet(tweet);
});

final getTweetByIdProvider = FutureProvider.family((ref, String id) {
  final doc = ref.watch(tweetProvider);
  return doc.getTweetById(id);
});

final getTweetFromHashtag =
    StreamProvider.family<List<TweetModel>, String>((ref, hashtag) {
  final tweet = ref.watch(tweetProvider);
  return tweet.getTweetByHashtag(hashtag);
});

class TweetController extends StateNotifier<bool> {
  final Ref _ref;
  final StorageRepository _storageRepository;
  final TweetRepository _tweetRepository;
  final NotificationController _notificationController;

  TweetController({
    required Ref ref,
    required StorageRepository storageRepository,
    required TweetRepository tweetRepository,
    required NotificationController notificationController,
  })  : _ref = ref,
        _storageRepository = storageRepository,
        _tweetRepository = tweetRepository,
        _notificationController = notificationController,
        super(false);

  Future<List<TweetModel>> getTweets() async {
    final tweetList = await _tweetRepository.getTweets();
    return tweetList;
  }

  void likeTweet(TweetModel tweet, UserModel user) async {
    List<String> likes = tweet.likes;
    if (likes.contains(user.uid)) {
      likes.remove(user.uid);
    } else {
      likes.add(user.uid);
    }
    tweet = tweet.copyWith(likes: likes);
    final res = await _tweetRepository.likeTweet(tweet);
    res.fold((l) => null, (r) {
      _notificationController.createNotification(
        text: tweet.uid == user.uid
            ? 'you liked your tweet'
            : '${user.name} liked your tweet',
        postId: tweet.id,
        uid: tweet.uid,
        notificationType: NotificationType.like,
      );
    });
  }

  void updateCommentIdsAfterReply(
      {required TweetModel tweet, required String commentId}) async {
    try {
      List<String> commentIds = tweet.commentIds;
      commentIds.add(commentId);

      tweet = tweet.copyWith(commentIds: commentIds);
      await _tweetRepository.updateCommentIdsOfRepliedTweet(tweet);
    } catch (e) {
      print(e.toString());
    }
  }

  void reshareTweet(
    TweetModel tweet,
    UserModel currentUser,
    BuildContext context,
  ) async {
    try {
      tweet = tweet.copyWith(
        reshareCount: tweet.reshareCount + 1,
      );
      final res = await _tweetRepository.updateReshareCount(tweet);
      res.fold((l) => showSnackBar(context, l.message), (r) async {
        String newId = const Uuid().v1();
        tweet = tweet.copyWith(
          id: newId,
          likes: [],
          commentIds: [],
          retweetedBy: currentUser.name,
          reshareCount: 0,
          datePublished: DateTime.now(),
        );

        final res2 = await _tweetRepository.shareTweet(tweet);
        res2.fold((l) => showSnackBar(context, l.message), (r) {
          _notificationController.createNotification(
            text: tweet.uid == currentUser.uid
                ? 'you reshared your tweet'
                : '${currentUser.name} reshared your tweet',
            postId: tweet.id,
            uid: tweet.uid,
            notificationType: NotificationType.retweet,
          );
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void shareTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repiledToUserId,
    String? tweetID,
  }) {
    if (text.isEmpty) {
      showSnackBar(context, "Enter text");
      return;
    }
    if (images.isNotEmpty) {
      _shareImageTweet(
        images: images,
        text: text,
        context: context,
        repliedTo: repliedTo,
        repiledToUserId: repiledToUserId,
      );
    } else {
      _shareTextTweet(
        text: text,
        context: context,
        repliedTo: repliedTo,
        tweetID: tweetID,
        repiledToUserId: repiledToUserId,
      );
    }
  }

  void _shareImageTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repiledToUserId,
  }) async {
    state = true;
    String link = _getLinkFromText(text);
    final hashtags = _getHashtagFromText(text);
    final user = _ref.read(userProvider)!;

    final imageLinks = await _storageRepository.uploadImage(images: images);
    String newId = const Uuid().v1();
    TweetModel tweet = TweetModel(
      uid: user.uid,
      text: text,
      link: link,
      hashtags: hashtags,
      imageLinks: imageLinks,
      tweetType: TweetType.image,
      datePublished: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: newId,
      reshareCount: 0,
      retweetedBy: '',
      repliedTo: repliedTo,
    );

    final res = await _tweetRepository.shareTweet(tweet);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (repiledToUserId.isNotEmpty) {
        _notificationController.createNotification(
          text: tweet.uid == user.uid
              ? 'you replied to your tweet ${text}'
              : '${user.name} replied your tweet ${text}',
          postId: tweet.id,
          uid: tweet.uid,
          notificationType: NotificationType.reply,
        );
      }
    });
  }

  void _shareTextTweet({
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repiledToUserId,
    String? tweetID,
  }) async {
    state = true;
    final hashtags = _getHashtagFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(userProvider)!;
    if (tweetID != null) {
    } else {
      tweetID = const Uuid().v1();
    }
    TweetModel tweet = TweetModel(
      uid: user.uid,
      text: text,
      link: link,
      hashtags: hashtags,
      imageLinks: const [],
      tweetType: TweetType.text,
      datePublished: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: tweetID,
      reshareCount: 0,
      retweetedBy: '',
      repliedTo: repliedTo,
    );

    final res = await _tweetRepository.shareTweet(tweet);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (repiledToUserId.isNotEmpty) {
        _notificationController.createNotification(
          text: tweet.uid == user.uid
              ? 'you replied to your tweet ${text}'
              : '${user.name} replied your tweet ${text}',
          postId: tweet.id,
          uid: tweet.uid,
          notificationType: NotificationType.reply,
        );
      }
    });
  }

  String _getLinkFromText(String text) {
    String link = "";
    List<String> wordsInSentence = text.split(" ");
    for (String word in wordsInSentence) {
      if (word.startsWith("https://") || word.startsWith("www.")) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashtagFromText(String text) {
    List<String> hashtags = [];
    List<String> wordsInSentence = text.split(" ");
    for (String word in wordsInSentence) {
      if (word.startsWith("#")) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }
}
