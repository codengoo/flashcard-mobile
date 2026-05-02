class Flashcard {
  const Flashcard({
    required this.id,
    required this.deckId,
    required this.term,
    required this.definition,
  });

  final String id;
  final String deckId;
  final String term;
  final String definition;
}
