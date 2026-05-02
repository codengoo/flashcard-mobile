import 'package:flashcard/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';

class RatingButtons extends StatelessWidget {
  const RatingButtons({
    super.key,
    required this.onRate,
    required this.isReview,
  });

  final ValueChanged<int> onRate;
  final bool isReview;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconRatingButton(
          icon: Icons.thumb_up_outlined,
          color: isReview ? Colors.white70 : AppColors.ratingYeah,
          onTap: () => onRate(10),
        ),
        IconRatingButton(
          icon: Icons.thumb_down_outlined,
          color: isReview ? Colors.white70 : AppColors.ratingNah,
          onTap: () => onRate(0),
        ),
        IconRatingButton(
          icon: Icons.priority_high_rounded,
          color: isReview ? Colors.white70 : AppColors.ratingABit,
          onTap: () => onRate(5),
        ),
      ],
    );
  }
}

class IconRatingButton extends StatelessWidget {
  const IconRatingButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.08),
        ),
        child: Icon(icon, color: color, size: 26),
      ),
    );
  }
}
