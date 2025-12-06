# CineWall 🎬

**CineWall** is a modern, immersive movie discovery application built with Flutter. Designed with a "Vertical Cinema" concept (inspired by TikTok/Reels), it offers a seamless and engaging way to browse movies using The Movie Database (TMDB) API.

This project demonstrates the implementation of complex UI interactions, REST API consumption with Dio, and backend integration with Firebase (Authentication & Firestore).

---



## ✨ Features

- **Vertical Infinite Scroll:** Browse movies with a full-screen, snap-scrolling experience (TikTok style).
- **Immersive UI:** High-quality posters with gradient overlays and glassmorphism elements.
- **User Authentication:** Secure Login and Registration system using Firebase Auth.
- **Cloud Watchlist:** Save your favorite movies to Cloud Firestore. Your list is synced across devices and persistent across logins.
- **Smart Search:** Search for any movie using keywords with instant results.
- **Detailed View:** View comprehensive movie details including genres, ratings, release dates, and synopses.
- **State Management:** Clean architecture using native `setState` and `Streams` for real-time data updates.

---

## 🛠️ Tech Stack

- **Framework:** Flutter (Dart)
- **Backend:** Firebase (Auth, Firestore)
- **API:** TMDB API
- **IDE:** VS Code / Android Studio

---

## 📦 Dependencies

- `dio`: For robust HTTP networking and API handling.
- `firebase_core`, `firebase_auth`, `cloud_firestore`: For backend services.
- `cached_network_image`: For efficient image loading and caching.
- `google_fonts`: For modern typography (Poppins).
- `pretty_dio_logger`: For network debugging.

---

## 🚀 Getting Started

Follow these steps to run the project locally.

### Prerequisites

- Flutter SDK installed.
- A TMDB API Key.
- A Firebase Project setup.

### Installation

#### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/cinewall.git
cd cinewall
```

#### 2. Install Dependencies
```bash
flutter pub get
```

#### 3. Setup Firebase

- Create a project in the [Firebase Console](https://console.firebase.google.com/).
- Add an Android app and download `google-services.json`.
- Place `google-services.json` in `android/app/`.
- Enable **Authentication** (Email/Password).
- Enable **Cloud Firestore** (Create database in test mode).

#### 4. Configure API Key

- Open `lib/core/constants/api_constants.dart`.
- Replace the placeholder with your TMDB API Key:
```dart
static const String apiKey = 'YOUR_TMDB_API_KEY';
```

#### 5. Run the App
```bash
flutter run
```

---

## 📂 Folder Structure
```
lib/
├── core/               # Constants and Utilities (Dio, API Keys)
├── models/             # Data Models (Movie, User)
├── services/           # API and Firebase Services
├── ui/
│   ├── screens/
│   │   ├── auth/       # Login & Register Screens
│   │   ├── feed/       # Home Feed (Vertical Scroll)
│   │   ├── detail/     # Movie Details
│   │   ├── search/     # Search Screen
│   │   ├── watchlist/  # User Favorites
│   │   └── main/       # Main Wrapper & Navigation
│   └── widgets/        # Reusable Widgets (GlassNavbar, MovieItem)
└── main.dart           # Entry Point
```

---

## 🎯 Key Features Explained

### 1. Vertical Infinite Scroll
Using `PageView.builder` with snap physics to create a TikTok-like browsing experience. Each movie poster takes up the full screen with smooth transitions.

### 2. Firebase Integration
- **Authentication:** Secure email/password login with session persistence.
- **Firestore:** Real-time watchlist syncing across devices using Firestore collections.

### 3. TMDB API Integration
Fetching trending movies, search results, and detailed information using Dio with proper error handling and response parsing.

---

## 🙏 Acknowledgments

- [TMDB API](https://www.themoviedb.org/documentation/api) for movie data
- [Flutter](https://flutter.dev/) for the amazing framework
- [Firebase](https://firebase.google.com/) for backend services
