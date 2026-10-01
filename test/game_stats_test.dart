import 'package:flutter_test/flutter_test.dart';
import 'package:purrdle/model/game_stats.dart';

void main() {
  // ── Helper ────────────────────────────────────────────────────────────────
  GameStats fresh() => GameStats();

  group('GameStats — initial state', () {
    test('TC01: gamesPlayed starts at 0', () {
      expect(fresh().gamesPlayed, 0);
    });
    test('TC02: gamesWon starts at 0', () {
      expect(fresh().gamesWon, 0);
    });
    test('TC03: gamesLost derived as 0 when no games played', () {
      expect(fresh().gamesLost, 0);
    });
    test('TC04: winRate is 0.0 when no games played', () {
      expect(fresh().winRate, 0.0);
    });
    test('TC05: averageGuesses is 0.0 when no wins recorded', () {
      expect(fresh().averageGuesses, 0.0);
    });
    test('TC06: currentStreak starts at 0', () {
      expect(fresh().currentStreak, 0);
    });
    test('TC07: bestStreak starts at 0', () {
      expect(fresh().bestStreak, 0);
    });
  });

  group('GameStats — recordWin()', () {
    test('TC08: gamesPlayed increments on win', () {
      final s = fresh()..recordWin(3);
      expect(s.gamesPlayed, 1);
    });
    test('TC09: gamesWon increments on win', () {
      final s = fresh()..recordWin(3);
      expect(s.gamesWon, 1);
    });
    test('TC10: gamesLost stays 0 after a win', () {
      final s = fresh()..recordWin(3);
      expect(s.gamesLost, 0);
    });
    test('TC11: totalGuessesOnWins accumulates correctly', () {
      final s = fresh()..recordWin(3)..recordWin(5);
      expect(s.totalGuessesOnWins, 8);
    });
    test('TC12: currentStreak increments on consecutive wins', () {
      final s = fresh()..recordWin(1)..recordWin(1)..recordWin(1);
      expect(s.currentStreak, 3);
    });
    test('TC13: bestStreak updates to highest streak seen', () {
      final s = fresh()..recordWin(1)..recordWin(1)..recordWin(1);
      expect(s.bestStreak, 3);
    });
    test('TC14: bestStreak does not decrease after streak drops', () {
      final s = fresh()..recordWin(1)..recordWin(1)..recordLoss()..recordWin(1);
      expect(s.bestStreak, 2);
    });
    test('TC15: winRate is 1.0 when all games are wins', () {
      final s = fresh()..recordWin(3)..recordWin(4);
      expect(s.winRate, 1.0);
    });
    test('TC16: averageGuesses is correct average across multiple wins', () {
      final s = fresh()..recordWin(2)..recordWin(4);
      expect(s.averageGuesses, 3.0);
    });
    test('TC17: guessCount of 1 is recorded correctly', () {
      final s = fresh()..recordWin(1);
      expect(s.totalGuessesOnWins, 1);
    });
    test('TC18: guessCount of 6 (max) is recorded correctly', () {
      final s = fresh()..recordWin(6);
      expect(s.totalGuessesOnWins, 6);
    });
  });

  group('GameStats — recordLoss()', () {
    test('TC19: gamesPlayed increments on loss', () {
      final s = fresh()..recordLoss();
      expect(s.gamesPlayed, 1);
    });
    test('TC20: gamesWon does not increment on loss', () {
      final s = fresh()..recordLoss();
      expect(s.gamesWon, 0);
    });
    test('TC21: gamesLost increments on loss', () {
      final s = fresh()..recordLoss();
      expect(s.gamesLost, 1);
    });
    test('TC22: currentStreak resets to 0 after a loss', () {
      final s = fresh()..recordWin(1)..recordWin(1)..recordLoss();
      expect(s.currentStreak, 0);
    });
    test('TC23: bestStreak is preserved after streak is broken by loss', () {
      final s = fresh()..recordWin(1)..recordWin(1)..recordLoss();
      expect(s.bestStreak, 2);
    });
    test('TC24: winRate is correct with mixed wins and losses', () {
      final s = fresh()..recordWin(3)..recordLoss()..recordLoss();
      expect(s.winRate, closeTo(1 / 3, 0.001));
    });
    test('TC25: multiple losses in a row accumulate gamesLost correctly', () {
      final s = fresh()..recordLoss()..recordLoss()..recordLoss();
      expect(s.gamesLost, 3);
    });
  });

  group('GameStats — derived properties', () {
    test('TC26: gamesLost = gamesPlayed - gamesWon (mixed)', () {
      final s = fresh()..recordWin(2)..recordLoss()..recordWin(3)..recordLoss();
      expect(s.gamesLost, s.gamesPlayed - s.gamesWon);
    });
    test('TC27: winRate stays 0.0 with only losses', () {
      final s = fresh()..recordLoss()..recordLoss();
      expect(s.winRate, 0.0);
    });
    test('TC28: averageGuesses stays 0.0 with only losses', () {
      final s = fresh()..recordLoss()..recordLoss();
      expect(s.averageGuesses, 0.0);
    });
    test('TC29: averageGuesses rounds correctly for fractional result', () {
      final s = fresh()..recordWin(1)..recordWin(2)..recordWin(3);
      expect(s.averageGuesses, 2.0);
    });
    test('TC30: streak rebuilds correctly after loss', () {
      final s = fresh()
        ..recordWin(1)..recordWin(1)..recordLoss()
        ..recordWin(1)..recordWin(1)..recordWin(1);
      expect(s.currentStreak, 3);
      expect(s.bestStreak, 3);
    });
  });
}
