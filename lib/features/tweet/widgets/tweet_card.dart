import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:rope/core/common/loading_page.dart';
import 'package:rope/core/enums/tweet_type_enums.dart';
import 'package:rope/features/auth/controller/auth_controller.dart';
import 'package:rope/features/tweet/controller/tweet_controller.dart';
import 'package:rope/features/tweet/widgets/carousel_image.dart';
import 'package:rope/features/tweet/widgets/hashtags_text.dart';
import 'package:rope/features/tweet/widgets/tweet_icon_button.dart';
import 'package:rope/theme/pallete.dart';
import 'package:timeago/timeago.dart' as timeago;

class TweetCard extends ConsumerWidget {
  final tweet;
  const TweetCard({super.key, required this.tweet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final dt = DateTime.fromMillisecondsSinceEpoch(tweet.datePublished);
    List<String> imageLinks = List<String>.from(tweet.imageLinks);
    final String link = tweet.link;

    final currentUser = ref.watch(getCurrentUserDataProvider).value;
    return currentUser == null
        ? const Loader()
        : Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(tweet.senderPhotoUrl),
                      radius: 35,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              // margin: const EdgeInsets.all(5),
                              child: Text(
                                tweet.senderName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                ' @${tweet.senderName} ${timeago.format(
                                  tweet.datePublished,
                                )}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        HashtagText(text: tweet.text),
                        if (tweet.tweetType == TweetType.image)
                          CarouselImage(imageLinks: imageLinks),
                        if (link.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          AnyLinkPreview(
                            link: 'https://${link}',
                            displayDirection: UIDirection.uiDirectionVertical,
                          ),
                        ],
                        Container(
                          margin: const EdgeInsets.only(top: 8, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TweetIconButton(
                                pathName: "assets/svgs/views.svg",
                                text: (tweet.commentIds.length +
                                        tweet.reshareCount +
                                        tweet.likes.length)
                                    .toString(),
                                onTap: () {},
                              ),
                              TweetIconButton(
                                pathName: "assets/svgs/comment.svg",
                                text: tweet.commentIds.length.toString(),
                                onTap: () {},
                              ),
                              TweetIconButton(
                                pathName: "assets/svgs/retweet.svg",
                                text: tweet.reshareCount.toString(),
                                onTap: () {},
                              ),
                              LikeButton(
                                onTap: (isLiked) async {
                                  ref
                                      .read(tweetControllerProvider.notifier)
                                      .likeTweet(tweet, currentUser);
                                  return !isLiked;
                                },
                                size: 25,
                                isLiked: tweet.likes.contains(currentUser.uid),
                                likeBuilder: (isLiked) {
                                  return isLiked
                                      ? SvgPicture.asset(
                                          "assets/svgs/like_filled.svg",
                                          color: Pallete.redColor,
                                        )
                                      : SvgPicture.asset(
                                          "assets/svgs/like_outlined.svg",
                                          color: Pallete.greyColor,
                                        );
                                },
                                likeCount: tweet.likes.length,
                                countBuilder: (likeCount, isLiked, text) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 2.0),
                                    child: Text(
                                      text,
                                      style: TextStyle(
                                        color: isLiked
                                            ? Pallete.redColor
                                            : Pallete.whiteColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.share_outlined,
                                  color: Pallete.greyColor,
                                ),
                              ),
                              const SizedBox(height: 1),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(color: Pallete.greyColor),
            ],
          );
  }
}
