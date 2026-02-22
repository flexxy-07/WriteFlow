class Blog {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final String posterId;
  final DateTime updatedAt;
  final List<String> topics;
  final String? posterName;
  Blog({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.posterId,
    required this.updatedAt,
    required this.topics,
    this.posterName,
  });

  

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'poster_id': posterId,
      'updated_at': updatedAt.toIso8601String(),
      'topics': topics,
    };
  }

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String,
      posterId: json['poster_id'] as String,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      topics: List<String>.from(json['topics'] as List),
    );
  }
}
