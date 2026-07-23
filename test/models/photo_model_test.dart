import 'package:flutter_test/flutter_test.dart';
import 'package:tinysteps/models/photo_model.dart';

void main() {
  group('PhotoModel Tests', () {
    test('PhotoModel creates correctly with all fields', () {
      final now = DateTime.now();
      final photo = PhotoModel(
        id: 1,
        imageUrl: 'https://example.com/photo.jpg',
        caption: 'Happy kid',
        timestamp: now,
        taggedActivity: 'Playtime',
      );

      expect(photo.id, 1);
      expect(photo.imageUrl, 'https://example.com/photo.jpg');
      expect(photo.caption, 'Happy kid');
      expect(photo.timestamp, now);
      expect(photo.taggedActivity, 'Playtime');
    });

    test('PhotoModel handles null taggedActivity', () {
      final photo = PhotoModel(
        id: 2,
        imageUrl: 'local/path/img.png',
        caption: 'Smile',
        timestamp: DateTime(2023, 1, 1),
      );

      expect(photo.taggedActivity, isNull);
    });
  });
}
