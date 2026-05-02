import 'package:flashcard/ui/features/study/view_models/study_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewAgainButton extends StatelessWidget {
  const ReviewAgainButton({super.key, required this.isReview});

  final bool isReview;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<StudyViewModel>().toggleReviewAgain(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isReview
              ? Colors.white.withValues(alpha: 0.25)
              : Colors.black.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(50),
          border:
              isReview ? Border.all(color: Colors.white54, width: 1) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isReview ? Icons.bookmark : Icons.bookmark_border,
              size: 14,
              color: isReview
                  ? Colors.white
                  : Colors.black.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 5),
            Text(
              'H\u1ecdc l\u1ea1i',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isReview
                    ? Colors.white
                    : Colors.black.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
