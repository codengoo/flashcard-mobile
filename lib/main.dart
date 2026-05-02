import 'package:flashcard/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/deck_repository.dart';
import 'data/repositories/user_repository.dart';
import 'ui/core/app_theme.dart';
import 'ui/core/widgets/app_bottom_nav_bar.dart';
import 'ui/features/profile/view_models/profile_view_model.dart';
import 'ui/features/profile/views/profile_view.dart';
import 'ui/features/study/view_models/study_view_model.dart';
import 'ui/features/study/views/flashcard_view.dart';

void main() {
  runApp(const FlashcardApp());
}

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DeckRepository>(create: (_) => DeckRepository()),
        Provider<UserRepository>(create: (_) => UserRepository()),
        ChangeNotifierProxyProvider<DeckRepository, StudyViewModel>(
          create: (ctx) => StudyViewModel(
            deckRepository: ctx.read<DeckRepository>(),
          ),
          update: (ctx, repo, prev) =>
              prev ?? StudyViewModel(deckRepository: repo),
        ),
        ChangeNotifierProxyProvider<UserRepository, ProfileViewModel>(
          create: (ctx) => ProfileViewModel(
            userRepository: ctx.read<UserRepository>(),
          ),
          update: (ctx, repo, prev) =>
              prev ?? ProfileViewModel(userRepository: repo),
        ),
      ],
      child: MaterialApp(
        title: 'Flashcard',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const RootScaffold(),
      ),
    );
  }
}

class RootScaffold extends StatefulWidget {
  const RootScaffold({super.key});

  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    _HomeTab(),
    _SearchTab(),
    _AddTab(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (idx) => setState(() => _selectedIndex = idx),
      ),
    );
  }
}

// ──────────────────────── Home Tab ────────────────────────
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StudyViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('My Decks')),
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
            _DeckCard(
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

class _DeckCard extends StatelessWidget {
  const _DeckCard({
    required this.title,
    required this.cardCount,
    required this.onTap,
  });

  final String title;
  final int cardCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.style_rounded,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$cardCount cards',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────── Stub Tabs ────────────────────────
class _SearchTab extends StatelessWidget {
  const _SearchTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Search')),
      body: const Center(
        child: Text('Search coming soon'),
      ),
    );
  }
}

class _AddTab extends StatelessWidget {
  const _AddTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Add Card')),
      body: const Center(
        child: Text('Add card coming soon'),
      ),
    );
  }
}
