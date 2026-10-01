import 'package:flutter/material.dart';
import 'package:purrdle/views/widgets/purrdle_text.dart';
import 'package:purrdle/model/game_stats.dart';

/// Displays all seven session statistics metrics on a full-screen page.
///
/// Feature: session statistics tracker.
/// Accessible via the pink bar-chart icon in the GameScreen AppBar.
/// Uses a Wrap layout so cards reflow naturally on narrow and wide viewports.
class StatsScreen extends StatelessWidget {
  final GameStats stats;

  const StatsScreen({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const PurrdleText('Statistics', color: Colors.white, size: 20),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const PurrdleText('🐱 Game Stats', size: 28),
              const SizedBox(height: 32),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  _StatCard(label: 'Played',         value: '${stats.gamesPlayed}'),
                  _StatCard(label: 'Won',            value: '${stats.gamesWon}'),
                  _StatCard(label: 'Lost',           value: '${stats.gamesLost}'),
                  _StatCard(
                    label: 'Win Rate',
                    value: '${(stats.winRate * 100).toStringAsFixed(0)}%',
                  ),
                  _StatCard(
                    label: 'Avg Guesses',
                    value: stats.gamesWon == 0
                        ? '-'
                        : stats.averageGuesses.toStringAsFixed(1),
                  ),
                  _StatCard(label: 'Best Streak',    value: '${stats.bestStreak}'),
                  _StatCard(label: 'Current Streak', value: '${stats.currentStreak}'),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                child: const PurrdleText('Close', size: 18, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A single metric display card used inside [StatsScreen].
class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.pink.shade200),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Courier',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
