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

  FutureEither<DocumentReference> shareTweet(TweetModel tweet) async {
    try {
      final document = await _firestore.collection("tweets").add(tweet.toMap());
      return right(document);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<List> getTweets() async {
    var document = await _firestore.collection("tweets").get();
    return document.docs.map((doc) => doc.data()).toList();
  }
}
