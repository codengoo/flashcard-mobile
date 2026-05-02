import '../../domain/models/deck.dart';
import '../../domain/models/flashcard.dart';
import '../../domain/models/user_profile.dart';

class MockDataService {
  static const Deck cognitiveBiasesDeck = Deck(
    id: 'deck-1',
    name: 'Cognitive Biases #2: N...',
    cardCount: 10,
  );

  static const List<Flashcard> cognitiveBiasCards = [
    Flashcard(
      id: 'card-1',
      deckId: 'deck-1',
      term: 'Survivorship bias',
      definition:
          'We focus on the people who made it past the selection process and ignore those who did not.',
    ),
    Flashcard(
      id: 'card-2',
      deckId: 'deck-1',
      term: 'Confirmation bias',
      definition:
          'The tendency to search for, interpret, and recall information in a way that confirms one\'s preexisting beliefs.',
    ),
    Flashcard(
      id: 'card-3',
      deckId: 'deck-1',
      term: 'Dunning-Kruger effect',
      definition:
          'A cognitive bias where people with limited knowledge overestimate their own competence.',
    ),
    Flashcard(
      id: 'card-4',
      deckId: 'deck-1',
      term: 'Anchoring bias',
      definition:
          'The tendency to rely too heavily on the first piece of information encountered when making decisions.',
    ),
    Flashcard(
      id: 'card-5',
      deckId: 'deck-1',
      term: 'Sunk cost fallacy',
      definition:
          'Continuing a behavior or endeavor because of previously invested resources (time, money, effort) rather than future value.',
    ),
  ];

  static final UserProfile currentUser = UserProfile(
    name: 'Ira',
    email: 'user@example.com',
    mp: 2565,
    avatarInitials: 'I',
    streakDays: [
      true, false, true, true, false, true, true,
      true, true, false, true, false, true, true,
      false, true, true, true, false, false, true,
      true, false, true, true, true, false, true,
    ],
  );
}
