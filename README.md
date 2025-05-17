**Lottery Picker App**

A Flutter application that allows users to pick lottery numbers either manually or automatically, with smooth animations and state management using Riverpod.

**Features**
1. Manual number selection (1-50)
2. Auto-pick random numbers
3. Animated number selection effects
4. History of selected numbers
5. Responsive UI with smooth animations
6. State management with Riverpod
   
**Setup Instructions**
Prerequisites
1. Flutter SDK (version 3.0.0 or higher)
2. Dart SDK (version 2.17.0 or higher)
3. Android Studio/VSCode with Flutter plugins (optional but recommended)

**Installation**
Clone the repository:
1. git clone https://github.com/chris-eminence/lottery-picker.git
2. cd lottery-picker
3. Install dependencies: flutter pub get
   
**Run the app:**
flutter run

**Project Structure**
1. lib/
2. ├── main.dart                # App entry point
3. ├── bottom_nav.dart          # controlls the bottom navigation
4. ├── riverpod_provider/
5. │   └── provider.dart        # State management providers
6. ├── widgets/
7. │   └── picked_numbers_widget.dart # Extracted UI components
8. ├── lottery_screen/
9. │   └── lottery_page.dart #main lottery page
10. ├── history_page/
11. │   └── history_screen.dart # History page to view entries
12. ├── welcome_screen/
13. │   └── welcome_page.dart # A welcome screen to usher the user in



**Dependencies**
This project uses the following major dependencies:

1. flutter_riverpod: State management
2. flutter_svg: SVG image rendering
3. google_fonts: Custom fonts

See pubspec.yaml for complete list of dependencies.

**Configuration**
SVG Assets:
Place your SVG files in assets/ directory
Update pubspec.yaml to include them:

yaml
assets:
- assets/

The app uses Google Fonts (Nunito) via the google_fonts package
No additional configuration needed

**Building for Release**
1. Android
flutter build apk --release

2. iOS
flutter build ios --release

**Troubleshooting**
Animation errors:
1. Ensure all animation controllers are properly disposed
2. Check that TickerProvider is correctly provided

State not updating:
1. Verify Riverpod providers are properly scoped
2. Check for missing notifyListeners() calls

SVG rendering issues:
1. Verify SVG files are properly formatted
2. Check asset paths in pubspec.yaml
