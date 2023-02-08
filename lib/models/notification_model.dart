// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:rope/core/enums/notification_type_enums%20copy.dart';

class Notification {
  final String uid;
  final String id;
  final String text;
  final String postId;
  final NotificationType notificationType;
  Notification({
    required this.uid,
    required this.id,
    required this.text,
    required this.postId,
    required this.notificationType,
  });

  Notification copyWith({
    String? uid,
    String? id,
    String? text,
    String? postId,
    NotificationType? notificationType,
  }) {
    return Notification(
      uid: uid ?? this.uid,
      id: id ?? this.id,
      text: text ?? this.text,
      postId: postId ?? this.postId,
      notificationType: notificationType ?? this.notificationType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'id': id,
      'text': text,
      'postId': postId,
      'notificationType': notificationType.type,
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      uid: map['uid'] as String,
      id: map['id'] as String,
      text: map['text'] as String,
      postId: map['postId'] as String,
      notificationType:
          (map['notificationType'] as String).toNoticationTypeEnum(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Notification.fromJson(String source) =>
      Notification.fromMap(json.decode(source) as Map<String, dynamic>);
}
