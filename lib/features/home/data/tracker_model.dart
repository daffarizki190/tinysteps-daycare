import 'package:flutter/material.dart';

class TrackerModel {
  final String id;
  final String activity;
  final String time;
  final String description;
  final IconData icon;
  final Color color;
  final Color bgColor;

  TrackerModel({
    required this.id,
    required this.activity,
    required this.time,
    required this.description,
    required this.icon,
    required this.color,
    required this.bgColor,
  });
  factory TrackerModel.fromJson(Map<String, dynamic> json) {
    final iconMap = _getIconTheme(json['activity'] as String? ?? '');
    String timeDisplay = json['time'] as String? ?? '';
    timeDisplay = _formatTime(timeDisplay);

    return TrackerModel(
      id: json['id']?.toString() ?? '',
      activity: json['activity'] as String? ?? 'Activity',
      time: timeDisplay,
      description: json['description'] as String? ?? '',
      icon: iconMap['icon'] as IconData,
      color: iconMap['color'] as Color,
      bgColor: iconMap['bgColor'] as Color,
    );
  }
  static String _formatTime(String raw) {
    try {
      final dt = DateTime.parse(raw);
      final hour = dt.hour;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      return '${displayHour.toString().padLeft(2, '0')}:$minute $period';
    } catch (_) {
      return raw;
    }
  }

  static Map<String, dynamic> _getIconTheme(String activity) {
    final lower = activity.toLowerCase();

    if (lower.contains('morning') || lower.contains('circle')) {
      return {
        'icon': Icons.wb_sunny_rounded,
        'color': const Color(0xFFFFD166),
        'bgColor': const Color(0xFFFFF8E1),
      };
    } else if (lower.contains('breakfast')) {
      return {
        'icon': Icons.breakfast_dining_rounded,
        'color': const Color(0xFFFF6B6B),
        'bgColor': const Color(0xFFFFEBEB),
      };
    } else if (lower.contains('art') ||
        lower.contains('creative') ||
        lower.contains('paint')) {
      return {
        'icon': Icons.palette_rounded,
        'color': const Color(0xFFAB83F5),
        'bgColor': const Color(0xFFF3ECFF),
      };
    } else if (lower.contains('outdoor') ||
        lower.contains('nature') ||
        lower.contains('play')) {
      return {
        'icon': Icons.nature_people_rounded,
        'color': const Color(0xFF6F9E77),
        'bgColor': const Color(0xFFD4E8D7),
      };
    } else if (lower.contains('nap') ||
        lower.contains('sleep') ||
        lower.contains('rest')) {
      return {
        'icon': Icons.bedtime_rounded,
        'color': const Color(0xFF4FC3F7),
        'bgColor': const Color(0xFFE1F5FE),
      };
    } else if (lower.contains('lunch') ||
        lower.contains('dinner') ||
        lower.contains('eat')) {
      return {
        'icon': Icons.restaurant_rounded,
        'color': const Color(0xFFFF9800),
        'bgColor': const Color(0xFFFFF3E0),
      };
    } else if (lower.contains('story') || lower.contains('read')) {
      return {
        'icon': Icons.menu_book_rounded,
        'color': const Color(0xFF26C6DA),
        'bgColor': const Color(0xFFE0F7FA),
      };
    } else if (lower.contains('snack')) {
      return {
        'icon': Icons.local_cafe_rounded,
        'color': const Color(0xFFEF9A9A),
        'bgColor': const Color(0xFFFCE4EC),
      };
    } else if (lower.contains('music') || lower.contains('dance')) {
      return {
        'icon': Icons.music_note_rounded,
        'color': const Color(0xFF7986CB),
        'bgColor': const Color(0xFFE8EAF6),
      };
    } else if (lower.contains('pick') ||
        lower.contains('goodbye') ||
        lower.contains('home')) {
      return {
        'icon': Icons.directions_car_rounded,
        'color': const Color(0xFF8EB695),
        'bgColor': const Color(0xFFD4E8D7),
      };
    } else if (lower.contains('run')) {
      return {
        'icon': Icons.directions_run_rounded,
        'color': const Color(0xFFE57373),
        'bgColor': const Color(0xFFFFEBEE),
      };
    } else if (lower.contains('code')) {
      return {
        'icon': Icons.computer_rounded,
        'color': const Color(0xFF81C784),
        'bgColor': const Color(0xFFE8F5E9),
      };
    }
    return {
      'icon': Icons.event_note_rounded,
      'color': const Color(0xFF78909C),
      'bgColor': const Color(0xFFECEFF1),
    };
  }
}