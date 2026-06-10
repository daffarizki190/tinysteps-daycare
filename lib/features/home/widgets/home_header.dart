import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Widget header halaman Home:
/// - Baris greeting + avatar
/// - Tiga summary chip (jumlah aktivitas, jam operasional, jumlah anak)
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFEEF0F2)),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Greeting row ──
          Row(
            children: [
              // Avatar
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: AppColors.primaryGreenLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.face_rounded,
                  size: 26,
                  color: AppColors.primaryGreenDark,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good Morning! 👋',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Here's what's planned for today",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // ── Summary chips ──
          Row(
            children: [
              _SummaryChip(
                icon: Icons.event_note_rounded,
                label: '10 Activities',
                color: const Color(0xFF8EB695),
              ),
              const SizedBox(width: 10),
              _SummaryChip(
                icon: Icons.schedule_rounded,
                label: '7:00 – 5:00 PM',
                color: const Color(0xFF7986CB),
              ),
              const SizedBox(width: 10),
              _SummaryChip(
                icon: Icons.child_care_rounded,
                label: '12 Kids',
                color: const Color(0xFFFF9800),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Private helper: satu chip summary ──
class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
