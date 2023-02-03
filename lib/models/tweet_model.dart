// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:rope/core/enums/tweet_type_enums.dart';

class TweetModel {
  final String uid;
  final String text;
  final String link;
  final List<String> hashtags;
  final List<String> imageLinks;
  final TweetType tweetType;
  final datePublished;
  final List<String> likes;
  final List<String> commentIds;
  final String Id;
  final int reshareCount;
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
    required this.Id,
    required this.reshareCount,
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
    String? Id,
    int? reshareCount,
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
      Id: Id ?? this.Id,
      reshareCount: reshareCount ?? this.reshareCount,
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
      'commentIds': commentIds,
      'reshareCount': reshareCount,
    };
  }

  factory TweetModel.fromMap(Map<String, dynamic> map) {
    return TweetModel(
      uid: map['uid'] as String,
      text: map['text'] as String,
      link: map['link'] as String,
      hashtags: List<String>.from((map['hashtags'] as List<String>)),
      imageLinks: List<String>.from((map['imageLinks'] as List<String>)),
      tweetType: (map['tweetType'] as String).toTweetTypeEnum(),
      datePublished:
          DateTime.fromMillisecondsSinceEpoch(map['datePublished'] as int),
      likes: List<String>.from((map['likes'] as List<String>)),
      commentIds: List<String>.from((map['commentIds'] as List<String>)),
      Id: map['\$Id'] as String,
      reshareCount: map['reshareCount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TweetModel.fromJson(String source) =>
      TweetModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TweetModel(uid: $uid, text: $text, link: $link, hashtags: $hashtags, imageLinks: $imageLinks, tweetType: $tweetType, datePublished: $datePublished, likes: $likes, commentIds: $commentIds, Id: $Id, reshareCount: $reshareCount)';
  }

  @override
  bool operator ==(covariant TweetModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.text == text &&
        other.link == link &&
        listEquals(other.hashtags, hashtags) &&
        listEquals(other.imageLinks, imageLinks) &&
        other.tweetType == tweetType &&
        other.datePublished == datePublished &&
        listEquals(other.likes, likes) &&
        listEquals(other.commentIds, commentIds) &&
        other.Id == Id &&
        other.reshareCount == reshareCount;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        text.hashCode ^
        link.hashCode ^
        hashtags.hashCode ^
        imageLinks.hashCode ^
        tweetType.hashCode ^
        datePublished.hashCode ^
        likes.hashCode ^
        commentIds.hashCode ^
        Id.hashCode ^
        reshareCount.hashCode;
  }
}
