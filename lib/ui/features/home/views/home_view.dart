import 'package:flashcard/ui/core/themes/colors.dart';
import 'package:flashcard/ui/features/home/views/widgets/deck_card.dart';
import 'package:flashcard/ui/features/profile/views/profile_view.dart';
import 'package:flashcard/ui/features/study/view_models/study_view_model.dart';
import 'package:flashcard/ui/features/study/views/flashcard_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

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
              icon: const Icon(TablerIcons.user_circle),
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
            if (vm.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (vm.loadError != null)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(TablerIcons.alert_circle, size: 40, color: Colors.red),
                    const SizedBox(height: 8),
                    Text(
                      'Could not load decks',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vm.loadError!,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else if (vm.decks.isEmpty)
              Center(
                child: Text(
                  'No decks found.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              )
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => context.read<StudyViewModel>().refreshDecks(),
                  child: ListView.separated(
                    itemCount: vm.decks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) {
                      final deck = vm.decks[i];
                      return DeckCard(
                        title: deck.name,
                        cardCount: deck.cardCount,
                        onTap: () => _openDeck(context, deck.id),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _openDeck(BuildContext context, String deckId) async {
    final studyVm = context.read<StudyViewModel>();
    await studyVm.loadDeck(deckId);
    if (!context.mounted) return;
    studyVm.restart();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: studyVm,
          child: const FlashcardView(),
        ),
      ),
    );
  }
}

