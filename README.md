# 🚗 Smart Vehicle Monitoring App

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.5.1+-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-3.5.1+-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" />
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-green?style=for-the-badge&logo=flutter&logoColor=white" />
</p>

> A **cross-platform Smart Vehicle Monitoring application** built with Flutter and Firebase — monitor your vehicle in real time across Android, iOS, Web, Windows, macOS, and Linux.

---

## 📋 Table of Contents

- [About](#-about)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Platform Support](#-platform-support)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Firebase Setup](#firebase-setup)
  - [Running the App](#running-the-app)
- [Build & Release](#-build--release)
- [Contributing](#-contributing)
- [License](#-license)

---

## 📖 About

**Smart Vehicle Monitoring App** is a real-time, cross-platform Flutter application that enables users to monitor vehicle data intelligently. Backed by Firebase Authentication and Cloud Firestore, it provides secure user login and real-time data syncing across all platforms.

---

## ✨ Features

- 🔐 **User Authentication** — Secure sign-in/sign-up via Firebase Auth
- 📡 **Real-time Data Sync** — Live vehicle data powered by Cloud Firestore
- 📊 **Vehicle Monitoring Dashboard** — Track and visualize vehicle metrics
- 🌍 **Cross-platform** — Runs on Android, iOS, Web, Windows, macOS, and Linux
- 📅 **Internationalization** — Date/time formatting with `intl` package
- ⚡ **Responsive UI** — Material Design with Cupertino support for iOS

---

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.5.1+ |
| Language | Dart 3.5.1+ |
| Authentication | Firebase Auth 4.17.0 |
| Database | Cloud Firestore 4.14.0 |
| Backend Services | Firebase Core 2.31.0 |
| Internationalization | intl 0.17.0 |
| UI Icons | Cupertino Icons 1.0.8 |

---

## 📱 Platform Support

| Platform | Status |
|---|---|
| 🤖 Android | ✅ Supported |
| 🍎 iOS | ✅ Supported |
| 🌐 Web | ✅ Supported |
| 🪟 Windows | ✅ Supported |
| 🍏 macOS | ✅ Supported |
| 🐧 Linux | ✅ Supported |

---

## 📁 Project Structure

```
Smart-Vehicle-Monitoring-app1/
├── android/                  # Android-specific files
├── ios/                      # iOS-specific files
├── linux/                    # Linux desktop configuration
├── macos/                    # macOS desktop configuration
├── windows/                  # Windows desktop configuration
├── web/                      # Web platform files
├── lib/                      # Main Flutter/Dart source code
│   ├── firebase_options.dart # Firebase configuration (auto-generated)
│   ├── main.dart             # App entry point
│   ├── screens/              # UI screens/pages
│   ├── widgets/              # Reusable UI components
│   ├── models/               # Data models
│   └── services/             # Firebase & business logic services
├── test/                     # Unit and widget tests
├── firebase.json             # Firebase project configuration
├── pubspec.yaml              # Flutter dependencies
└── analysis_options.yaml     # Dart lint rules
```

---

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed:

- **Flutter SDK 3.5.1+** — [Install Flutter](https://docs.flutter.dev/get-started/install)
- **Dart SDK 3.5.1+** *(bundled with Flutter)*
- **Android Studio / Xcode** — for mobile development
- **Firebase account** — [console.firebase.google.com](https://console.firebase.google.com)
- **FlutterFire CLI** *(for Firebase setup)*

Verify your Flutter setup:

```bash
flutter doctor
```

---

### Installation

**1. Clone the repository:**

```bash
git clone https://github.com/slshree1/Smart-Vehicle-Monitoring-app1.git
cd Smart-Vehicle-Monitoring-app1
```

**2. Install dependencies:**

```bash
flutter pub get
```

---

### Firebase Setup

This project uses Firebase. To connect it to your own Firebase project:

**1. Install the FlutterFire CLI:**

```bash
dart pub global activate flutterfire_cli
```

**2. Login to Firebase:**

```bash
firebase login
```

**3. Configure Firebase for your project:**

```bash
flutterfire configure
```

This will auto-generate `lib/firebase_options.dart` with your project credentials.

**4. Enable the following in your Firebase Console:**
- **Authentication** → Email/Password (or your preferred provider)
- **Cloud Firestore** → Create a database in test or production mode

> ⚠️ Never commit your `google-services.json` or `GoogleService-Info.plist` files to a public repository. They are already listed in `.gitignore`.

---

### Running the App

**Android:**

```bash
flutter run -d android
```

**iOS:**

```bash
flutter run -d ios
```

**Web:**

```bash
flutter run -d chrome
```

**Windows:**

```bash
flutter run -d windows
```

**Linux:**

```bash
flutter run -d linux
```

**macOS:**

```bash
flutter run -d macos
```

---

## 📦 Build & Release

**Build APK (Android):**

```bash
flutter build apk --release
```

**Build App Bundle (Android - for Play Store):**

```bash
flutter build appbundle --release
```

**Build iOS (requires macOS + Xcode):**

```bash
flutter build ios --release
```

**Build Web:**

```bash
flutter build web --release
```

**Run Tests:**

```bash
flutter test
```

---

## 🤝 Contributing

Contributions are welcome! To get started:

1. **Fork** this repository
2. **Create** a new branch: `git checkout -b feature/your-feature-name`
3. **Commit** your changes: `git commit -m 'Add some feature'`
4. **Push** to your branch: `git push origin feature/your-feature-name`
5. **Open a Pull Request**

Please make sure to run `flutter test` before submitting your PR.

---

## 📄 License

This project is private and not published to pub.dev. All rights reserved.

---

<p align="center">
  Built with ❤️ using <strong>Flutter</strong> & <strong>Firebase</strong>
</p>
