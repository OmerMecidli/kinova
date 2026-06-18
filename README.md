# Kinova 🎬

Kinova is a modern, Netflix-inspired movie discovery application built with Flutter. It allows users to explore trending movies, search for their favorite titles, view detailed information including cast and trailers, rate movies locally, and manage a personalized watchlist.

## ✨ Features

* **Home Screen:** Discover Trending, Popular, Top Rated, and Upcoming movies with a dynamic, randomized Hero Banner.
* **Search & History:** Search for movies with a debounced input. Your recent searches are saved locally. When idle, view recommended popular movies.
* **Movie Details:** Immersive detail pages with extended backdrops, YouTube trailers, cast lists with avatars, and similar movies.
* **Actor Profiles:** View actor biographies, birth details, and their filmography with a premium blurred background UI.
* **My List (Favorites):** Add movies to your personalized watchlist. Stored locally, allowing you to access your favorites anytime.
* **Local Rating System:** Rate movies out of 10 stars and have your ratings saved on your device.
* **Share:** Share TMDB links of your favorite movies directly from the app.
* **Premium UI/UX:** Dark mode Netflix-style design, `extendBodyBehindAppBar` layouts, smooth transitions, and `SafeArea` optimized bottom sheets.

## 🛠 Tech Stack & Architecture

* **Framework:** Flutter
* **Architecture:** Clean Architecture (Presentation, Domain, Data layers)
* **State Management:** BLoC / Cubit (`flutter_bloc`)
* **Dependency Injection:** `get_it` & `injectable`
* **Network / API:** `dio` & TMDB API
* **Functional Programming:** `fpdart` (Either, fold)
* **Routing:** `go_router`
* **Local Storage:** `get_storage`
* **Environment Variables:** `flutter_dotenv`

## 🚀 Getting Started

### Prerequisites

* Flutter SDK (3.x.x or newer)
* Dart SDK

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/kinova.git
   cd kinova
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate DI code:**
   Since the project uses `injectable`, you need to generate the dependency injection files:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Setup Environment Variables:**
   Create a `.env` file in the root directory and add your TMDB API Key:
   ```env
   TMDB_API_KEY=your_api_key_here
   ```

5. **Run the app:**
   ```bash
   flutter run
   ```

## 📸 Screenshots
*(Coming soon)*

## 🤝 Contributing
Contributions are welcome! Please feel free to submit a Pull Request.
