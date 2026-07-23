class PhotoModel {
  final int id;
  final String imageUrl;
  final String caption;
  final DateTime timestamp;
  final String? taggedActivity;

  PhotoModel({
    required this.id,
    required this.imageUrl,
    required this.caption,
    required this.timestamp,
    this.taggedActivity,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['id'] as int,
      imageUrl: json['imageUrl'] as String,
      caption: json['caption'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      taggedActivity: json['taggedActivity'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'caption': caption,
      'timestamp': timestamp.toIso8601String(),
      'taggedActivity': taggedActivity,
    };
  }
}
