import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rope/core/enums/tweet_type_enums.dart';
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
    final dt = DateTime.fromMillisecondsSinceEpoch(tweet['datePublished']);
    List<String> imageLinks = List<String>.from(tweet["imageLinks"]);
    final String link = tweet['link'];
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: CircleAvatar(
                backgroundImage: NetworkImage(tweet["senderPhotoUrl"]),
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
                          tweet["senderName"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          ' @${tweet["senderName"]} ${timeago.format(
                            dt,
                          )}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  HashtagText(text: tweet["text"]),
                  if (tweet["tweetType"] == "image")
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
                          text: (tweet['commentIds'].length +
                                  tweet['reshareCount'] +
                                  tweet['likes'].length)
                              .toString(),
                          onTap: () {},
                        ),
                        TweetIconButton(
                          pathName: "assets/svgs/comment.svg",
                          text: tweet['commentIds'].length.toString(),
                          onTap: () {},
                        ),
                        TweetIconButton(
                          pathName: "assets/svgs/retweet.svg",
                          text: tweet['reshareCount'].toString(),
                          onTap: () {},
                        ),
                        TweetIconButton(
                          pathName: "assets/svgs/like_outlined.svg",
                          text: tweet['likes'].length.toString(),
                          onTap: () {},
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
