import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

/// Handles all dictionary file I/O, word validation, and random word selection.
///
/// Refactor: extracted from _loadDictionary() and _submitGuess() in the original
/// game_screen.dart, where file loading, filtering, and validation were all
/// mixed in with UI and game logic. DictionaryService has no Flutter widget
/// dependency, making it independently testable — a mock can be injected into
/// GameViewModel to control returned words without touching the file system.
class DictionaryService {
  List<String> _words = [];
  final Random _random = Random();

  bool get isLoaded => _words.isNotEmpty;

  /// Loads five-letter words from the bundled asset file.
  Future<void> load() async {
    final raw = await rootBundle.loadString('assets/english_dict.txt');
    _words = raw
        .split('\n')
        .map((w) => w.trim().toLowerCase())
        .where((w) => w.length == 5)
        .toList();
  }

  /// Returns true if [word] exists in the loaded dictionary.
  bool isValid(String word) => _words.contains(word.toLowerCase());

  /// Returns a random five-letter word from the dictionary.
  String randomWord() {
    assert(isLoaded, 'DictionaryService.load() must be called before randomWord().');
    return _words[_random.nextInt(_words.length)];
  }
}
