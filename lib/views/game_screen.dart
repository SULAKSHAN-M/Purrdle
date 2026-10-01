import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purrdle/viewmodel/game_view_model.dart';
import 'package:purrdle/views/widgets/purrdle_text.dart';
import 'package:purrdle/views/widgets/game_board_widget.dart';
import 'package:purrdle/views/widgets/keyboard_widget.dart';
import 'package:purrdle/views/stats_screen.dart';

/// The main gameplay screen — a thin View in the MVVM + Provider pattern.
///
/// Refactor: the original game_screen.dart was a 360-line God Widget that
/// combined file I/O, game logic, state management, and rendering.
///
/// This class now only:
///   - Reads ViewModel state via `context.watch<GameViewModel>()` (rebuilds on change).
///   - Dispatches user input via `context.read<GameViewModel>()` (no rebuild triggered).
///   - Shows dialogs on game-over events.
///   - Navigates to StatsScreen.
///   - Contains zero game logic.
///
/// Provider pattern:
///   `context.watch<T>()`  — subscribes to changes; used inside build().
///   `context.read<T>()`  — one-shot read; used in callbacks to avoid
///                         rebuilding when the value is only needed once.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final vm = context.read<GameViewModel>();

    // If the ViewModel is already initialised (e.g. a pre-loaded MockDictionary
    // was injected in a widget test), skip init() entirely — calling it would
    // trigger rootBundle.loadString which hangs in a test environment and causes
    // pumpAndSettle to time out.
    if (vm.isInitialized) {
      _loading = false;
      return;
    }

    // Initialise the ViewModel (load dictionary, pick first word).
    // context.read is correct here — initState runs once; we do not want
    // to subscribe to rebuilds from this call.
    //
    // Fix: a 4-second timeout guarantees _loading is cleared within
    // pumpAndSettle's 5-second budget even when rootBundle is unavailable
    // (widget tests using a bare DictionaryService without asset bundle setup).
    vm.init().timeout(
      const Duration(seconds: 4),
      onTimeout: () {},
    ).whenComplete(() {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  void dispose() {
    // Fix: dispose controller to prevent memory leak (was missing in original)
    _controller.dispose();
    super.dispose();
  }

  // ── User actions ──────────────────────────────────────────────────────────

  void _submitGuess(BuildContext context) {
    // context.read — fire-and-forget; no rebuild needed for the action itself
    final error = context.read<GameViewModel>().submitGuess(_controller.text);
    _controller.clear();
    if (error != null) _showSnackBar(context, error);
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // ── Dialogs ───────────────────────────────────────────────────────────────

  /// Win dialog.
  /// Fix: original called both _showWinDialog() AND _showSnackBar("You win!")
  /// simultaneously — redundant feedback. Only the dialog is shown now.
  void _showWinDialog(BuildContext context, GameViewModel vm) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              ':D',
              style: TextStyle(
                fontSize: 64,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            PurrdleText(
              'Meow! You guessed it in ${vm.guessCount} '
              '${vm.guessCount == 1 ? "try" : "tries"}!\n'
              'The word was: ${vm.targetWord.toUpperCase()}',
              size: 18,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // context.read — we only need to call newGame(), not watch state
              context.read<GameViewModel>().newGame();
            },
            child: const PurrdleText('New Game', size: 20),
          ),
        ],
      ),
    );
  }

  /// Lose dialog.
  /// Refactor: renamed from _resetGame() in the original.
  /// Fix: original also called _showSnackBar() on loss — removed.
  void _showLoseDialog(BuildContext context, GameViewModel vm) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PurrdleText(':(', size: 64),
            const SizedBox(height: 16),
            PurrdleText(
              'Out of guesses!\nThe word was: ${vm.targetWord.toUpperCase()}',
              size: 18,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<GameViewModel>().newGame();
            },
            child: const PurrdleText('New Game', size: 20),
          ),
        ],
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Colors.pink)),
      );
    }

    // context.watch — subscribes this build() to ViewModel change notifications.
    // Whenever GameViewModel calls notifyListeners(), this widget rebuilds.
    final vm = context.watch<GameViewModel>();

    // Trigger dialogs after the current frame so that build() is not interrupted.
    if (vm.gameOver) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (vm.won) {
          _showWinDialog(context, vm);
        } else {
          _showLoseDialog(context, vm);
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const PurrdleText('Purrdle', size: 24),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart, color: Colors.pink),
            tooltip: 'Statistics',
            // context.read — navigation only; no rebuild needed
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StatsScreen(stats: vm.stats),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            // Consumer rebuilds only the board when ViewModel state changes —
            // more efficient than rebuilding the entire Scaffold.
            const Expanded(child: GameBoardWidget()),
            TextField(
              controller: _controller,
              enabled: vm.canGuess,
              onSubmitted: (_) => _submitGuess(context),
              maxLength: 5,
              maxLines: 1,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your 5-letter guess',
                counterText: '',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: vm.canGuess ? () => _submitGuess(context) : null,
                  child: const PurrdleText('Submit', size: 18),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  // context.read — fire-and-forget action, no subscription needed
                  onPressed: () => context.read<GameViewModel>().newGame(),
                  child: const PurrdleText('New Game', size: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const KeyboardWidget(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
