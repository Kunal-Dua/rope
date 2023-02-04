import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rope/core/enums/tweet_type_enums.dart';
import 'package:rope/core/providers/storage_repository.dart';
import 'package:rope/core/utils.dart';
import 'package:rope/features/auth/controller/auth_controller.dart';
import 'package:rope/features/tweet/repository/tweet_repository.dart';
import 'package:rope/models/tweet_model.dart';

final tweetControllerProvider =
    StateNotifierProvider<TweetController, bool>((ref) {
  return TweetController(
    ref: ref,
    tweetRepository: ref.watch(tweetProvider),
    storageRepository: ref.watch(storageRepositoryProvider),
  );
});

final getTweetsProvider = FutureProvider((ref) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweets();
});

final getUpdatedTweetsProvider = StreamProvider((ref) {
  final tweet = ref.watch(tweetProvider);
  return tweet.getUpdatedTweet();
});

class TweetController extends StateNotifier<bool> {
  final Ref _ref;
  final StorageRepository _storageRepository;
  final TweetRepository _tweetRepository;

  TweetController({
    required Ref ref,
    required StorageRepository storageRepository,
    required TweetRepository tweetRepository,
  })  : _ref = ref,
        _storageRepository = storageRepository,
        _tweetRepository = tweetRepository,
        super(false);

  Future<List> getTweets() async {
    final tweetList = await _tweetRepository.getTweets();
    return tweetList;
  }

  void shareTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) {
    if (text.isEmpty) {
      showSnackBar(context, "Enter text");
      return;
    }
    if (images.isNotEmpty) {
      _shareImageTweet(images: images, text: text, context: context);
    } else {
      _shareTextTweet(text: text, context: context);
    }
  }

  void _shareImageTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) async {
    state = true;
    String link = _getLinkFromText(text);
    final hashtags = _getHashtagFromText(text);
    final user = _ref.read(userProvider)!;

    final imageLinks =
        await _storageRepository.uploadImage(images: images, uid: user.uid);

    TweetModel tweet = TweetModel(
        uid: user.uid,
        senderPhotoUrl: user.profileUrl,
        senderName: user.name,
        text: text,
        link: link,
        hashtags: hashtags,
        imageLinks: imageLinks,
        tweetType: TweetType.image,
        datePublished: DateTime.now(),
        likes: [],
        commentIds: [],
        Id: '',
        reshareCount: 0);

    final res = await _tweetRepository.shareTweet(tweet);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  void _shareTextTweet({
    required String text,
    required BuildContext context,
  }) async {
    state = true;
    final hashtags = _getHashtagFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(userProvider)!;
    TweetModel tweet = TweetModel(
        uid: user.uid,
        senderPhotoUrl: user.profileUrl,
        senderName: user.name,
        text: text,
        link: link,
        hashtags: hashtags,
        imageLinks: [],
        tweetType: TweetType.text,
        datePublished: DateTime.now(),
        likes: [],
        commentIds: [],
        Id: '',
        reshareCount: 0);

    final res = await _tweetRepository.shareTweet(tweet);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
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
