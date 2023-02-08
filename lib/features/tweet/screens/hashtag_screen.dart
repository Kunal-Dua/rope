import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rope/core/common/error_page.dart';
import 'package:rope/core/common/loading_page.dart';
import 'package:rope/features/tweet/controller/tweet_controller.dart';
import 'package:rope/features/tweet/widgets/tweet_card.dart';

class HashtagScreen extends ConsumerWidget {
  final String hashtag;
  const HashtagScreen({super.key, required this.hashtag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hashtag),
      ),
      body: ref.watch(getTweetFromHashtag(hashtag)).when(
            data: (tweets) {
              return ListView.builder(
                itemCount: tweets.length,
                itemBuilder: (BuildContext context, int index) {
                  final tweet = tweets[index];
                  return TweetCard(tweet: tweet);
                },
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: (() => const Loader()),
          ),
    );
  }
}
