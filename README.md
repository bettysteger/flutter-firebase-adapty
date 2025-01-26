# Flutter firebase adapty template

A new Flutter template. Let's you create a Game or App where Push notification are sent, anoymous auth is built-in and the user can buy a subscription.

## Features

- [x] Firebase for Auth / Firestore (Database) and Messaging (Push Notifications)
- [x] Branch.io for Deep Links (invite friends to a game)
- [x] Adapty for Subscription and Paywall (iOS / Android)
- [x] Multi-language support (en, de)
- [ ] Suggestions? [Write an issue](https://github.com/bettysteger/flutter-firebase-adapty/issues)

## Development

### Use this template

**Step 1:** App name  
Go to github and click on [Use this template](https://github.com/new?template_name=flutter-firebase-adapty&template_owner=bettysteger) (on the top right) to create a new repository with this template. Then clone the repository to your local machine. To rename your appname and packagename you can use the following command:

```bash
flutter pub global activate rename
flutter pub global run rename setBundleId --value com.example.appname
flutter pub global run rename setAppName --value "App Name"
```

**Step 2:** Firebase  
Create a new [Firebase](https://firebase.google.com) project and add the `google-services.json` file to the `android/app` folder and the `GoogleService-Info.plist` file to the `ios/Runner` folder. [More info](https://firebase.google.com/docs/flutter/setup)


**Step 3:**  Deeplinks (optional)  
If you need Deeplinks, (link to a game) create a new [Branch.io](https://branch.io) project and add the Branch key to the `android/app/src/main/AndroidManifest.xml` and `ios/Runner/Info.plist` files. Additionally add the `branch_universal_link_domains` to the `ios/Runner/Info.plist` file. [More info](https://help.branch.io/developers-hub/docs/flutter-sdk-basic-integration)

Afterwards replace `https://brand-io.app.link` in lib/models/game.dart with your own link.

**Step 4:** Adapty (optional)  
If you want to earn some money with a subscription, create a new [Adapty](https://adapty.io) project and add the Adapty key to the `android/app/src/main/AndroidManifest.xml` and `ios/Runner/Info.plist` files. [More info](https://adapty.io/docs/sdk-installation-flutter)

At the moment there is just 1 subscription product in the `lib/screens/paywall.dart` file. You can add more products in the Adapty dashboard and then add them to the `lib/screens/paywall.dart` file. At the moment the paywallId is hardcoded in the `lib/screens/paywall.dart` file. You can find the paywallId in the Adapty dashboard. In this example the paywallId is `settings`.

### Run 

Either do a `flutter run` in the console (will open iOS simulator if no device is connected) or Run > Start Debugging in VSCode.

If some errors occur it often helps to run `flutter clean` (clears the build folder) and then `flutter pub get` to re-install the dependencies.

### Flutter documenation

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Plugin managment with pub

Add a plugin: `flutter pub add firebase_core`  
Remove a plugin: `flutter pub remove firebase_core`  
Find outdated plugins: `flutter pub outdated`  

(Re-)Install all plugins (e.g. after updating pubspec.yaml): `flutter pub get`

### Generate app icons & spash screen

See [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)

`flutter pub run flutter_launcher_icons:main`

See [splash_screen_view](https://pub.dev/packages/splash_screen_view)

`flutter pub run splash_screen_view:create`

### Build ios

`flutter build ipa && open build/ios/archive/Runner.xcarchive`

### Build android

Signed with `mkdir keys && keytool -genkey -v -keystore keys/keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias AppName`
`AppName2025!`

`flutter build appbundle --release --no-tree-shake-icons && open build/app/outputs/bundle/release/`