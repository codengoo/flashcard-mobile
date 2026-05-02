import 'package:flashcard/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/study_view_model.dart';
import 'session_complete_view.dart';

class FlashcardView extends StatelessWidget {
  const FlashcardView({super.key});

  static const routeName = '/study';

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StudyViewModel>();

    if (vm.sessionState == StudySessionState.complete) {
      return SessionCompleteView(earnedMp: vm.earnedMp);
    }

    return Scaffold(
      backgroundColor: AppColors.mpGold,
      body: GestureDetector(
        onTap: !vm.isFlipped
            ? () => context.read<StudyViewModel>().flipCard()
            : null,
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            child: vm.isFlipped
                ? _CardBack(key: const ValueKey('back'))
                : _CardFront(key: const ValueKey('front')),
          ),
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.current, required this.total});
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: LinearProgressIndicator(
        value: current / total,
        minHeight: 3,
        backgroundColor: Colors.black.withValues(alpha: 0.12),
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.black38),
      ),
    );
  }
}

class _CardFront extends StatelessWidget {
  const _CardFront({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StudyViewModel>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _ProgressBar(
                  current: vm.currentIndex + 1,
                  total: vm.totalCards,
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'TERM',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withValues(alpha: 0.45),
                    letterSpacing: 1.8,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  vm.currentCard.term,
                  style: const TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(
                      Icons.volume_up_outlined,
                      size: 20,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      vm.currentCard.term,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black.withValues(alpha: 0.55),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 32),
              padding: const EdgeInsets.symmetric(
                horizontal: 48,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'flip',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    '→',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardBack extends StatelessWidget {
  const _CardBack({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StudyViewModel>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: () => context.read<StudyViewModel>().flipCard(),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _ProgressBar(
                  current: vm.currentIndex + 1,
                  total: vm.totalCards,
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'DEFINITION',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withValues(alpha: 0.45),
                    letterSpacing: 1.8,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  vm.currentCard.term,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  vm.currentCard.definition,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.6,
                    color: Colors.black.withValues(alpha: 0.75),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          _RatingButtons(
            onRate: (mp) => context.read<StudyViewModel>().rate(mp),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _RatingButtons extends StatelessWidget {
  const _RatingButtons({required this.onRate});
  final ValueChanged<int> onRate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: _RatingButton(
              label: 'Nah',
              color: AppColors.ratingNah,
              onTap: () => onRate(0),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _RatingButton(
              label: 'A bit',
              color: AppColors.ratingABit,
              onTap: () => onRate(5),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _RatingButton(
              label: 'Yeah!',
              color: AppColors.ratingYeah,
              onTap: () => onRate(10),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingButton extends StatelessWidget {
  const _RatingButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(50),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}
