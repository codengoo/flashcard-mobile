import 'package:flashcard/domain/models/flashcard.dart';
import 'package:flashcard/ui/core/themes/colors.dart';
import 'package:flashcard/ui/features/study/views/widgets/rating_buttons.dart';
import 'package:flashcard/ui/features/study/views/widgets/review_again_button.dart';
import 'package:flutter/material.dart';

class CardBackContent extends StatelessWidget {
  const CardBackContent({
    super.key,
    required this.card,
    required this.isReview,
    required this.onRate,
  });

  final Flashcard card;
  final bool isReview;
  final Future<void> Function(int) onRate;

  @override
  Widget build(BuildContext context) {
    final textColor = isReview ? Colors.white : AppColors.textPrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  card.definition,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RatingButtons(
                  isReview: isReview,
                  onRate: onRate,
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Swipe \u2190 prev  \u2022  next \u2192',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black.withValues(alpha: 0.35),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    ReviewAgainButton(isReview: isReview),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
