/// Tracks cumulative game statistics across all rounds in a session.
///
/// Feature: session statistics tracker.
/// This class is a pure Dart model — no Flutter dependency — so it can be
/// unit-tested independently and later serialised to shared_preferences
/// for persistence without changing any ViewModel or View code.
class GameStats {
  int gamesPlayed;
  int gamesWon;
  int totalGuessesOnWins; // used to derive averageGuesses
  int currentStreak;
  int bestStreak;

  GameStats({
    this.gamesPlayed = 0,
    this.gamesWon = 0,
    this.totalGuessesOnWins = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
  });

  // ── Derived properties ────────────────────────────────────────────────────

  int get gamesLost => gamesPlayed - gamesWon;

  double get winRate => gamesPlayed == 0 ? 0.0 : gamesWon / gamesPlayed;

  double get averageGuesses =>
      gamesWon == 0 ? 0.0 : totalGuessesOnWins / gamesWon;

  // ── Mutating methods ──────────────────────────────────────────────────────

  /// Records a won round, updating all relevant fields atomically.
  void recordWin(int guessCount) {
    gamesPlayed++;
    gamesWon++;
    totalGuessesOnWins += guessCount;
    currentStreak++;
    if (currentStreak > bestStreak) bestStreak = currentStreak;
  }

  /// Records a lost round, resetting the current streak.
  void recordLoss() {
    gamesPlayed++;
    currentStreak = 0;
  }
}
