import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rope/features/tweet/repository/tweet_repository.dart';
import 'package:rope/models/tweet_model.dart';

final userProfileControllerProvider = StateNotifierProvider((ref) {
  return UserProfileController(tweetRepository: ref.watch(tweetProvider));
});

final getUserTweetProvider =
    StreamProvider.family<List<TweetModel>, String>((ref, uid) {
  final doc = ref.watch(tweetProvider);
  return doc.getUserTweets(uid);
});

class UserProfileController extends StateNotifier<bool> {
  final TweetRepository _tweetRepository;
  UserProfileController({
    required TweetRepository tweetRepository,
  })  : _tweetRepository = tweetRepository,
        super(false);
}
