import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/deck_repository.dart';
import 'data/repositories/user_repository.dart';
import 'ui/core/app_theme.dart';
import 'ui/features/home/views/home_view.dart';
import 'ui/features/profile/view_models/profile_view_model.dart';
import 'ui/features/study/view_models/study_view_model.dart';

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
        home: const HomeView(),
      ),
    );
  }
}