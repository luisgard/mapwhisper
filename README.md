# 🌌 MapWhisper

MapWhisper is an anonymous location-based mobile application built with Flutter.

Users can drop pins anywhere on the map and leave thoughts, recommendations, warnings, stories, or random whispers tied to real-world locations.

---

## ✨ Features

- 📍 Interactive map experience
- 🗺️ Anonymous map pins
- 💬 Real-time comments and whispers
- 🔥 Firebase real-time database
- 🌙 Modern mobile UI
- ⚡ Cross-platform Flutter application

---

## 🛠️ Tech Stack

- Flutter
- OpenStreetMap
- Firebase Firestore
- Firebase Anonymous Authentication
- GitHub Actions (CI/CD)
- Google Play

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/mapwhisper.git
cd mapwhisper
```

---

### 2. Install dependencies

```bash
flutter pub get
```

---

### 3. Configure Firebase

Create a Firebase project:

👉 https://console.firebase.google.com

Enable:

- Anonymous Authentication
- Cloud Firestore

Then run:

```bash
flutterfire configure
```

This will generate:

```txt
lib/firebase_options.dart
```

---

### 4. Run the app

```bash
flutter run
```

---

## 📌 Roadmap

- [ ] Interactive map
- [ ] Anonymous pins
- [ ] Categories
- [ ] Pin reactions
- [ ] Nearby whispers
- [ ] Moderation system
- [ ] Push notifications
- [ ] Dark mode improvements

---

## 📱 Status

🚧 Currently under development.

---

## 📄 License

This project is licensed under the MIT License.