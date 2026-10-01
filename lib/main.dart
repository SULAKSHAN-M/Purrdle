import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purrdle/viewmodel/game_view_model.dart';
import 'package:purrdle/services/dictionary_service.dart';
import 'package:purrdle/views/home_screen.dart';

void main() {
  runApp(const PurrdleApp());
}

/// Root application widget.
///
/// Refactor: wraps the entire widget tree in a ChangeNotifierProvider so that
/// GameViewModel is accessible to any descendant via context.watch() or
/// context.read() — the standard Flutter MVVM pattern with provider.
///
/// GameViewModel is created here with DictionaryService injected via its
/// constructor, keeping the service independent and mockable in tests.
class PurrdleApp extends StatelessWidget {
  const PurrdleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameViewModel(DictionaryService()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Purrdle',
        theme: ThemeData(primarySwatch: Colors.pink),
        home: const HomeScreen(),
      ),
    );
  }
}
