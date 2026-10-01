<div align="center">

# 🐱 Purrdle

### A clean, playful Wordle-inspired word guessing game built with Flutter.

<p>
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=600&size=22&pause=1000&center=true&vCenter=true&width=650&lines=Guess+the+word+in+6+tries;Built+with+Flutter+%26+Dart;Simple.+Fast.+Fun." alt="Typing SVG" />
</p>

<p>
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/State%20Management-Provider-6C63FF" alt="Provider" />
  <img src="https://img.shields.io/badge/Platform-Web%20%7C%20Mobile-2ea44f" alt="Platform" />
  <img src="https://img.shields.io/badge/Status-Active-success" alt="Status" />
</p>

<p>
  <a href="#-how-to-play">How to Play</a> •
  <a href="#-features">Features</a> •
  <a href="#-getting-started">Getting Started</a> •
  <a href="#-project-structure">Project Structure</a> •
  <a href="#-roadmap">Roadmap</a>
</p>

</div>

---

## ✨ About Purrdle

**Purrdle** is a Wordle-inspired word puzzle game developed using **Flutter** and **Dart**.

The goal is simple: discover the hidden **five-letter English word** within **six attempts**. After each guess, Purrdle gives colour-coded feedback to help you narrow down the answer.

The project follows a lightweight **MVVM-style architecture** and uses the `provider` package for state management.

---

## 🎮 How to Play

1. Enter a valid **five-letter English word**.
2. Press **Enter** to submit your guess.
3. Each tile changes colour to show how close your guess is.
4. Use the feedback from previous attempts to improve your next guess.
5. You have **six attempts** to discover the hidden word.
6. Guess the word before all attempts are used to win.

### Tile meanings

| Tile | Meaning |
| :---: | --- |
| 🟩 | Correct letter in the **correct position** |
| 🟨 | Correct letter in the **wrong position** |
| ⬜ | Letter is **not present** in the target word |

The on-screen keyboard updates after every guess, making it easier to track which letters have already been tested.

---

## 🎥 Gameplay Preview

> Add a GIF or screenshots from your app here to make the repository stand out.

### GIF option

```html
<p align="center">
  <img src="assets/purrdle-demo.gif" width="700" alt="Purrdle Gameplay Demo">
</p>
```

### Screenshot option

```html
<p align="center">
  <img src="assets/screenshots/home.png" width="32%" alt="Home Screen">
  <img src="assets/screenshots/game.png" width="32%" alt="Game Screen">
  <img src="assets/screenshots/stats.png" width="32%" alt="Statistics Screen">
</p>
```

---

## 🚀 Features

- 🎯 Guess a hidden **5-letter word**
- 🔢 Maximum of **6 attempts**
- 📖 Built-in English dictionary
- ✅ Guess validation before submission
- 🚫 Duplicate-guess prevention
- 🟩🟨⬜ Wordle-style tile feedback
- ⌨️ Interactive on-screen keyboard
- 🧠 Correct handling of repeated letters
- 🔁 Start a new game at any time
- 📊 Session statistics
- 🔥 Current and best streak tracking
- 🐱 Cat-inspired visual identity
- 🧪 Unit and widget tests
- 🌐 Flutter Web support
- 📱 Cross-platform Flutter codebase
- 🧩 Clean separation between UI, business logic, and services

---

## 📊 Statistics

Purrdle tracks useful gameplay information during the active session:

| Statistic | Description |
| --- | --- |
| Games Played | Total games started |
| Games Won | Successfully completed games |
| Games Lost | Games where all attempts were used |
| Win Rate | Percentage of games won |
| Average Guesses | Average attempts used in successful games |
| Current Streak | Consecutive wins |
| Best Streak | Highest consecutive-win record |

> **Note:** Statistics currently remain in memory for the active application session.

---

## 🛠️ Tech Stack

| Technology | Purpose |
| --- | --- |
| **Flutter** | Cross-platform UI framework |
| **Dart** | Application language |
| **Provider** | State management |
| **Material Design** | UI components |
| **Flutter Test** | Unit and widget testing |
| **Local Assets** | Dictionary and visual resources |

---

## 🏗️ Architecture

Purrdle follows a lightweight **MVVM-style architecture**.

```text
┌─────────────────────┐
│        Views        │
│ Flutter UI / Widgets│
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│      ViewModel      │
│   GameViewModel     │
│ Game State + Logic  │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│      Services       │
│ Dictionary Service  │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│       Models        │
│ Tiles + Statistics  │
└─────────────────────┘
```

### Model

Contains the core application data structures, including:

- Game tile state
- Guess results
- Game statistics

### ViewModel

`GameViewModel` manages the main game behaviour:

- Starting a new round
- Accepting keyboard input
- Validating guesses
- Comparing guesses with the target
- Processing repeated letters correctly
- Updating keyboard states
- Detecting wins and losses
- Updating statistics

### Services

`DictionaryService` handles:

- Loading the bundled dictionary
- Filtering five-letter words
- Checking whether a guess exists
- Selecting a random target word

### Views

The UI layer contains the:

- Home screen
- Game screen
- Statistics screen
- Game board
- Keyboard
- Reusable widgets and text elements

---

## 📂 Project Structure

