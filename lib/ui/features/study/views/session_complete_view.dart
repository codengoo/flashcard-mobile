import 'package:flashcard/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '../view_models/study_view_model.dart';

class SessionCompleteView extends StatelessWidget {
  const SessionCompleteView({super.key, required this.earnedMp});

  final int earnedMp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Back button
            Positioned(
              top: 8,
              left: 8,
              child: TextButton.icon(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(
                  TablerIcons.arrow_left,
                  size: 16,
                  color: AppColors.primary,
                ),
                label: const Text(
                  'Back',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ),
            // MP earned badge
            Positioned(
              top: 12,
              right: 16,
              child: _MpBadge(mp: earnedMp),
            ),
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SuccessCircle(),
                  const SizedBox(height: 32),
                  Text(
                    'Great job!',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: 200,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () =>
                          context.read<StudyViewModel>().restart(),
                      child: const Text('Restart'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surface,
        border: Border.all(color: AppColors.primary, width: 3),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: const Icon(
        TablerIcons.check,
        size: 48,
        color: AppColors.primary,
      ),
    );
  }
}

class _MpBadge extends StatelessWidget {
  const _MpBadge({required this.mp});
  final int mp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.divider),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            TablerIcons.bolt,
            size: 16,
            color: AppColors.mpGold,
          ),
          const SizedBox(width: 4),
          Text(
            '+$mp mp',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
