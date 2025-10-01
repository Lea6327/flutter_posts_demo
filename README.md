# Flutter Posts Demo

A minimal Flutter app for the **Junior Flutter Developer Technical Assessment**.

---

## Overview

* Fetch posts from a REST API
* List → detail navigation (Hero transition)
* State: **Loading (skeleton)** / **Error + Retry** / **Success**
* **flutter_bloc (Cubit)** for state management
* **Material 3** theme + custom styles
* Unit + widget tests
* Clean architecture (domain / data / presentation)

---

## Run

### Install dependencies
```bash
flutter pub get


**Web（quickest）**

```bash
flutter run -d chrome
```

**iOS（example）**

```bash
open -a Simulator
flutter devices
flutter run -d "iPhone 17"   
```

```

**iOS pods (if needed)**

```bash
cd ios && pod install && cd ..
```

> Open **`ios/Runner.xcworkspace`** in Xcode if running from Xcode.

---

## Libraries

* **Networking:** dio
* **State:** flutter_bloc (Cubit)
* **Share:** share_plus
* **Testing:** flutter_test, mocktail

---

## API

* `GET https://jsonplaceholder.typicode.com/posts`

---

## Architecture

```
lib/
 └─ features/posts/
     ├─ domain/        # entities, abstract repositories, use cases (GetPosts)
     ├─ data/          # dio client, API source, repository implementation
     └─ presentation/  # cubit + UI pages/widgets
theme/                 # Material 3 themes (light/dark)
```

---

## Tests

```bash
flutter test
```

* `test/unit/get_posts_test.dart` — use case unit test
* `test/widget/widget_test.dart` — widget test (success + error/Retry)

---

## App States & Demo

The app shows **three states** via `flutter_bloc`:

### 1) Loading

* Triggered on app start, **Retry**, or pull-to-refresh
* Shows **skeleton placeholders** (no spinner)

### 2) Error + Retry

* On request failure: error icon, message, and a **Retry** button
* **Simulate errors (debug only):**

  * Tap the **bug icon** (top-right) on the Posts screen to toggle *error ↔ normal* (auto-refetch)
  * Or flip in code:

    ```dart
    // lib/features/posts/data/sources/posts_api.dart
    static bool kUseBadPath = true; // simulate error
    ```

    > Changing this static flag requires a **Hot Restart** (`Shift+R`), not just Hot Reload.

### 3) Success

* List of posts (title + body preview)
* **Pull-to-refresh** support
* Tap an item → **detail** screen (Hero transition, share action)

**Quick demo flow:** Start app → tap bug icon → see **Error + Retry** → tap **Retry** → tap bug icon again → list refetches → **Success**.

---

## Useful Commands

```bash
flutter analyze
dart format .
flutter clean && flutter pub get
```

**Hot Reload vs Hot Restart**

* `r` = **Hot Reload**: does **not** re-run static/top-level initializers
* `Shift+R` = **Hot Restart**: resets Dart VM and **does** re-run them (needed for `kUseBadPath`)




