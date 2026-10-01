import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:purrdle/main.dart';
import 'package:purrdle/views/game_screen.dart';
import 'package:purrdle/viewmodel/game_view_model.dart';
import 'package:purrdle/services/dictionary_service.dart';

void main() {
  testWidgets('HomeScreen UI elements remain consistent',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PurrdleApp());

    expect(find.text('Purrdle'), findsOneWidget);
    expect(
      find.textContaining('Guess the hidden five-letter word'),
      findsOneWidget,
    );
    expect(find.byType(Image), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Play Game'), findsOneWidget);
  });

  testWidgets('GameScreen UI elements remain consistent',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 1920));

    // Wrap GameScreen in a ChangeNotifierProvider so it can access GameViewModel
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => GameViewModel(DictionaryService()),
        child: const MaterialApp(home: GameScreen()),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byType(TextField), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Submit'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'New Game'), findsOneWidget);
    expect(find.text('Q'), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
    expect(find.text('Z'), findsOneWidget);

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
    expect(scaffold.backgroundColor, Colors.white);
  });
}
