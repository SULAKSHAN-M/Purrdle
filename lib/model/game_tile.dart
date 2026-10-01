import 'package:flutter/material.dart';

/// Represents the result status of a single letter tile.
///
/// Refactor: extracted from game_screen.dart where colour logic was
/// scattered as raw Color literals throughout _tileColor() and _updateKeyboard().
/// Centralising it here removes magic colour constants from the codebase.
enum TileStatus { empty, correct, present, absent }

/// Maps each [TileStatus] to its display colour.
///
/// Refactor: replaces hardcoded Colors.green / Colors.yellow / Colors.red
/// scattered across the original _tileColor() and _updateKeyboard() methods.
/// Fix: TileStatus.absent now maps to Colors.grey — the original used Colors.red.
extension TileStatusColor on TileStatus {
  Color get color {
    switch (this) {
      case TileStatus.correct:
        return Colors.green;
      case TileStatus.present:
        return Colors.amber;
      // Fix: was Colors.red in the original — spec requires grey for absent letters
      case TileStatus.absent:
        return Colors.grey.shade600;
      case TileStatus.empty:
        return Colors.grey.shade300;
    }
  }
}

/// A single letter tile on the game board, pairing a letter with its status.
///
/// Refactor: extracted from the inline build() logic in game_screen.dart where
/// letter and colour were computed separately on each frame with no named type.
class GameTile {
  final String letter;
  final TileStatus status;

  const GameTile({this.letter = '', this.status = TileStatus.empty});
}
