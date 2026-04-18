# SmartWallet - Multi-Platform Finance Tracker

![Open Source](https://img.shields.io/badge/Open%20Source-Yes-brightgreen.svg)
![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)

SmartWallet helps you manage your finances efficiently with a simple, intuitive interface. Track daily income and expenses, monitor your financial health with dynamic emojis, and estimate how long your current funds will last. Your data stays on your device with optional export capabilities.

## Features

- 📊 **Daily Money Tracking** - Log income and expenses with custom reasons
- 💰 **Financial Health Indicator** - Dynamic emojis show your current financial status
- 📅 **Survival Days Calculator** - Estimate how many days your funds will last
- 📄 **Export & Backup** - Generate PDF reports and export data for safekeeping
- 🌍 **Internationalization** - English and Bengali language support
- 🎨 **Beautiful UI** - Modern design with Outfit font and expressive components
- 🔒 **Privacy First** - All data stored locally, full control over your information
- 📱 **Cross-Platform** - Available on Android, iOS, Linux, Windows, and macOS

## Installation

### Android

Download the APK from the [latest release](https://github.com/AbabilX/smartwallet/releases).

### iOS

Coming soon to App Store.

### Desktop

Download the appropriate package from the [releases page](https://github.com/AbabilX/smartwallet/releases):

- Linux: `.tar.gz` archive
- Windows: `.zip` archive
- macOS: Available soon

## Getting Started

1. **Install** the app on your device
2. **Set up your profile** with your preferred language and currency
3. **Add transactions** - track income and expenses with reasons
4. **Monitor your health** - check the profile section for financial status
5. **Export data** - generate PDF reports or backup when needed

## Tech Stack

- **Framework**: Flutter 3.x
- **Database**: Hive (local NoSQL database)
- **Fonts**: Google Fonts (Outfit)
- **Navigation**: Google Navigation Bar
- **PDF Generation**: PDF package
- **File Handling**: File Picker with permission handling

## Development

### Prerequisites

- Flutter SDK 3.1.0 or higher
- Android SDK with compileSdk 36
- For Linux: clang, cmake, ninja-build, gtk-3-dev
- For Windows: Visual Studio with C++ tools

### Build Commands

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run

# Build Android APK
flutter build apk --release --split-per-abi

# Build Android App Bundle (for Play Store)
flutter build appbundle --release

# Build Linux
flutter build linux --release

# Build Windows
flutter build windows --release

# Build iOS
flutter build ios --release
```

## CI/CD

This project uses GitHub Actions for automated builds:

- **Individual workflows** for each platform (android.yml, linux.yml, windows.yml, ios.yml)
- **Unified release workflow** (release.yml) that builds all platforms and creates a single GitHub release with all artifacts
- **Automatic signing** for Android builds using GitHub secrets

## Documentation

- [CHANGELOG.md](CHANGELOG.md) - Version history and release notes
- [PRIVACY_POLICY.md](PRIVACY_POLICY.md) - Privacy policy and data handling

## Contributing

Contributions are welcome! Please feel free to fork the repository and submit pull requests. For major changes, please open an issue first to discuss what you'd like to change.

## License

[MIT](https://choosealicense.com/licenses/mit/) - See LICENSE file for details

## Package Information

- **Package Name**: com.nodex.smartwallet
- **Version**: 1.0.0
- **Build Number**: 1

## Support

For issues, questions, or suggestions, please open an issue on GitHub.
