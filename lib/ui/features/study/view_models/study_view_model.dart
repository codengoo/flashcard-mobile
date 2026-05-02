import 'package:flutter/foundation.dart';
import '../../../../data/repositories/deck_repository.dart';
import '../../../../domain/models/deck.dart';
import '../../../../domain/models/flashcard.dart';

enum CardSide { front, back }

enum StudySessionState { studying, complete }

class StudyViewModel extends ChangeNotifier {
  StudyViewModel({required DeckRepository deckRepository})
      : _deckRepository = deckRepository {
    _init();
  }

  final DeckRepository _deckRepository;

  late Deck _deck;
  late List<Flashcard> _cards;
  int _currentIndex = 0;
  CardSide _cardSide = CardSide.front;
  StudySessionState _sessionState = StudySessionState.studying;
  int _earnedMp = 0;

  Deck get deck => _deck;
  List<Flashcard> get cards => _cards;
  int get currentIndex => _currentIndex;
  CardSide get cardSide => _cardSide;
  StudySessionState get sessionState => _sessionState;
  int get earnedMp => _earnedMp;

  Flashcard get currentCard => _cards[_currentIndex];
  int get totalCards => _cards.length;
  bool get isFlipped => _cardSide == CardSide.back;

  void _init() {
    _deck = _deckRepository.getDeck();
    _cards = _deckRepository.getCards(_deck.id);
  }

  void flipCard() {
    if (_sessionState == StudySessionState.complete) return;
    _cardSide =
        _cardSide == CardSide.front ? CardSide.back : CardSide.front;
    notifyListeners();
  }

  void rate(int mpEarned) {
    _earnedMp += mpEarned;
    _advance();
  }

  void _advance() {
    if (_currentIndex < _cards.length - 1) {
      _currentIndex++;
      _cardSide = CardSide.front;
    } else {
      _sessionState = StudySessionState.complete;
    }
    notifyListeners();
  }

  void restart() {
    _currentIndex = 0;
    _cardSide = CardSide.front;
    _sessionState = StudySessionState.studying;
    _earnedMp = 0;
    notifyListeners();
  }
}
