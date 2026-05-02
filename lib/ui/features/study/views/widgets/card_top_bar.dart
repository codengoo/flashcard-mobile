import 'package:flashcard/ui/features/study/view_models/study_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class CardTopBar extends StatelessWidget {
  const CardTopBar({super.key, required this.isReview});

  final bool isReview;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StudyViewModel>();
    final progress = (vm.currentIndex + 1) / vm.totalCards;

    final trackColor = isReview
        ? Colors.white.withValues(alpha: 0.2)
        : Colors.black.withValues(alpha: 0.1);
    final fillColor = isReview
        ? Colors.white.withValues(alpha: 0.55)
        : Colors.black.withValues(alpha: 0.28);
    final labelColor = isReview
        ? Colors.white.withValues(alpha: 0.8)
        : Colors.black.withValues(alpha: 0.5);

    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: labelColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: progress),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            builder: (ctx, val, _) {
              return LayoutBuilder(
                builder: (ctx, constraints) {
                  return Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: trackColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.centerLeft,
                    child: AnimatedContainer(
                      duration: Duration.zero,
                      width: constraints.maxWidth * val.clamp(0.0, 1.0),
                      height: 16,
                      decoration: BoxDecoration(
                        color: fillColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${vm.currentIndex + 1} / ${vm.totalCards}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: labelColor,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
