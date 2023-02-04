import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:rope/core/failure.dart';
import 'package:rope/core/providers/firebase_provider.dart';
import 'package:rope/core/type_def.dart';
import 'package:rope/models/tweet_model.dart';

final tweetProvider = Provider((ref) {
  return TweetRepository(
    firestore: ref.watch(firebaseProvider),
  );
});

class TweetRepository {
  final FirebaseFirestore _firestore;
  TweetRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  FutureEither<void> shareTweet(TweetModel tweet) async {
    try {
      final document = await _firestore
          .collection("tweets")
          .doc(tweet.id)
          .set(tweet.toMap());
      return right(document);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<List<TweetModel>> getTweets() async {
    final document = await _firestore.collection("tweets").get();
    return document.docs.map((doc) => TweetModel.fromMap(doc.data())).toList();
  }

  Stream<List<TweetModel>> getUpdatedTweet() {
    return _firestore
        .collection("tweets")
        .orderBy("datePublished", descending: true)
        .snapshots()
        .map((event) {
      List<TweetModel> doc = [];
      for (var document in event.docs) {
        doc.add(TweetModel.fromMap(document.data()));
      }
      return doc;
    });
  }

  Future likeTweet(TweetModel tweet) async {
    try {
      final document = _firestore.collection("tweets").doc(tweet.id).update({
        "likes": tweet.likes,
      });
    } catch (e) {
      return print(e.toString());
    }
  }
}
