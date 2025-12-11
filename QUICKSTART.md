# Quick Start Guide - SolarSmart Flutter App

## Get Up and Running in 10 Minutes

### Prerequisites Checklist
- ✅ Flutter installed (run `flutter doctor` to verify)
- ✅ Android Studio or Xcode installed
- ✅ Firebase account created
- ✅ Git installed

### Step 1: Get Dependencies (2 minutes)

```bash
cd Solaradvisor
flutter pub get
```

### Step 2: Firebase Setup (5 minutes)

#### Option A: Quick Setup (Recommended)

```bash
# Install Firebase tools
npm install -g firebase-tools
dart pub global activate flutterfire_cli

# Login and configure
firebase login
flutterfire configure
```

Follow the prompts to:
1. Select or create a Firebase project
2. Choose platforms (Android/iOS)
3. Auto-generate configuration

#### Option B: Manual Setup

See [FIREBASE_SETUP.md](FIREBASE_SETUP.md) for detailed instructions.

### Step 3: Enable Firebase Services (2 minutes)

In [Firebase Console](https://console.firebase.google.com/):

1. **Authentication** → Enable Email/Password + Google
2. **Firestore Database** → Create database
3. **Rules** → Copy from `firestore.rules` file

### Step 4: Run the App (1 minute)

```bash
# Run on connected device/emulator
flutter run

# Or specify device
flutter devices  # List available devices
flutter run -d <device_id>
```

### Step 5: Create Your First Account

1. App opens to login screen
2. Click "Create account"
3. Enter name, email, password
4. Done! 🎉

## Project Structure Overview

```
lib/
├── main.dart                    # Start here
├── screens/
│   ├── auth/                   # Login & Register
│   ├── calculate/              # Energy calculator
│   ├── dashboard/              # Main screen
│   └── recommendations/        # Solar systems
├── providers/                   # State management
├── models/                      # Data structures
└── utils/                       # Helpers & constants
```

## Key Features to Try

1. **🔐 Login** → Use email/password or Google Sign-In
2. **⚡ Calculate Energy** → Add appliances, see usage
3. **💡 Get Recommendations** → View solar system options
4. **📊 Dashboard** → See charts and saved locations

## Common Commands

```bash
# Clean build
flutter clean && flutter pub get

# Run in release mode
flutter run --release

# Build APK
flutter build apk

# Check for issues
flutter doctor

# Update dependencies
flutter pub upgrade
```

## Troubleshooting

### App won't build?
```bash
flutter clean
flutter pub get
flutter run
```

### Firebase errors?
- Check `firebase_options.dart` exists
- Verify `google-services.json` in `android/app/`
- Run `flutterfire configure` again

### Google Sign-In not working?
- Add SHA-1 to Firebase Console
- Update `google-services.json`
- Enable Google in Firebase Authentication

### Can't see data in Firestore?
- Check authentication is working
- Verify security rules are set
- Check Firebase Console for errors

## Next Steps

- 📖 Read full [README.md](README.md)
- 🔥 See detailed [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
- 🎨 Customize colors in `lib/utils/colors.dart`
- ➕ Add more appliances in `lib/providers/appliance_provider.dart`

## Development Tips

### Hot Reload
Press `r` in terminal while app is running to hot reload changes

### Debug Mode
Add breakpoints in VS Code and use F5 to debug

### State Management
The app uses Provider pattern - check `lib/providers/` for state logic

### Firebase Console
Keep Firebase Console open while developing to monitor:
- Authentication users
- Firestore data
- Errors and logs

## Support

Need help?
- 📚 Check the detailed documentation files
- 🐛 Report issues in the repository
- 💬 Firebase docs: https://firebase.google.com/docs
- 📱 Flutter docs: https://docs.flutter.dev

Happy coding! 🚀
