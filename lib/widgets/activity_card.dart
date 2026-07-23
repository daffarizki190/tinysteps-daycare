import 'package:flutter/material.dart';
import '../models/activity_model.dart';

/// Widget kartu aktivitas untuk timeline Daily Tracker.
/// Menampilkan ikon, judul, deskripsi, dan waktu aktivitas
/// dalam desain timeline card.
class ActivityCard extends StatelessWidget {
  final ActivityModel activity;
  final int index;
  final bool isLast;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.index,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    // Warna & ikon berdasarkan index (rotasi)
    final style = _styles[index % _styles.length];
    final icon = style['icon'] as IconData;
    final iconColor = style['color'] as Color;
    final circleColor = style['bgColor'] as Color;
    final time = '${8 + (index % 10)}:${index.isEven ? '00' : '30'} ${index < 4 ? 'AM' : 'PM'}';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Timeline indicator (circle + line) ──
          Column(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withValues(alpha: 0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: iconColor, size: 18),
              ),
              Expanded(
                child: isLast
                    ? const SizedBox()
                    : Container(
                        width: 2.0,
                        color: const Color(0xFFECEFF1),
                      ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // ── Card content ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                    width: 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            activity.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: iconColor.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Body
                    Text(
                      activity.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Style definitions ────────────────────────────────────
  static const List<Map<String, dynamic>> _styles = [
    {
      'icon': Icons.restaurant_rounded,
      'color': Color(0xFFE65100),
      'bgColor': Color(0xFFFFF3E0),
    },
    {
      'icon': Icons.palette_rounded,
      'color': Color(0xFF651FFF),
      'bgColor': Color(0xFFF3ECFF),
    },
    {
      'icon': Icons.sports_esports_rounded,
      'color': Color(0xFF0277BD),
      'bgColor': Color(0xFFE1F5FE),
    },
    {
      'icon': Icons.menu_book_rounded,
      'color': Color(0xFFC2185B),
      'bgColor': Color(0xFFFCE4EC),
    },
    {
      'icon': Icons.nature_people_rounded,
      'color': Color(0xFF2E7D32),
      'bgColor': Color(0xFFE8F5E9),
    },
    {
      'icon': Icons.music_note_rounded,
      'color': Color(0xFFFF6F00),
      'bgColor': Color(0xFFFFF8E1),
    },
    {
      'icon': Icons.nightlight_round,
      'color': Color(0xFF1A73E8),
      'bgColor': Color(0xFFE8F0FE),
    },
    {
      'icon': Icons.child_care_rounded,
      'color': Color(0xFF00897B),
      'bgColor': Color(0xFFE0F2F1),
    },
  ];
}
