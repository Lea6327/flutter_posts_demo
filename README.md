# Flutter Posts Demo

A minimal Flutter app built for the **Junior Flutter Developer Technical Assessment**.

---

## Overview
This project demonstrates:
- Fetching posts from a REST API
- Displaying them in a list with detail pages
- Using **flutter_bloc (Cubit)** for state management
- Handling **loading**, **error + Retry**, and **success** states
- Implementing a **Material 3** theme
- Writing unit and bloc/widget tests
- Following clean architecture principles with clear layering

---

## Run

Clone the repo and run:

```bash
flutter pub get

# Run on Chrome (quick demo)
flutter run -d chrome

```

---

## Libraries

* **Networking**: Dio  
* **State management**: flutter_bloc (Cubit)  
* **Testing**: flutter_test, bloc_test, mocktail  

---

## API

* `GET https://jsonplaceholder.typicode.com/posts`

---

## Architecture

```
lib/
 └─ features/posts/
     ├─ domain/        # Entities, repositories (abstract), use cases (GetPosts)
     ├─ data/          # API (Dio), repository implementation
     └─ presentation/  # Cubit state + UI pages/widgets
 theme/                # Material 3 ThemeData
```

---

## Tests

Run all tests:

```bash
flutter test
```

Test files:

* `test/unit/get_posts_test.dart`: unit test for the use case  
* `test/widget/posts_page_test.dart`: widget/bloc tests for loading → success/failure  

---

## Demo Flow (App States)

The app demonstrates **three UI states** with `flutter_bloc`:

### 1. Loading State

* When the app starts or user taps **Retry**, the UI shows:

  * A centered `CircularProgressIndicator`
  * A text label: *"Loading posts..."*

---

### 2. Error State + Retry

* If the API request fails (e.g., set `kUseBadPath = true` in `posts_api.dart`), the UI shows:

  * An error icon  
  * The error message (e.g., `DioError: 404 Not Found`)  
  * A **Retry** button to reload  

---

### 3. Success State

* When the API request succeeds:

  * A list of posts (`title` + `body preview`)  
  * Pull-to-refresh support  
  * Tap on a post → navigate to a **detail screen** with full content  

---

## Reproduce Error State

To test the error + retry flow, open `lib/features/posts/data/sources/posts_api.dart` and set:

```dart
static bool kUseBadPath = true;
```

Run the app again, and the request will fail, showing the error UI with a Retry button.

---

## Notes

* Comments are included throughout the code for clarity.  
* A short artificial delay (400–800ms) is added in `PostsCubit` to make the loading indicator visible.  
* For production, this delay can be removed or reduced.  
* Static analysis (`flutter analyze`) and tests are also run automatically on each push/PR via GitHub Actions.
 

---


```

