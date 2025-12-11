# Firebase Setup Guide for SolarSmart

## Step-by-Step Firebase Configuration

### 1. Create Firebase Project

1. Visit [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" or "Create a project"
3. Enter project name: `SolarSmart`
4. Disable Google Analytics (optional for this project)
5. Click "Create project"

### 2. Register Your App

#### For Android:
1. Click on Android icon in Firebase project overview
2. Enter package name: `com.example.solarsmart` (or your custom package name from `android/app/build.gradle`)
3. Enter app nickname: `SolarSmart Android`
4. Click "Register app"
5. Download `google-services.json`
6. Place it in `android/app/` directory

#### For iOS:
1. Click on iOS icon in Firebase project overview
2. Enter bundle ID: `com.example.solarsmart` (from `ios/Runner.xcodeproj`)
3. Enter app nickname: `SolarSmart iOS`
4. Click "Register app"
5. Download `GoogleService-Info.plist`
6. Drag and drop it into `ios/Runner/` in Xcode

### 3. Enable Authentication Methods

1. In Firebase Console, navigate to **Build** → **Authentication**
2. Click "Get started"
3. Go to "Sign-in method" tab
4. Enable **Email/Password**:
   - Click on "Email/Password"
   - Toggle "Enable"
   - Click "Save"

5. Enable **Google** sign-in:
   - Click on "Google"
   - Toggle "Enable"
   - Select project support email
   - Click "Save"

### 4. Get SHA-1 Certificate (for Google Sign-In on Android)

Run this command in your project root:

```bash
cd android
./gradlew signingReport
```

Or for Windows:
```bash
cd android
gradlew signingReport
```

Copy the SHA-1 certificate fingerprint from the output, then:

1. Go to Firebase Console → Project Settings
2. Scroll down to "Your apps"
3. Click on your Android app
4. Click "Add fingerprint"
5. Paste SHA-1 fingerprint
6. Click "Save"
7. Download the updated `google-services.json` file

### 5. Create Firestore Database

1. In Firebase Console, navigate to **Build** → **Firestore Database**
2. Click "Create database"
3. Select **Start in production mode** (we'll add rules later)
4. Choose a location (select closest to your target users)
5. Click "Enable"

### 6. Set Up Firestore Security Rules

1. In Firestore Database, go to "Rules" tab
2. Copy the contents from `firestore.rules` file in your project
3. Paste into the Firebase rules editor
4. Click "Publish"

### 7. Create Firestore Indexes (Optional)

If you get index errors when running queries, Firebase will provide a link to create the required index automatically. Alternatively, you can create them manually:

1. Go to **Firestore Database** → **Indexes** tab
2. Create composite indexes for:
   - Collection: `users/{userId}/locations`
     - Fields: `userId` (Ascending), `createdAt` (Descending)

### 8. Configure FlutterFire CLI

Install Firebase CLI and FlutterFire CLI:

```bash
# Install or update Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Make sure it's in your PATH
export PATH="$PATH":"$HOME/.pub-cache/bin"  # Add to ~/.bashrc or ~/.zshrc
```

### 9. Run FlutterFire Configuration

From your project root directory:

```bash
flutterfire configure
```

This command will:
1. Prompt you to select your Firebase project
2. Ask which platforms to configure (Android, iOS, Web, etc.)
3. Automatically generate `lib/firebase_options.dart`
4. Configure your platforms with the correct Firebase settings

**Important**: The generated `firebase_options.dart` will replace the placeholder file in your project.

### 10. iOS Additional Setup

If building for iOS, update `ios/Runner/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <!-- Replace with your REVERSED_CLIENT_ID from GoogleService-Info.plist -->
            <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
        </array>
    </dict>
</array>
```

Then run:
```bash
cd ios
pod install
```

### 11. Verify Firebase Setup

Run your app:

```bash
flutter run
```

Check for any Firebase initialization errors in the console.

### 12. Test Authentication

1. Run the app
2. Try creating a new account
3. Check Firebase Console → Authentication → Users to verify user creation
4. Try logging in with the created account
5. Test Google Sign-In

### 13. Test Firestore

1. Add some appliances in the app
2. Check Firebase Console → Firestore Database
3. Verify that data is being created under `users/{userId}/appliances`

## Common Issues and Solutions

### Issue: "No Firebase App '[DEFAULT]' has been created"
**Solution**: Ensure `Firebase.initializeApp()` is called in `main.dart` before `runApp()`

### Issue: Google Sign-In not working on Android
**Solution**: 
- Verify SHA-1 certificate is added in Firebase Console
- Ensure `google-services.json` is in `android/app/`
- Check that Google Sign-In is enabled in Firebase Authentication

### Issue: Firestore permission denied
**Solution**: 
- Check that security rules are properly set
- Ensure user is authenticated before accessing Firestore
- Verify rules in Firebase Console → Firestore → Rules tab

### Issue: iOS build fails
**Solution**:
- Run `pod install` in `ios/` directory
- Clean build: `flutter clean && flutter pub get`
- Ensure `GoogleService-Info.plist` is added to Xcode project

## Environment-Specific Configuration

### Development
Use test mode rules for easier debugging:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.time < timestamp.date(2024, 12, 31);
    }
  }
}
```

### Production
Use the secure rules from `firestore.rules` file.

## Monitoring and Analytics

1. Go to Firebase Console → Analytics
2. Enable Google Analytics (optional)
3. Monitor user engagement, crashes, and performance

## Backup Strategy

1. Set up automated Firestore exports
2. Go to Firebase Console → Firestore Database → Import/Export
3. Configure scheduled exports to Cloud Storage

## Next Steps

- Set up Firebase Cloud Functions for server-side logic
- Implement Firebase Cloud Messaging for push notifications
- Add Firebase Remote Config for feature flags
- Set up Firebase Crashlytics for error tracking

## Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase CLI Reference](https://firebase.google.com/docs/cli)
