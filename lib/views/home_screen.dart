import 'package:flutter/material.dart';
import 'package:purrdle/views/game_screen.dart';
import 'package:purrdle/views/widgets/purrdle_text.dart';

/// The landing screen showing the title, cat image, blurb, and Play button.
///
/// Refactor: extracted from main.dart into its own file.
/// main.dart should serve only as the application entry point.
/// Fix: replaced all inline Text+TextStyle with the existing PurrdleText widget
/// (HomeScreen was not using it consistently in the original).
/// Fix: added const to constructor (lint: prefer_const_constructors_in_immutables).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Refactor: was inline Text+TextStyle in original
            const PurrdleText('Purrdle', size: 48.0),
            Center(
              child: Image.asset('assets/title.png', width: 200),
            ),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: PurrdleText(
                'Guess the hidden five-letter word in just six Meows (tries)! '
                'After each guess, tiles will light up: green means the letter '
                'is in the right spot, yellow means the letter is in the word '
                'but in the wrong spot, and grey means the letter is not in the '
                'word at all.',
                size: 14.0,
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GameScreen()),
              ),
              // Refactor: was inline Text+TextStyle in original
              child: const PurrdleText('Play Game', size: 24.0),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
