# hng_stage2_app — Storekeeper App (HNG Stage 2)

A Flutter store inventory app that uses SQLite for local relational storage and supports full CRUD operations and native camera/gallery image input.

## Features
- Add, view, edit, delete products (name, quantity, price, optional image)
- Local relational DB using `sqflite`
- Images saved as files; DB stores file paths
- Native camera & gallery integration using `image_picker`
- Search and sort, light/dark theme toggle
- Clean Material 3 UI with a branded logo

## Tech
- Flutter
- sqflite
- image_picker
- provider

## Run (development)
```bash
git clone https://github.com/<your-username>/hng_stage3_app.git
cd hng_stage3_app
flutter pub get
flutter run
Build Release APK
bash
Copy code
flutter clean
flutter pub get
flutter build apk --release
```

## Release APK will be at:
build/app/outputs/flutter-apk/app-release.apk

## Links
- GitHub repo: https://github.com/dynasteve/hng_i-mobile-stage2.git
- APK: https://drive.google.com/file/d/1IU7TKjf29IwgW9od2E1_eVmKCvrUtJtE/view?usp=drive_link
- Demo video: https://drive.google.com/file/d/1dUVmFvaRMjJGBoOt4lfY5I8qZxXODHUs/view?usp=drive_link