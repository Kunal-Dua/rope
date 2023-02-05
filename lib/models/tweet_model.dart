// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:rope/core/enums/tweet_type_enums.dart';

class TweetModel {
  final String uid;
  final String text;
  final String link;
  final List<String> hashtags;
  final List<String> imageLinks;
  final TweetType tweetType;
  final DateTime datePublished;
  final List<String> likes;
  final List<String> commentIds;
  final String id;
  final int reshareCount;
  final String retweetedBy;
  TweetModel({
    required this.uid,
    required this.text,
    required this.link,
    required this.hashtags,
    required this.imageLinks,
    required this.tweetType,
    required this.datePublished,
    required this.likes,
    required this.commentIds,
    required this.id,
    required this.reshareCount,
    required this.retweetedBy,
  });

  TweetModel copyWith({
    String? uid,
    String? text,
    String? link,
    List<String>? hashtags,
    List<String>? imageLinks,
    TweetType? tweetType,
    DateTime? datePublished,
    List<String>? likes,
    List<String>? commentIds,
    String? id,
    int? reshareCount,
    String? retweetedBy,
  }) {
    return TweetModel(
      uid: uid ?? this.uid,
      text: text ?? this.text,
      link: link ?? this.link,
      hashtags: hashtags ?? this.hashtags,
      imageLinks: imageLinks ?? this.imageLinks,
      tweetType: tweetType ?? this.tweetType,
      datePublished: datePublished ?? this.datePublished,
      likes: likes ?? this.likes,
      commentIds: commentIds ?? this.commentIds,
      id: id ?? this.id,
      reshareCount: reshareCount ?? this.reshareCount,
      retweetedBy: retweetedBy ?? this.retweetedBy,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'text': text,
      'link': link,
      'hashtags': hashtags,
      'imageLinks': imageLinks,
      'tweetType': tweetType.type,
      'datePublished': datePublished.millisecondsSinceEpoch,
      'likes': likes,
      'id': id,
      'commentIds': commentIds,
      'reshareCount': reshareCount,
      'retweetedBy': retweetedBy,
    };
  }

  factory TweetModel.fromMap(Map<String, dynamic> map) {
    return TweetModel(
      uid: map['uid'] as String,
      text: map['text'] as String,
      link: map['link'] as String,
      hashtags: List<String>.from(map['hashtags']),
      imageLinks: List<String>.from(map['imageLinks']),
      tweetType: (map['tweetType'] as String).toTweetTypeEnum(),
      datePublished: DateTime.fromMillisecondsSinceEpoch(map['datePublished']),
      likes: List<String>.from(map['likes']),
      commentIds: List<String>.from(map['commentIds']),
      id: map['id'] as String,
      reshareCount: map['reshareCount'] as int,
      retweetedBy: map['retweetedBy'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TweetModel.fromJson(String source) =>
      TweetModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TweetModel(uid: $uid, text: $text, link: $link, hashtags: $hashtags, imageLinks: $imageLinks, tweetType: $tweetType, datePublished: $datePublished, likes: $likes, commentIds: $commentIds, id: $id, reshareCount: $reshareCount,retweetedBy: $retweetedBy)';
  }
}
