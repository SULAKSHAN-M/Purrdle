import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purrdle/model/game_tile.dart';
import 'package:purrdle/viewmodel/game_view_model.dart';

/// Displays the on-screen keyboard with colour-coded letter status hints.
///
/// Refactor: extracted from the nested _buildKeyboard() closure inside
/// build() in the original game_screen.dart.
/// Provider: reads GameViewModel via context.watch() so it rebuilds
/// automatically on every ViewModel state change.
/// Fix: colours now use TileStatus.color extension — absent maps to grey,
/// not red as in the original.
class KeyboardWidget extends StatelessWidget {
  const KeyboardWidget({super.key});

  static const List<String> _rows = ['QWERTYUIOP', 'ASDFGHJKL', 'ZXCVBNM'];

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GameViewModel>();
    return Column(
      children: _rows.map((row) => _buildRow(vm, row)).toList(),
    );
  }

  Widget _buildRow(GameViewModel vm, String row) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: row.split('').map((letter) => _buildKey(vm, letter)).toList(),
    );
  }

  Widget _buildKey(GameViewModel vm, String letter) {
    final status = vm.keyboardStatuses[letter] ?? TileStatus.empty;
    return Container(
      margin: const EdgeInsets.all(3.0),
      width: 30,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: status.color,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.black26),
      ),
      child: Text(
        letter,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
