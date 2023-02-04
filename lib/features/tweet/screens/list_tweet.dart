import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rope/core/common/error_page.dart';
import 'package:rope/core/common/loading_page.dart';
import 'package:rope/features/tweet/controller/tweet_controller.dart';
import 'package:rope/features/tweet/widgets/tweet_card.dart';

class ListTweet extends ConsumerWidget {
  const ListTweet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetsProvider).when(
          data: (tweets) {
            return ref.watch(getUpdatedTweetsProvider).when(
                  data: (data) {
                    return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (BuildContext context, int index) {
                        final tweet = data[index];
                        return TweetCard(tweet: tweet);
                      },
                    );
                  },
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: (() => const Loader()),
                  // );
                  // return ListView.builder(
                  //   itemCount: tweets.length,
                  //   itemBuilder: (BuildContext context, int index) {
                  //     final tweet = tweets[index];
                  //     return TweetCard(tweet: tweet);
                  //   },
                );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: (() => const Loader()),
        );
  }
}
