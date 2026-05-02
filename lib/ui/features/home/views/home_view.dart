import 'package:flashcard/ui/core/themes/colors.dart';
import 'package:flashcard/ui/features/home/views/widgets/deck_card.dart';
import 'package:flashcard/ui/features/profile/views/profile_view.dart';
import 'package:flashcard/ui/features/study/view_models/study_view_model.dart';
import 'package:flashcard/ui/features/study/views/flashcard_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StudyViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Decks'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.account_circle_outlined),
              iconSize: 28,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfileView()),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ready to study?',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            DeckCard(
              title: vm.deck.name,
              cardCount: vm.totalCards,
              onTap: () {
                final studyVm = context.read<StudyViewModel>();
                studyVm.restart();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider.value(
                      value: studyVm,
                      child: const FlashcardView(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
