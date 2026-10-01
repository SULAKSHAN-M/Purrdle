import 'package:purrdle/services/dictionary_service.dart';

/// A controllable mock of DictionaryService for use in unit tests.
/// Avoids file system access and allows full control over the word list
/// and the word returned by randomWord().
class MockDictionary implements DictionaryService {
  final List<String> words;
  final String fixedWord;

  MockDictionary({required this.words, required this.fixedWord});

  @override
  bool get isLoaded => true;

  @override
  Future<void> load() async {} // no-op — words already set

  @override
  bool isValid(String word) => words.contains(word.toLowerCase());

  @override
  String randomWord() => fixedWord;
}
