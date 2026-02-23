int calculateReadingTime(String content) {
  // Average reading speed: 200 words per minute
  final wordCount = content.split(RegExp(r'\s+')).length;
  final minutes = (wordCount / 200).ceil();
  return minutes < 1 ? 1 : minutes;
}

String formatDateBlog(DateTime date) {
  // Convert UTC to local time if necessary
  final localDate = date.isUtc ? date.toLocal() : date;
  final now = DateTime.now();
  final difference = now.difference(localDate);

  if (difference.inDays == 0) {
    if (difference.inHours == 0) {
      if (difference.inMinutes < 1) {
        return 'Just now';
      }
      return '${difference.inMinutes}m ago';
    }
    return '${difference.inHours}h ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays}d ago';
  } else if (difference.inDays < 30) {
    final weeks = (difference.inDays / 7).floor();
    return '${weeks}w ago';
  } else if (difference.inDays < 365) {
    final months = (difference.inDays / 30).floor();
    return '${months}mo ago';
  } else {
    final years = (difference.inDays / 365).floor();
    return '${years}y ago';
  }
}
