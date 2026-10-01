import 'package:flutter/material.dart';
import 'package:purrdle/model/game_tile.dart';
import 'package:purrdle/model/game_stats.dart';
import 'package:purrdle/services/dictionary_service.dart';

/// Owns all game logic and exposes state to the View via ChangeNotifier.
class GameViewModel extends ChangeNotifier {
  static const int maxGuesses = 6;
  static const int wordLength = 5;

  final DictionaryService _dictionary;
  final GameStats stats = GameStats();

  String _targetWord = '';
  final List<String> _guesses = [];
  bool _gameOver = false;
  bool _won = false;

  final Map<String, TileStatus> _keyboardStatuses = {
    for (var c in 'QWERTYUIOPASDFGHJKLZXCVBNM'.split('')) c: TileStatus.empty,
  };

  GameViewModel(this._dictionary);

  // ── Getters ───────────────────────────────────────────────────────────────

  String get targetWord => _targetWord;
  List<String> get guesses => List.unmodifiable(_guesses);
  Map<String, TileStatus> get keyboardStatuses => Map.unmodifiable(_keyboardStatuses);
  bool get gameOver => _gameOver;
  bool get won => _won;
  int get guessCount => _guesses.length;
  bool get canGuess => !_gameOver && _guesses.length < maxGuesses;

  /// True once a target word has been chosen.
  /// Used by GameScreen to skip init() when a pre-initialised ViewModel is
  /// injected (e.g. in widget tests), avoiding a rootBundle hang.
  bool get isInitialized => _targetWord.isNotEmpty;

  // ── Initialisation ────────────────────────────────────────────────────────

  /// Loads the dictionary and picks the first target word.
  ///
  /// Fix: if the dictionary is already loaded (isLoaded == true) before the
  /// first await — as is always true for MockDictionary in tests — _startNewRound()
  /// is called synchronously (before any suspension point) so _targetWord is set
  /// even when callers do not await this Future.
  Future<void> init() async {
    if (_dictionary.isLoaded) {
      _startNewRound(); // synchronous — runs before any await
    }
    await _dictionary.load();
    if (_targetWord.isEmpty) {
      _startNewRound(); // real DictionaryService path
    }
    notifyListeners();
  }

  // ── Public API ────────────────────────────────────────────────────────────

  /// Validates and submits [rawGuess]. Returns an error string or null on success.
  String? submitGuess(String rawGuess) {
    final guess = rawGuess.trim().toLowerCase();

    if (!canGuess) return 'Game is over.';
    if (guess.length != wordLength) return 'Word must be $wordLength letters!';
    if (!_dictionary.isValid(guess)) return 'Meow, not a valid word!';
    if (_guesses.contains(guess)) return 'Already guessed that word!';

    _guesses.add(guess);
    _updateKeyboardStatuses(guess);

    if (guess == _targetWord) {
      _won = true;
      _gameOver = true;
      stats.recordWin(_guesses.length);
    } else if (_guesses.length >= maxGuesses) {
      _gameOver = true;
      stats.recordLoss();
    }

    notifyListeners();
    return null;
  }

  /// Resets all game state and picks a new target word.
  void newGame() {
    _startNewRound();
    notifyListeners();
  }

  // ── Tile evaluation ───────────────────────────────────────────────────────

  /// Returns the list of [GameTile] objects for a submitted guess row.
  ///
  /// Uses a single left-to-right pass with a consumed-pool approach:
  /// for each position in order, check correct first (target[i] == guess[i]),
  /// then present (letter exists anywhere remaining in pool), then absent.
  /// This naturally handles duplicate letters correctly — whichever occurrence
  /// of a repeated letter is encountered first (left-to-right) claims the pool
  /// slot, so subsequent occurrences are correctly marked absent when the pool
  /// is exhausted.
  List<GameTile> evaluateGuess(String guess) {
    final pool = _targetWord.split('');
    final result = <GameTile>[];

    for (int i = 0; i < wordLength; i++) {
      final g = guess[i];
      if (pool[i] == g) {
        // Correct position: consume this pool slot
        result.add(GameTile(letter: g, status: TileStatus.correct));
        pool[i] = '';
      } else {
        final idx = pool.indexOf(g);
        if (idx != -1) {
          // Letter exists elsewhere in the remaining pool
          result.add(GameTile(letter: g, status: TileStatus.present));
          pool[idx] = '';
        } else {
          result.add(GameTile(letter: g, status: TileStatus.absent));
        }
      }
    }

    return result;
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  void _startNewRound() {
    _targetWord = _dictionary.randomWord();
    _guesses.clear();
    _gameOver = false;
    _won = false;
    for (final key in _keyboardStatuses.keys) {
      _keyboardStatuses[key] = TileStatus.empty;
    }
  }

  /// Updates keyboard statuses after each guess using TileStatus priority:
  /// correct > present > absent > empty. A higher-priority status is never
  /// overwritten by a lower one.
  void _updateKeyboardStatuses(String guess) {
    final tiles = evaluateGuess(guess);
    for (int i = 0; i < guess.length; i++) {
      final letter = guess[i].toUpperCase();
      final newStatus = tiles[i].status;
      final current = _keyboardStatuses[letter] ?? TileStatus.empty;

      if (current == TileStatus.correct) continue;
      if (current == TileStatus.present && newStatus == TileStatus.absent) continue;

      _keyboardStatuses[letter] = newStatus;
    }
  }
}
