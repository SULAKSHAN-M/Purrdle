🐱 Purrdle
Purrdle is a Wordle-inspired word puzzle game built with Flutter and Dart. Players have six attempts to discover a hidden five-letter English word, with colour-coded feedback after every guess.
The project uses a clean MVVM-style architecture with the provider package for state management, a dedicated dictionary service for validation and random word selection, and separate model, view, and view-model layers.
✨ Features
- 🎯 Guess a hidden 5-letter word in up to 6 attempts
- 📖 Built-in English dictionary loaded from a local asset
- ✅ Validates guesses before accepting them
- 🚫 Prevents duplicate guesses
- 🟩 Green — correct letter in the correct position
- 🟨 Yellow — correct letter in the wrong position
- ⬜ Grey — letter is not in the target word
- ⌨️ On-screen keyboard with live letter-status feedback
- 🔁 Start a new game at any time
- 🧠 Correct handling of repeated/duplicate letters
- 📊 Session statistics including:
  - Games played
  - Games won
  - Games lost
  - Win rate
  - Average guesses on wins
  - Current streak
  - Best streak
- 🐱 Cat-themed interface and game messages
- 🧪 Unit and widget tests included
- 🌐 Flutter Web support
🖼️ Gameplay
Players enter a five-letter word and submit it as a guess. Purrdle compares the guess with the hidden word and updates each tile:
Tile	Meaning
🟩 Green	The letter is correct and in the correct position
🟨 Yellow	The letter exists in the word but is in the wrong position
⬜ Grey	The letter is not present in the target word


The same information is reflected on the on-screen keyboard to help narrow down future guesses.
🛠️ Tech Stack
Technology	Purpose
Flutter	Cross-platform UI framework
Dart	Application programming language
Provider	State management and dependency access
Material Design	UI components and styling
Flutter Test	Unit and widget testing


🏗️ Architecture
Purrdle follows a lightweight MVVM-style architecture:
lib/
├── main.dart
├── model/
│   ├── game_stats.dart
│   └── game_tile.dart
├── services/
│   └── dictionary_service.dart
├── viewmodel/
│   └── game_view_model.dart
└── views/
    ├── home_screen.dart
    ├── game_screen.dart
    ├── stats_screen.dart
    └── widgets/
        ├── game_board_widget.dart
        ├── keyboard_widget.dart
        └── purrdle_text.dart
Model
Stores the application's data structures, including tile states and game statistics.
ViewModel
GameViewModel contains the core game logic, such as:
- Starting a new round
- Validating and submitting guesses
- Evaluating letter positions
- Updating keyboard states
- Detecting wins and losses
- Updating session statistics
Services
DictionaryService is responsible for:
- Loading the bundled word dictionary
- Filtering five-letter words
- Validating guesses
- Selecting a random target word
Views
Flutter widgets render the home screen, game board, keyboard, statistics, dialogs, and other visual elements.
📂 Project Structure
purrdle/
├── assets/
│   ├── english_dict.txt
│   └── title.png
├── lib/
│   ├── model/
│   ├── services/
│   ├── viewmodel/
│   ├── views/
│   └── main.dart
├── test/
│   ├── game_stats_test.dart
│   ├── game_view_model_test.dart
│   ├── mock_dictionary.dart
│   └── widget_test.dart
├── web/
├── analysis_options.yaml
├── pubspec.yaml
└── README.md
🚀 Getting Started
Prerequisites
Make sure you have the following installed:
- Flutter SDK
- Dart SDK — included with Flutter
- Visual Studio Code or Android Studio
- Chrome if you want to run the web version
Check your Flutter installation:
flutter doctor
📥 Installation
1. Clone the repository
git clone https://github.com/YOUR-USERNAME/purrdle.git
2. Open the project
cd purrdle
3. Install dependencies
flutter pub get
4. Run the application
flutter run
🌐 Run on Web
Check available devices:
flutter devices
Run Purrdle in Chrome:
flutter run -d chrome
Create a production web build:
flutter build web
The generated production files will be available inside:
build/web/
🧪 Testing
Run all tests with:
flutter test
The project includes tests for game statistics, game logic, dictionary behaviour through mocks, and UI/widget behaviour.
🎮 Game Rules
1. A random five-letter word is selected from the bundled dictionary.
2. Enter a valid five-letter English word.
3. Submit the guess.
4. Use the colour feedback to improve the next guess.
5. You have a maximum of six attempts.
6. Guess the target word before the attempts run out to win.
📊 Statistics
Purrdle tracks statistics for the current application session:
- Games played
- Games won
- Games lost
- Win percentage
- Average number of guesses for successful games
- Current winning streak
- Best winning streak
Note: The current version keeps statistics in memory for the active session. They are reset when the application is restarted.

📦 Main Dependency
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  provider: ^6.1.2
The project currently targets Dart SDK ^3.6.0.
🔒 GitHub Upload Notes
Do not commit generated Flutter/IDE files such as .dart_tool/, build/, or local editor configuration unless intentionally required.
A standard Flutter .gitignore should exclude generated files before uploading the repository.
Useful commands:
git init
git add .
git commit -m "Initial commit: Purrdle Flutter word game"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/purrdle.git
git push -u origin main
🔮 Possible Future Improvements
- Persistent statistics using shared_preferences
- Daily challenge mode
- Difficulty levels
- Dark mode
- Shareable results
- Guess history
- Animations for tile reveals
- Sound effects
- Haptic feedback on mobile
- Improved responsive layout for desktop and tablets
- Online leaderboard
🤝 Contributing
Contributions, bug reports, and feature suggestions are welcome.
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push the branch
5. Open a pull request
📄 License
This project is intended for educational and portfolio purposes. Add an appropriate open-source license if you plan to distribute or accept public contributions.
👨‍💻 Author
Developed by Sulakshan M.
If you find the project useful, consider giving the repository a ⭐ on GitHub.
