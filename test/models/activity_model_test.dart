import 'package:flutter_test/flutter_test.dart';
import 'package:tinysteps/models/activity_model.dart';

void main() {
  group('ActivityModel Tests', () {
    test('fromJson creates a valid ActivityModel', () {
      final Map<String, dynamic> json = {
        'id': '1',
        'title': 'Morning Nap',
        'body': 'Sleeping peacefully',
      };

      final activity = ActivityModel.fromJson(json);

      expect(activity.id, 1);
      expect(activity.title, 'Morning Nap');
      expect(activity.body, 'Sleeping peacefully');
    });

    test('fromJson handles missing optional fields', () {
      final Map<String, dynamic> json = {
        'id': 2,
        // title and body are missing
      };

      final activity = ActivityModel.fromJson(json);

      expect(activity.id, 2);
      expect(activity.title, '');
      expect(activity.body, '');
    });
  });
}
