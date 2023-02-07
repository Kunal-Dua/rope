import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rope/core/common/error_page.dart';
import 'package:rope/core/common/loading_page.dart';
import 'package:rope/features/tweet/controller/tweet_controller.dart';
import 'package:rope/features/tweet/widgets/tweet_card.dart';
import 'package:rope/models/tweet_model.dart';
import 'package:uuid/uuid.dart';

class ReplyScreen extends ConsumerWidget {
  final TweetModel tweet;
  const ReplyScreen({super.key, required this.tweet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rope")),
      body: Column(
        children: [
          TweetCard(tweet: tweet),
          ref.watch(getRepliedTweets(tweet)).when(
                data: (tweets) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (BuildContext context, int index) {
                        final tweet = tweets[index];
                        return TweetCard(tweet: tweet);
                      },
                    ),
                  );
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: (() => const Loader()),
              )
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        child: TextField(
          onSubmitted: (value) {
            final tweetID = const Uuid().v1();
            ref.read(tweetControllerProvider.notifier).shareTweet(
              images: [],
              text: value,
              context: context,
              repliedTo: tweet.id,
              tweetID: tweetID,
            );

            ref
                .read(tweetControllerProvider.notifier)
                .updateCommentIdsAfterReply(tweet: tweet, commentId: tweetID);

            value = '';
          },
          decoration: const InputDecoration(
            hintText: "Enter your reply",
            border: InputBorder.none,
          ),
          autofocus: true,
        ),
      ),
    );
  }
}
