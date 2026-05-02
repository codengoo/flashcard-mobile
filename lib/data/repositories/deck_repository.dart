import '../../domain/models/deck.dart';
import '../../domain/models/flashcard.dart';
import '../services/mock_data_service.dart';

class DeckRepository {
  Deck getDeck() => MockDataService.cognitiveBiasesDeck;

  List<Flashcard> getCards(String deckId) => MockDataService.cognitiveBiasCards
      .where((c) => c.deckId == deckId)
      .toList();
}
