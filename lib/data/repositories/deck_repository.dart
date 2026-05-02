import '../../domain/models/deck.dart';
import '../../domain/models/flashcard.dart';
import '../services/supabase_service.dart';

class DeckRepository {
  /// Fetches all decks from Supabase, joined with terms count.
  Future<List<Deck>> getDecks() async {
    final client = SupabaseService.client;

    final response = await client
        .from('decks')
        .select('id, name, terms(count)');

    final decks = (response as List).map<Deck>((row) {
      return Deck(
        id: row['id'].toString(),
        name: row['name'] as String,
        cardCount: row['terms'][0]['count'] as int,
      );
    }).toList();

    return decks;
  }

  /// Fetches all terms cards for the given [deckId] (deck_id id),
  /// joined with their parent deck_id via the `deck_id` FK.
  Future<List<Flashcard>> getCards(String deckId) async {
    final rows = await SupabaseService.client
        .from('terms')
        .select('id, term, definition, deck_id')
        .eq('deck_id', deckId);

    return rows.map<Flashcard>((r) {
      return Flashcard(
        id: r['id'].toString(),
        deckId: r['deck_id'].toString(),
        term: r['term'] as String,
        definition: r['definition'] as String,
      );
    }).toList();
  }
}
