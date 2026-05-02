import 'package:flutter/foundation.dart';
import '../../../../data/repositories/deck_repository.dart';
import '../../../../domain/models/deck.dart';
import '../../../../domain/models/flashcard.dart';

enum CardSide { front, back }

enum StudySessionState { studying, complete }

class StudyViewModel extends ChangeNotifier {
  StudyViewModel({required DeckRepository deckRepository})
      : _deckRepository = deckRepository {
    _loadDecks();
  }

  final DeckRepository _deckRepository;

  List<Deck> _decks = [];
  Deck? _deck;
  List<Flashcard> _cards = [];
  int _currentIndex = 0;
  CardSide _cardSide = CardSide.front;
  StudySessionState _sessionState = StudySessionState.studying;
  int _earnedMp = 0;
  final Set<String> _reviewAgainIds = {};

  bool _isLoading = true;
  String? _loadError;

  // ── Public getters ──────────────────────────────────────────────────────────
  List<Deck> get decks => _decks;
  Deck? get deck => _deck;
  List<Flashcard> get cards => _cards;
  int get currentIndex => _currentIndex;
  CardSide get cardSide => _cardSide;
  StudySessionState get sessionState => _sessionState;
  int get earnedMp => _earnedMp;
  bool get isLoading => _isLoading;
  String? get loadError => _loadError;

  bool get hasCards => _cards.isNotEmpty;
  Flashcard get currentCard => _cards[_currentIndex];
  int get totalCards => _cards.length;
  bool get isFlipped => _cardSide == CardSide.back;
  bool get isCurrentReviewAgain => _reviewAgainIds.contains(currentCard.id);
  bool get canGoBack => _currentIndex > 0;

  bool isReviewAgainForCard(String id) => _reviewAgainIds.contains(id);

  void setIndex(int index) {
    if (index < 0 || index >= _cards.length) return;
    _currentIndex = index;
    _cardSide = CardSide.front;
    notifyListeners();
  }

  // ── Data loading ────────────────────────────────────────────────────────────
  Future<void> refreshDecks() => _loadDecks();

  Future<void> _loadDecks() async {
    _isLoading = true;
    _loadError = null;
    notifyListeners();
    try {
      _decks = await _deckRepository.getDecks();
    } catch (e) {
      _loadError = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load cards for a specific deck before entering the study session.
  Future<void> loadDeck(String deckId) async {
    _isLoading = true;
    _loadError = null;
    notifyListeners();
    try {
      _deck = _decks.firstWhere((d) => d.id == deckId);
      _cards = await _deckRepository.getCards(deckId);
      _currentIndex = 0;
      _cardSide = CardSide.front;
      _sessionState = StudySessionState.studying;
      _earnedMp = 0;
      _reviewAgainIds.clear();
    } catch (e) {
      _loadError = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Study actions ───────────────────────────────────────────────────────────
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

  void toggleReviewAgain() {
    final id = currentCard.id;
    if (_reviewAgainIds.contains(id)) {
      _reviewAgainIds.remove(id);
    } else {
      _reviewAgainIds.add(id);
    }
    notifyListeners();
  }

  void goBack() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _cardSide = CardSide.front;
      notifyListeners();
    }
  }

  void goNext() {
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

