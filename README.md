# Flutter Posts Demo

A minimal Flutter app built for the **Junior Flutter Developer Technical Assessment**.

## Overview
This project demonstrates:
- Fetching posts from a REST API
- Displaying them in a list with detail pages
- Using **flutter_bloc (Cubit)** for state management
- Handling **loading**, **error + Retry**, and **success** states
- Implementing a **Material 3** theme
- Writing unit and bloc/widget tests
- Clean architecture principles with clear layering

---

## Run
Clone the repo and run:

```bash
flutter pub get

# Web (quick demo)
flutter run -d chrome


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
domain/        # Entities, repositories (abstract), use cases (GetPosts)
data/          # API (Dio), repository implementation
presentation/  # Cubit state + UI pages/widgets
theme/         # Material 3 ThemeData
```

---

## Tests

Run all tests:

```bash
flutter test
```

Test files:

* `domain/get_posts_test.dart`: unit test for the use case
* `presentation/posts_cubit_test.dart`: bloc tests for loading → success/failure

---

## Demo

The app demonstrates:

1. **Loading** indicator while fetching
2. **Error + Retry** on failures (Retry triggers reload)
3. **List → Detail** navigation on success

*(Optional) Add a `demo.gif` here to showcase the flow*

---

## Notes

* Comments have been added throughout the code for clarity.
* A short artificial delay (400–800ms) is included in `PostsCubit` to ensure the loading indicator is visible.
* For production, this delay can be removed or reduced.

