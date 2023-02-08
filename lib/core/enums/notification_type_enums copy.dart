enum NotificationType {
  like('like'),
  retweet('retweet'),
  reply('reply'),
  follow('follow');

  final String type;
  const NotificationType(this.type);
}

extension ConvertTweet on String {
  NotificationType toNoticationTypeEnum() {
    switch (this) {
      case 'retweet':
        return NotificationType.retweet;
      case 'reply':
        return NotificationType.reply;
        case 'follow':
        return NotificationType.follow;
      default:
        return NotificationType.like;
    }
  }
}