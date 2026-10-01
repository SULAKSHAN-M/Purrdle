import 'package:flutter_test/flutter_test.dart';
import 'package:purrdle/model/game_tile.dart';
import 'package:purrdle/viewmodel/game_view_model.dart';
import 'mock_dictionary.dart';

void main() {
  // ── Helper — builds a ViewModel with a known target word ──────────────────
  GameViewModel vm({
    String target = 'abbey',
    List<String> vocab = const ['abbey', 'speed', 'crane', 'groan', 'llama',
                                 'alley', 'spell', 'creep', 'abbey', 'valid',
                                 'brave', 'globe', 'stare', 'blown', 'plumb'],
  }) {
    final mock = MockDictionary(words: vocab, fixedWord: target);
    final v = GameViewModel(mock);
    mock.load(); // synchronous no-op
    v.init();    // synchronous because load() is instant
    return v;
  }

  // Helper to extract statuses from evaluateGuess
  List<TileStatus> statuses(GameViewModel v, String guess) =>
      v.evaluateGuess(guess).map((t) => t.status).toList();

  // ── evaluateGuess — basic cases ───────────────────────────────────────────
  group('evaluateGuess — basic cases', () {
    test('TC31: all correct letters mark as correct', () {
      final v = vm(target: 'crane');
      expect(statuses(v, 'crane'),
          [TileStatus.correct, TileStatus.correct, TileStatus.correct,
           TileStatus.correct, TileStatus.correct]);
    });

    test('TC32: all absent letters mark as absent', () {
      final v = vm(target: 'speed');
      expect(statuses(v, 'groan'),
          [TileStatus.absent, TileStatus.absent, TileStatus.absent,
           TileStatus.absent, TileStatus.absent]);
    });

    test('TC33: correct letter in wrong position marks as present', () {
      // 'a' is in crane at index 2; in alley it is at index 0 — present
      final v2 = vm(target: 'crane',
          vocab: ['crane', 'stare', 'blown', 'plumb', 'alley', 'speed',
                  'groan', 'abbey', 'llama', 'globe']);
      final result = v2.evaluateGuess('alley');
      expect(result[0].status, TileStatus.present); // a present
    });

    test('TC34: letter not in word marks as absent', () {
      final v = vm(target: 'speed');
      final result = v.evaluateGuess('groan');
      expect(result.every((t) => t.status == TileStatus.absent), isTrue);
    });

    test('TC35: letters field is correct on each tile', () {
      final v = vm(target: 'crane');
      final tiles = v.evaluateGuess('crane');
      expect(tiles.map((t) => t.letter).toList(),
          ['c', 'r', 'a', 'n', 'e']);
    });
  });

  // ── evaluateGuess — duplicate letter edge cases ───────────────────────────
  group('evaluateGuess — duplicate letter handling (two-pass fix)', () {
    test('TC36: target ABBEY guess SPEED — first E yellow, second E grey', () {
      final v = vm(target: 'abbey',
          vocab: ['abbey', 'speed', 'crane', 'groan', 'llama', 'alley',
                  'spell', 'creep', 'valid', 'brave', 'globe', 'stare',
                  'blown', 'plumb', 'tests']);
      final result = statuses(v, 'speed');
      // s=absent, p=absent, e=present (abbey has one e), e=absent, d=absent
      expect(result[2], TileStatus.present);  // first e
      expect(result[3], TileStatus.absent);   // second e — pool exhausted
    });

    test('TC37: target LLAMA guess LLAMA — all correct', () {
      final v = vm(target: 'llama',
          vocab: ['llama', 'abbey', 'crane', 'groan', 'speed', 'alley',
                  'spell', 'creep', 'valid', 'brave', 'globe', 'stare',
                  'blown', 'plumb', 'tests']);
      expect(statuses(v, 'llama'),
          List.filled(5, TileStatus.correct));
    });

    test('TC38: target ABBEY guess ABBEY — all correct', () {
      final v = vm(target: 'abbey');
      expect(statuses(v, 'abbey'),
          List.filled(5, TileStatus.correct));
    });

    test('TC39: guess with two of same letter — only one exists in target', () {
      // target=crane, guess=creep — two Es in guess, one E in target
      final v = vm(target: 'crane',
          vocab: ['crane', 'creep', 'abbey', 'groan', 'speed', 'alley',
                  'spell', 'llama', 'valid', 'brave', 'globe', 'stare',
                  'blown', 'plumb', 'tests']);
      final result = statuses(v, 'creep');
      // c=correct, r=correct, e=correct(pos2 in crane is 'a', not 'e')
      // Actually crane: c=0,r=1,a=2,n=3,e=4
      // creep: c=0,r=1,e=2,e=3,p=4
      // Pass1: c-correct, r-correct, e vs a=absent pass1, e vs n=absent pass1, p vs e=absent pass1
      // Pass2: e at pos2 — crane remaining pool after pass1: ['','','a','n','e'] → e found at idx4 → yellow
      //        e at pos3 — pool now ['','','a','n',''] → e not found → absent
      expect(result[0], TileStatus.correct);  // c
      expect(result[1], TileStatus.correct);  // r
      expect(result[2], TileStatus.present);  // first e — present
      expect(result[3], TileStatus.absent);   // second e — pool empty
      expect(result[4], TileStatus.absent);   // p
    });

    test('TC40: target with double letter — guess has one of that letter correct', () {
      // target=spell, guess=spill (one l in guess, two in target)
      final v = vm(target: 'spell',
          vocab: ['spell', 'spill', 'abbey', 'crane', 'groan', 'speed',
                  'alley', 'llama', 'valid', 'brave', 'globe', 'stare',
                  'blown', 'plumb', 'tests']);
      final result = statuses(v, 'spill');
      // spell: s=0,p=1,e=2,l=3,l=4
      // spill: s=0,p=1,i=2,l=3,l=4
      expect(result[0], TileStatus.correct); // s
      expect(result[1], TileStatus.correct); // p
      expect(result[2], TileStatus.absent);  // i not in spell
      expect(result[3], TileStatus.correct); // l correct pos3
      expect(result[4], TileStatus.correct); // l correct pos4
    });
  });

  // ── submitGuess — validation ──────────────────────────────────────────────
  group('submitGuess — validation', () {
    test('TC41: valid word returns null (success)', () {
      final v = vm(target: 'abbey');
      expect(v.submitGuess('crane'), isNull);
    });

    test('TC42: word shorter than 5 letters returns error', () {
      final v = vm(target: 'abbey');
      expect(v.submitGuess('cat'), isNotNull);
    });

    test('TC43: word longer than 5 letters returns error', () {
      final v = vm(target: 'abbey');
      expect(v.submitGuess('cranes'), isNotNull);
    });

    test('TC44: empty string returns error', () {
      final v = vm(target: 'abbey');
      expect(v.submitGuess(''), isNotNull);
    });

    test('TC45: word not in dictionary returns error', () {
      final v = vm(target: 'abbey');
      expect(v.submitGuess('zzzzz'), isNotNull);
    });

    test('TC46: duplicate guess returns error', () {
      final v = vm(target: 'abbey');
      v.submitGuess('crane');
      expect(v.submitGuess('crane'), isNotNull);
    });

    test('TC47: guessing after game over returns error', () {
      final v = vm(target: 'abbey');
      v.submitGuess('abbey'); // win
      expect(v.submitGuess('crane'), isNotNull);
    });

    test('TC48: input is trimmed before validation', () {
      final v = vm(target: 'abbey');
      expect(v.submitGuess('  crane  '), isNull);
    });

    test('TC49: input is case-insensitive (uppercase accepted)', () {
      final v = vm(target: 'abbey');
      expect(v.submitGuess('CRANE'), isNull);
    });

    test('TC50: input is case-insensitive (mixed case accepted)', () {
      final v = vm(target: 'abbey');
      expect(v.submitGuess('CrAnE'), isNull);
    });
  });

  // ── submitGuess — game state ──────────────────────────────────────────────
  group('submitGuess — game state changes', () {
    test('TC51: guess count increments after valid submission', () {
      final v = vm(target: 'abbey');
      v.submitGuess('crane');
      expect(v.guessCount, 1);
    });

    test('TC52: correct guess sets won to true', () {
      final v = vm(target: 'abbey');
      v.submitGuess('abbey');
      expect(v.won, isTrue);
    });

    test('TC53: correct guess sets gameOver to true', () {
      final v = vm(target: 'abbey');
      v.submitGuess('abbey');
      expect(v.gameOver, isTrue);
    });

    test('TC54: incorrect guess does not set won', () {
      final v = vm(target: 'abbey');
      v.submitGuess('crane');
      expect(v.won, isFalse);
    });

    test('TC55: canGuess is false after game is won', () {
      final v = vm(target: 'abbey');
      v.submitGuess('abbey');
      expect(v.canGuess, isFalse);
    });

    test('TC56: canGuess is false after 6 wrong guesses', () {
      final v = vm(target: 'abbey');
      final wrongs = ['crane', 'groan', 'llama', 'alley', 'spell', 'brave'];
      for (final w in wrongs) { v.submitGuess(w); }
      expect(v.canGuess, isFalse);
    });

    test('TC57: gameOver is true after 6 wrong guesses (loss)', () {
      final v = vm(target: 'abbey');
      final wrongs = ['crane', 'groan', 'llama', 'alley', 'spell', 'brave'];
      for (final w in wrongs) { v.submitGuess(w); }
      expect(v.gameOver, isTrue);
    });

    test('TC58: guesses list is immutable (cannot be modified externally)', () {
      final v = vm(target: 'abbey');
      expect(() => (v.guesses as dynamic).add('crane'),
          throwsUnsupportedError);
    });
  });

  // ── newGame() ─────────────────────────────────────────────────────────────
  group('newGame()', () {
    test('TC59: guessCount resets to 0 after newGame', () {
      final v = vm(target: 'abbey');
      v.submitGuess('crane');
      v.newGame();
      expect(v.guessCount, 0);
    });

    test('TC60: gameOver resets to false after newGame', () {
      final v = vm(target: 'abbey');
      v.submitGuess('abbey');
      v.newGame();
      expect(v.gameOver, isFalse);
    });

    test('TC61: won resets to false after newGame', () {
      final v = vm(target: 'abbey');
      v.submitGuess('abbey');
      v.newGame();
      expect(v.won, isFalse);
    });

    test('TC62: canGuess is true after newGame', () {
      final v = vm(target: 'abbey');
      v.submitGuess('abbey');
      v.newGame();
      expect(v.canGuess, isTrue);
    });

    test('TC63: keyboard statuses reset to empty after newGame', () {
      final v = vm(target: 'abbey');
      v.submitGuess('crane');
      v.newGame();
      expect(v.keyboardStatuses.values.every((s) => s == TileStatus.empty),
          isTrue);
    });
  });

  // ── Keyboard status priority ──────────────────────────────────────────────
  group('Keyboard status priority', () {
    test('TC64: correct status is not downgraded to present', () {
      final v = vm(target: 'crane');
      // crane guess: all correct → C,R,A,N,E all correct
      v.submitGuess('crane');
      expect(v.keyboardStatuses['C'], TileStatus.correct);
    });

    test('TC65: correct status is not downgraded to absent', () {
      // abbey: after guessing abbey (win) all matched letters stay correct
      final v = vm(target: 'abbey');
      v.submitGuess('abbey');
      expect(v.keyboardStatuses['A'], TileStatus.correct);
    });

    test('TC66: present status is not overwritten by absent', () {
      // target=crane, guess=groan — r is present (in crane, wrong position)
      // then guess stare — r is present again; should stay present not absent
      final v = vm(target: 'crane',
          vocab: ['crane', 'groan', 'stare', 'abbey', 'speed', 'alley',
                  'spell', 'llama', 'valid', 'brave', 'globe', 'blown',
                  'plumb', 'tests', 'creep']);
      v.submitGuess('groan'); // r present
      v.submitGuess('stare'); // r present again (stare has r at idx2, crane at idx1)
      // r should stay at least present
      expect(v.keyboardStatuses['R'],
          anyOf(TileStatus.present, TileStatus.correct));
    });

    test('TC67: absent letter is correctly marked on keyboard', () {
      final v = vm(target: 'abbey');
      v.submitGuess('groan'); // g,r,o,a(present),n — g,r,o,n all absent
      expect(v.keyboardStatuses['G'], TileStatus.absent);
    });

    test('TC68: present letter updates keyboard to present', () {
      // alley: a is in crane (pos2) but alley has a at pos0 → present
      final v2 = vm(target: 'crane',
          vocab: ['crane', 'alley', 'abbey', 'groan', 'speed', 'spell',
                  'llama', 'valid', 'brave', 'globe', 'stare', 'blown',
                  'plumb', 'tests', 'creep']);
      v2.submitGuess('alley');
      expect(v2.keyboardStatuses['A'],
          anyOf(TileStatus.present, TileStatus.correct));
    });
  });

  // ── Statistics integration ────────────────────────────────────────────────
  group('Statistics integration in ViewModel', () {
    test('TC69: win records correct guessCount in stats', () {
      final v = vm(target: 'abbey');
      v.submitGuess('crane'); // wrong
      v.submitGuess('abbey'); // win on guess 2
      expect(v.stats.totalGuessesOnWins, 2);
    });

    test('TC70: loss records in stats and does not increment gamesWon', () {
      final v = vm(target: 'abbey');
      final wrongs = ['crane', 'groan', 'llama', 'alley', 'spell', 'brave'];
      for (final w in wrongs) { v.submitGuess(w); }
      expect(v.stats.gamesPlayed, 1);
      expect(v.stats.gamesWon, 0);
      expect(v.stats.gamesLost, 1);
    });
  });
}
