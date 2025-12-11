# SolarSmart - Flutter Solar Energy Advisor App

A beautiful Flutter mobile application for solar energy calculations and recommendations with Firebase backend integration.

## Features

- 🔐 **Authentication**: Email/Password and Google Sign-In with Firebase Auth
- ⚡ **Energy Calculator**: Add appliances and calculate daily/monthly energy consumption
- 💡 **Smart Recommendations**: Get personalized solar system recommendations
- 📊 **Analytics Dashboard**: Visual charts showing energy usage patterns
- 📍 **Location Management**: Save and manage multiple locations
- 🔥 **Firebase Backend**: Real-time data sync with Cloud Firestore

## Screenshots

The app replicates the design from the original HTML mockup with:
- Login/Register screens with gradient buttons
- Energy load calculation with appliance management
- Solar system recommendation cards
- Dashboard with charts and saved locations

## Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Firebase account
- Android Studio / VS Code with Flutter extensions
- An Android device or emulator / iOS device or simulator

## Installation

### 1. Clone the repository

```bash
git clone <your-repo-url>
cd Solaradvisor
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Firebase Setup

#### Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: "SolarSmart" (or your preferred name)
4. Follow the setup wizard

#### Step 2: Enable Authentication

1. In Firebase Console, go to **Authentication** → **Sign-in method**
2. Enable **Email/Password**
3. Enable **Google** sign-in
   - Add your SHA-1 certificate fingerprint (for Android)
   - Download updated `google-services.json`

#### Step 3: Create Firestore Database

1. Go to **Firestore Database** → **Create database**
2. Start in **production mode** (or test mode for development)
3. Choose a location closest to your users

#### Step 4: Firestore Security Rules

Set up the following security rules in Firestore:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // User's appliances
      match /appliances/{applianceId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      
      // User's locations
      match /locations/{locationId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

#### Step 5: Install FlutterFire CLI

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli
```

#### Step 6: Configure Firebase for Flutter

Run the FlutterFire configuration command:

```bash
flutterfire configure
```

This will:
- Select your Firebase project
- Register your app for Android/iOS
- Generate `lib/firebase_options.dart` with your configuration
- Download necessary config files

**Important**: Make sure to replace the placeholder `firebase_options.dart` file with the generated one.

### 4. Platform-Specific Setup

#### Android

1. Open `android/app/build.gradle`
2. Ensure minSdkVersion is at least 21:

```gradle
android {
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 33
    }
}
```

3. Place `google-services.json` in `android/app/` directory

#### iOS

1. Open `ios/Runner.xcworkspace` in Xcode
2. Ensure minimum deployment target is iOS 11.0 or higher
3. Place `GoogleService-Info.plist` in `ios/Runner/` directory
4. Update `Info.plist` with required permissions
5. Run `pod install` in the `ios` directory

### 5. Google Sign-In Setup (Optional)

For Android:
1. Get SHA-1 certificate fingerprint:
```bash
cd android
./gradlew signingReport
```
2. Add SHA-1 to Firebase Console under Project Settings → Your Apps

For iOS:
1. Add URL scheme in `ios/Runner/Info.plist`
2. Add reversed client ID from `GoogleService-Info.plist`

## Running the App

### Run on Android/iOS

```bash
flutter run
```

### Run in debug mode

```bash
flutter run --debug
```

### Build APK (Android)

```bash
flutter build apk --release
```

### Build IPA (iOS)

```bash
flutter build ios --release
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration (auto-generated)
├── models/                   # Data models
│   ├── appliance.dart
│   ├── location.dart
│   ├── solar_system.dart
│   └── user_profile.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── appliance_provider.dart
│   └── location_provider.dart
├── screens/                  # UI screens
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── calculate/
│   │   └── calculate_load_screen.dart
│   ├── dashboard/
│   │   └── dashboard_screen.dart
│   └── recommendations/
│       └── recommendations_screen.dart
└── utils/                    # Utilities
    ├── colors.dart
    └── constants.dart
```

## Firestore Data Structure

```
users/
  {userId}/
    - uid: string
    - email: string
    - displayName: string
    - photoUrl: string
    - location: string
    - createdAt: timestamp
    
    appliances/
      {applianceId}/
        - name: string
        - icon: string
        - wattage: number
        - quantity: number
        - hoursPerDay: number
    
    locations/
      {locationId}/
        - name: string
        - icon: string
        - dailyUsage: number
        - address: string
        - createdAt: timestamp
```

## Key Dependencies

- `firebase_core` - Firebase initialization
- `firebase_auth` - Authentication
- `cloud_firestore` - Database
- `provider` - State management
- `google_fonts` - Typography
- `fl_chart` - Charts and graphs
- `google_sign_in` - Google authentication

## Features Breakdown

### 1. Authentication
- Email/Password registration and login
- Google Sign-In integration
- Password reset functionality
- User profile management

### 2. Energy Calculator
- Pre-defined appliance library
- Custom appliance addition
- Real-time energy calculation (daily/monthly)
- Firestore sync for user appliances

### 3. Recommendations
- Three-tier system recommendations (Basic, Standard, Premium)
- Cost estimation
- Component specifications (panels, batteries, inverters)

### 4. Dashboard
- Energy usage charts (fl_chart)
- Saved locations management
- Active recommendations display
- Bottom navigation

## Customization

### Colors
Edit `lib/utils/colors.dart` to change the app's color scheme:
```dart
static const Color brandGreen = Color(0xFF10B981);
static const Color brandBlue = Color(0xFF3B82F6);
```

### Appliances
Add more predefined appliances in `lib/providers/appliance_provider.dart`:
```dart
static final List<Appliance> predefinedAppliances = [
  Appliance(id: 'x', name: 'New Appliance', icon: 'icon', wattage: 100),
  // ...
];
```

## Troubleshooting

### Firebase Configuration Issues
- Ensure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are in correct directories
- Run `flutterfire configure` again if configuration is incorrect
- Check Firebase Console for proper app registration

### Build Errors
```bash
flutter clean
flutter pub get
flutter run
```

### Google Sign-In Not Working
- Verify SHA-1 certificate is added in Firebase Console
- Check that Google Sign-In is enabled in Firebase Authentication
- Ensure google-services.json is up to date

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License.

## Support

For issues and questions:
- Create an issue in the repository
- Check Firebase documentation: https://firebase.google.com/docs
- Flutter documentation: https://docs.flutter.dev

## Acknowledgments

- Design inspired by modern solar energy apps
- Built with Flutter and Firebase
- Icons from Font Awesome and Material Icons
