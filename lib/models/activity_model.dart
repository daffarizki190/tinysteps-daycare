class ActivityModel {
  final int id;
  final String title;
  final String body;

  ActivityModel({
    required this.id,
    required this.title,
    required this.body,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }
}
