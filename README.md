<div align="center">
  <h1>🔢 Number Master - Flutter Game 🚀</h1>
  
  <p>
    <a href="https://pub.dev/packages/flutter_bloc">
      <img src="https://img.shields.io/badge/State%20Management-BLoC-blue.svg?style=for-the-badge&logo=flutter" alt="BLoC State Management">
    </a>
    <img src="https://img.shields.io/badge/Platform-Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Built with Flutter">
    <img src="https://img.shields.io/github/v/release/your-org/number-master?style=for-the-badge&include_prereleases" alt="Latest Release">
    <img src="https://img.shields.io/github/license/your-org/number-master?style=for-the-badge&color=important" alt="License">
    <img src="https://img.shields.io/github/contributors/your-org/number-master?style=for-the-badge" alt="Contributors">
  </p>
</div>

---

## ✨ Project Summary

A challenging **number-matching puzzle game** built with Flutter, featuring advanced game mechanics, robust state management, and enhanced difficulty scaling. The goal is to match numbers that are either **equal** or **sum to 10** across complex adjacency rules.

### 🎥 Live Demo (Animation Requirement Met)

Here's a quick look at the game in action:

https://github.com/user-attachments/assets/e668671d-a5cd-413e-8e82-1ae5d9a4e77c

---

## 🛠️ Tech Stack & Architecture

This project leverages cutting-edge tools to ensure a scalable and maintainable codebase.

| Category | Technology | Description |
| :--- | :--- | :--- |
| **Framework** | <img src="https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Flutter Badge"/> | Cross-platform UI toolkit for building beautiful, natively compiled applications. |
| **Language** | <img src="https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white" alt="Dart Badge"/> | Optimized for client-side development. |
| **State Management** | <img src="https://img.shields.io/badge/BLoC-lightgrey?style=flat-square&logo=flutter&logoColor=white" alt="BLoC Badge"/> | Utilized `flutter_bloc` for event-driven, reactive state handling. |
| **Testing** | <img src="https://img.shields.io/badge/Unit%20Tests-Test-green?style=flat-square" alt="Testing Badge"/> | Comprehensive unit and widget testing. |

### 🏗️ Design Patterns

* **BLoC Pattern**: For reactive, clean separation between UI and business logic.
* **Event-Driven Architecture**: Ensures predictable state transitions.
* **Immutable State**: Game state (`GameState`) is immutable, improving debuggability.

---

## 🚀 Getting Started: Installation & Setup Instructions

To get a local copy up and running, follow these simple steps.

### Prerequisites
* **Flutter SDK**: Latest stable version (e.g., `3.x.x`).
* **Dart SDK**: Included with Flutter.
* **IDE**: Android Studio or VS Code with Flutter extensions.

### Installation

1.  **Clone the Repository:**
    ```bash
    git clone (https://github.com/your-org/number-master.git)
    cd number-master
    ```

2.  **Get Dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the App (Debug):**
    ```bash
    flutter run
    ```
    *(To build a release version, use: `flutter build apk` or `flutter build ios`)*

---

## 🧠 Core Game Logic & Features

The game is powered by a robust **`NumberMasterLogic`** engine.

### 1. Advanced Matching Rules (The Challenge)
The `isValidPair` function includes complex validation:
* **Value Matching**: Equal or Sum to 10.
* **Adjacency**: Horizontal, Vertical, and **Diagonal Adjacency**.
* **Connections**: **Diagonal connections** through empty cells with path validation.
* **Wrapping**: **Row wrapping** from end of row to start of next row.

### 2. Robust State Management (Undo/Redo)
* **`GameState`**: Comprehensive class for state tracking.
* **History**: A `gameHistory` list (default size: 50 states) allows instant **Undo** and **Redo** functionality.

### 3. Dynamic Difficulty Scaling
Difficulty increases progressively per level:
* **Adaptive Targets**: `targetMatches` calculated as **60% of board cells**.
* **Larger Grids**: Enhanced `generateRandomBoard()` with **80% fill rate**.
* **Strategic Number Distribution**: Weighted generation favoring challenging combinations.

### 4. Technical Implementation Highlights
| Feature | Description |
| :--- | :--- |
| **Board Representation** | Flexible Grid System with efficient Index Mapping. |
| **Pair Validation** | Comprehensive validation to ensure no self-matching and adherence to all adjacency rules. |
| **Hint System** | `getHint()` finds all possible valid pairs and returns the first available match. |

---

## 🤝 Contribution Guidelines (Developer-Friendly)

We welcome contributions! Please follow these steps to ensure a smooth merging process.

### ⚠️ Disclaimer: Always Pull Latest Updates!
> **IMPORTANT:** **Always pull the latest updates** (`git pull origin main`) before creating your feature branch and starting work to prevent merge conflicts.

### Pull Request Policy (Video Before PR)

Before raising a Pull Request (PR), you **MUST** adhere to the following:

1.  **Code Quality**: Ensure all code is formatted (`dart format .`) and follows project conventions.
2.  **Video Demonstration**: **Share a short video demo** (Screen Recording/GIF) of the updated feature or README changes *before* opening the PR.
    * *Add the video link in your draft PR description or share it directly with the reviewer.*
3.  **Clean Commit History**: Squash trivial commits into logical units.

### Contribution Steps

1.  **Fork** the repository.
2.  **Create a new branch**: `git checkout -b feature/your-feature-name`
3.  **Commit** your changes: `git commit -m "feat: descriptive commit message"`
4.  **Push** to your fork: `git push origin feature/your-feature-name`
5.  **Open a Pull Request** (after fulfilling the Video Demonstration requirement above).

---

**Latest Changes (v1.2.0):**
* **Enhanced Game Logic**: Added diagonal connection path validation.
* **Refactor**: Migrated score tracking to dedicated `ScoreSystem`.
* **Fix**: Corrected a bug in the cell deselection mechanism.

---
