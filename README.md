# Cozy Shop — Flutter Firebase CRUD

A beginner-friendly Flutter mobile e-commerce CRUD project based on the provided college project guide.

## Included

- Firebase Email/Password Authentication
- Firestore users, categories, and products
- Users CRUD
- Categories CRUD
- Products CRUD
- Product/category relationship through `categoryId`
- StreamBuilder real-time lists
- Search
- Category filtering
- Form validation
- Loading states
- Error handling
- Confirmation dialogs
- Cozy warm mobile UI
- Firestore security rules

## Important Firebase setup

This project intentionally does not include real Firebase credentials.

1. Install Flutter.
2. Install Firebase CLI and FlutterFire CLI.
3. Create a Firebase project named `flutter_ecommerce_crud`.
4. Enable Email/Password Authentication.
5. Create Cloud Firestore.
6. From the project directory run:

```bash
flutter pub get
flutterfire configure
```

Select the Firebase project and Android platform. FlutterFire will generate the real `lib/firebase_options.dart`.

Then run:

```bash
flutter run
```

## Admin access

The Firestore rules allow category/product CRUD only to users whose Firestore profile has:

```text
role: admin
```

A newly registered account defaults to:

```text
role: customer
```

For a classroom/demo project, after registering the first account, change its Firestore `role` to `admin` in Firebase Console.

## Android APK

After Firebase is configured:

```bash
flutter build apk --release
```

APK:

```text
build/app/outputs/flutter-apk/app-release.apk
```
