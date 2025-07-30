# 📖 BookMark Bites - Recipe Discovery App

BookMark Bites is a beautifully designed, feature-rich recipe discovery application built with Flutter. It's a portfolio piece created to showcase a wide range of modern, professional Flutter development practices, from a clean, scalable architecture to a polished UI/UX with delightful animations.

The app allows users to browse recipes from TheMealDB API, view detailed instructions and ingredients, and save their favorites for robust offline access.

### 🎥 Live Demo / Showcase

*`(This is the most important visual! Replace the placeholder below with a high-quality GIF or screen recording of your app in action. A great recording shows the fluid navigation and animations.)`*

`[YOUR_SCREEN_RECORDING_HERE]`

---

## ✨ Features

BookMark Bites is built to be a complete and professional user experience, focusing on both functionality and design.

| Feature                        | Description                                                                                                                                                             | Screenshot                                                                                                                                                             |
| ------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Clean, Modern UI**           | A custom-designed theme with elegant typography (`Playfair Display` & `Montserrat`) and a professional color palette creates a unique and memorable visual identity.          | <img src="https://github.com/user-attachments/assets/c7bee09f-465d-4b70-97a5-555bfbcba63c" alt="Home Screen" width="250"/>                                             |
| **Offline-First Database**     | Save your favorite recipes and view them anytime, even without an internet connection. Powered by a robust local **Drift (SQLite)** database.                               | <img src="https://github.com/user-attachments/assets/a7d0f5ec-9000-4ed7-ae7a-46e6b3259af5" alt="Offline Favorites" width="250"/>                                        |
| **Connectivity Awareness**     | The UI gracefully handles offline states. Instead of errors, it guides the user to accessible content, demonstrating a thoughtful and resilient user experience.             | <img src="https://github.com/user-attachments/assets/aaa84210-9074-44b7-9892-47c8f3afd4de" alt="Offline Home Screen" width="250"/>                                   |
| **Full Authentication Flow**   | Secure user sign-up and login powered by **Firebase Authentication**. Critical actions like signing out are protected by a confirmation dialog to prevent accidents.         | <img alt="Screenshot_1753899668" src="https://github.com/user-attachments/assets/cdf3abb2-28e5-4d40-a7da-fd2542eb997f" width="250" />                           |
| **Interactive Discovery**      | Browse recipes by category, view detailed instructions, and explore a dynamic "Trending" section on the home screen. All data is fetched live from TheMealDB API.        | <img src="https://github.com/user-attachments/assets/76518eb8-6931-437f-a24e-5fa3856aa783" alt="Recipe Detail Screen" width="250"/>                                    |
| **Professional Navigation**    | A `ShellRoute` powered by **GoRouter** provides a persistent, animated bottom navigation bar (`GNav`) for a standard and intuitive mobile experience.                          | <img src="https://github.com/user-attachments/assets/af111a9f-a7d6-463f-9518-74401b43fe97" alt="Bottom Navigation" width="250"/>                                        |
---

## 🛠️ Tech Stack & Architecture

This project was built with a modern, scalable, and professional tech stack, emphasizing best practices and clean code.

*   **Framework:** Flutter
*   **Architecture:** Clean, Layered Architecture (Data, Logic, Presentation)
*   **State Management:** Riverpod (with Code Generation using `@riverpod` annotations)
*   **Routing:** GoRouter (for all navigation, including shell routes and protected routes)
*   **Local Database:** Drift (with `sqlite3`) for robust, offline-first data persistence.
*   **Backend:** Firebase (Authentication)
*   **Networking:** Dio
*   **Data Modeling:** Freezed
*   **UI/UX:**
    *   **Animation:** `flutter_animate`, `Hero` Widget
    *   **Typography:** `google_fonts`
    *   **UI State:** `flutter_hooks` & `hooks_riverpod`
    *   **Navigation:** `google_nav_bar`
    *   **Image Caching:** `cached_network_image`
*   **Connectivity:** `connectivity_plus`

---

## 🚀 Getting Started

To run this project locally, follow these steps:

### 1. Prerequisites

*   You must have Flutter installed on your machine.
*   You must have a Firebase project.

### 2. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPOSITORY_NAME.git
cd YOUR_REPOSITORY_NAME
```

### 3. Set Up Firebase

This project uses Firebase for authentication. Because the `firebase_options.dart` file is not committed to the repository (for security reasons), you will need to connect your own Firebase project.

*   Install the FlutterFire CLI if you haven't already:
    ```bash
    dart pub global activate flutterfire_cli
    ```
*   Follow the on-screen instructions to log in to your Google account.
*   Run the configuration command from the root of the project:
    ```bash
    flutterfire configure
    ```
*   Select your Firebase project and follow the prompts. This will generate a new `lib/firebase_options.dart` file for you.
*   In the Firebase Console, go to **Authentication > Sign-in method** and enable the **Email/Password** provider.

### 4. Install Dependencies & Run Code Generation

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### 5. Run the App

```bash
flutter run
```