```text
purrdle/
│
├── assets/
│   ├── english_dict.txt
│   └── title.png
│
├── lib/
│   ├── main.dart
│   │
│   ├── model/
│   │   ├── game_stats.dart
│   │   └── game_tile.dart
│   │
│   ├── services/
│   │   └── dictionary_service.dart
│   │
│   ├── viewmodel/
│   │   └── game_view_model.dart
│   │
│   └── views/
│       ├── home_screen.dart
│       ├── game_screen.dart
│       ├── stats_screen.dart
│       └── widgets/
│           ├── game_board_widget.dart
│           ├── keyboard_widget.dart
│           └── purrdle_text.dart
│
├── test/
│   ├── game_stats_test.dart
│   ├── game_view_model_test.dart
│   ├── mock_dictionary.dart
│   └── widget_test.dart
│
├── web/
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

---

## ⚙️ Getting Started

### Prerequisites

Install:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Dart SDK — included with Flutter
- Visual Studio Code or Android Studio
- Chrome for Flutter Web

Check your setup:

```bash
flutter doctor
```

---

## 📥 Installation

### 1. Clone the repository

```bash
git clone https://github.com/SULAKSHAN-M/purrdle.git
```

### 2. Enter the project directory

```bash
cd purrdle
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Run the app

```bash
flutter run
```

---

## 🌐 Run on Web

Check available devices:

```bash
flutter devices
```

Run in Chrome:

```bash
flutter run -d chrome
```

Create a production build:

```bash
flutter build web
```

Production files will be generated in:

```text
build/web/
```

---

## 🧪 Testing

Run all tests:

```bash
flutter test
```

The test suite covers:

- Game statistics
- Core gameplay logic
- Dictionary behaviour through mock data
- Flutter widget behaviour

---

## 📦 Main Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.8
  provider: ^6.1.2
```

The project targets Dart SDK `^3.6.0`.

---

## 🎞️ Animation Ideas

To give Purrdle a more polished feel, the UI can use:

- **Tile flip animations** when a guess is evaluated
- **Shake animations** for invalid words
- **Bounce effects** on winning rows
- **Keyboard press feedback**
- **Staggered tile reveals**
- **Confetti on a successful game**
- **Fade/slide transitions** between screens

Useful Flutter animation APIs include:

```text
AnimatedContainer
AnimatedBuilder
AnimationController
Tween
ScaleTransition
FadeTransition
SlideTransition
RotationTransition
```

Example:

```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  child: tile,
)
```

---

## 🗺️ Roadmap

- [ ] Persistent statistics using `shared_preferences`
- [ ] Daily challenge mode
- [ ] Dark mode
- [ ] Difficulty levels
- [ ] Tile flip animations
- [ ] Invalid-word shake animation
- [ ] Win celebration / confetti
- [ ] Sound effects
- [ ] Haptic feedback
- [ ] Shareable results
- [ ] Guess history
- [ ] Improved responsive layout
- [ ] Online leaderboard
- [ ] Player profiles
- [ ] Achievement system

---

## 🔐 Git Ignore Recommendations

Do not commit generated Flutter or IDE files.

```gitignore
.dart_tool/
build/
.idea/
.vscode/
*.iml
.flutter-plugins
.flutter-plugins-dependencies
.packages
```

---

## ⬆️ Upload to GitHub

For the first upload:

```bash
git init
git add .
git commit -m "Initial commit: Purrdle Flutter word game"
git branch -M main
git remote add origin https://github.com/SULAKSHAN-M/purrdle.git
git push -u origin main
```

If `origin` already exists:

```bash
git remote set-url origin https://github.com/SULAKSHAN-M/purrdle.git
git push -u origin main
```

---

## 🤝 Contributing

Contributions, suggestions, and bug reports are welcome.

1. Fork the repository.
2. Create a feature branch.

```bash
git checkout -b feature/your-feature
```

3. Commit your changes.

```bash
git commit -m "Add new feature"
```

4. Push the branch.

```bash
git push origin feature/your-feature
```

5. Open a Pull Request.

---

## ☕ Buy Me a Coffee

If you enjoy **Purrdle** or find the project useful, you can support future development.

<div align="center">

<a href="https://www.buymeacoffee.com/YOUR-BUYMEACOFFEE-USERNAME">
  <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="50" alt="Buy Me a Coffee">
</a>

</div>

> Replace `YOUR-BUYMEACOFFEE-USERNAME` with your actual Buy Me a Coffee username.

---

## 👨‍💻 Author

<div align="center">

### Sulakshan M

Software Engineering Undergraduate • Flutter Developer • Full-Stack Developer

<a href="https://github.com/SULAKSHAN-M">
  <img src="https://img.shields.io/badge/GitHub-SULAKSHAN--M-181717?logo=github&logoColor=white" alt="GitHub">
</a>

</div>

---

## ⭐ Support the Project

If you find **Purrdle** useful:

- Give the repository a ⭐
- Fork the project
- Share it with other Flutter developers
- Suggest improvements through GitHub Issues

<div align="center">

### Thanks for checking out Purrdle 🐾

<img src="https://capsule-render.vercel.app/api?type=waving&height=120&section=footer&text=Happy%20Guessing!&fontSize=26" width="100%" alt="Footer">

</div>
