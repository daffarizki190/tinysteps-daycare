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
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
