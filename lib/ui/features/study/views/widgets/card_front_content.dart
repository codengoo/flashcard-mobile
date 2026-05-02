import 'package:flashcard/domain/models/flashcard.dart';
import 'package:flashcard/ui/core/themes/colors.dart';
import 'package:flashcard/ui/features/study/views/widgets/review_again_button.dart';
import 'package:flutter/material.dart';

class CardFrontContent extends StatelessWidget {
  const CardFrontContent({super.key, required this.card, required this.isReview});

  final Flashcard card;
  final bool isReview;

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
                  card.term,
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 36),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tap to flip',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black.withValues(alpha: 0.35),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ReviewAgainButton(isReview: isReview),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
