import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purrdle/model/game_tile.dart';
import 'package:purrdle/viewmodel/game_view_model.dart';

/// Renders the 6×5 grid of letter tiles.
///
/// Refactor: extracted from the inline List.generate() inside the original
/// game_screen.dart build() method.
/// Provider: reads GameViewModel via context.watch() so it rebuilds
/// automatically whenever the ViewModel calls notifyListeners(), without
/// needing the parent GameScreen to pass state down manually.
class GameBoardWidget extends StatelessWidget {
  const GameBoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GameViewModel>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(GameViewModel.maxGuesses, (row) => _buildRow(vm, row)),
    );
  }

  Widget _buildRow(GameViewModel vm, int rowIndex) {
    final List<GameTile> tiles = rowIndex < vm.guesses.length
        ? vm.evaluateGuess(vm.guesses[rowIndex])
        : List.filled(GameViewModel.wordLength, const GameTile());

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(GameViewModel.wordLength, (col) => _buildTile(tiles[col])),
    );
  }

  Widget _buildTile(GameTile tile) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: tile.status.color,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.black26),
      ),
      child: Text(
        tile.letter.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
