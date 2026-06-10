import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';






class TrackerItemCard extends StatelessWidget {
  const TrackerItemCard({
    super.key,
    required this.data,
    required this.offsetAnimation,
    required this.opacityAnimation,
    required this.controller,
  });

  final Map<String, dynamic> data;
  final Animation<double> offsetAnimation;
  final Animation<double> opacityAnimation;
  final Animation<double> controller; // parent controller untuk AnimatedBuilder

  @override
  Widget build(BuildContext context) {
    final Color iconColor = data['color'] as Color;
    final Color bgColor = data['bgColor'] as Color;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Opacity(
          opacity: opacityAnimation.value,
          child: Transform.translate(
            offset: Offset(0, offsetAnimation.value),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 6),

          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              data['icon'] as IconData,
              color: iconColor,
              size: 22,
            ),
          ),

          title: Text(
            data['activity'] as String,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              letterSpacing: 0.1,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              data['desc'] as String,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),

          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              data['time'] as String,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: iconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
