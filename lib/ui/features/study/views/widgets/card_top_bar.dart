import 'package:flashcard/ui/features/study/view_models/study_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardTopBar extends StatelessWidget {
  const CardTopBar({super.key, required this.isReview});

  final bool isReview;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StudyViewModel>();
    final iconColor =
        isReview ? Colors.white70 : Colors.black.withValues(alpha: 0.5);

    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: (vm.currentIndex + 1) / vm.totalCards,
              minHeight: 3,
              backgroundColor: Colors.black.withValues(alpha: 0.12),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.black38),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${vm.currentIndex + 1}/${vm.totalCards}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }
}
