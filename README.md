# Flutter Posts Demo

A minimal Flutter app that fetches posts from JSONPlaceholder and displays them in a list with a details screen. Built with **Dio** for networking and **flutter_bloc (Cubit)** for state management. Uses **Material 3** and includes unit + bloc tests.

## How to run
```bash
flutter pub get
flutter run

Libraries

Networking: Dio

State management: flutter_bloc (Cubit)

Testing: flutter_test, bloc_test, mocktail

Architecture

Clean-ish separation:

data/ (models, API, repository)

presentation/ (Cubit state + UI)

core/ (Dio client)

theme/ (Material 3)

API

GET https://jsonplaceholder.typicode.com/posts

Tests
flutter test


posts_repository_test.dart: verifies repository parses responses.

posts_cubit_test.dart: verifies loading → success/failure flows.

Notes

Handles loading, error (with retry), and success states.

Material 3 theme with colorSchemeSeed.