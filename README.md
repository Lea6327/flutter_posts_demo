# Flutter Posts Demo

A minimal Flutter app built for the **Junior Flutter Developer Technical Assessment**.

---

## ✨ Features

* Fetch posts from a public REST API (`jsonplaceholder.typicode.com/posts`)
* List → detail navigation with **Hero transition**
* Three states: **Loading (skeleton)** / **Error + Retry** / **Success**
* **flutter_bloc (Cubit)** for state management
* **Material 3** theme
* Unit & widget tests
* Clean architecture (domain / data / presentation layers)

---

## 🚀 Run the App

### Install dependencies

```bash
flutter pub get
```

### Run (Web example)

```bash
flutter run -d chrome
```

### Run (iOS example)

```bash
open -a Simulator
flutter devices
flutter run -d "iPhone 17"
```

If pods are needed:

```bash
cd ios && pod install && cd ..
```

Or open `ios/Runner.xcworkspace` in Xcode.

---

## 🛠 Libraries

* Networking: **dio**
* State management: **flutter_bloc (Cubit)**
* Share: **share_plus**
* Testing: **flutter_test**, **mocktail**

---

## 📂 Project Structure

```
lib/
 └─ features/posts/
     ├─ domain/        # entities, repositories, use cases
     ├─ data/          # dio client, API source, repository impl
     └─ presentation/  # cubit + UI pages/widgets
theme/                 # Material 3 themes
```

---

## 🧪 Tests

```bash
flutter test
```

* `test/unit/get_posts_test.dart` → use case unit test
* `test/widget/widget_test.dart` → widget test (success + error/Retry)

---

## 📱 States & Demo

### 1. Loading

* Triggered on app start / Retry / pull-to-refresh
* Shows **skeleton placeholders**

### 2. Error + Retry

* On failure: error icon + message + Retry button
* **Simulate errors (debug only):**

  * Tap the **bug icon** in the top-right
  * Or set `PostsApi.kUseBadPath = true` (requires **Hot Restart**)

### 3. Success

* Shows list of posts (title + preview body)
* Pull-to-refresh support
* Tap → detail page with Hero 

---

## 🔧 Useful Commands

```bash
flutter analyze
dart format .
flutter clean && flutter pub get
```







