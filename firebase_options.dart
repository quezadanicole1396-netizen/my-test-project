// Run `flutterfire configure` in your project to generate the real
// Firebase configuration for your Firebase project.
//
// This placeholder intentionally does not contain credentials.
// After running FlutterFire, replace this file with the generated
// firebase_options.dart.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    throw UnsupportedError(
      'Firebase is not configured. Run "flutterfire configure" '
      'to generate lib/firebase_options.dart.',
    );
  }

  static FirebaseOptions get web => throw UnsupportedError(
        'Configure Firebase with FlutterFire.',
      );

  static FirebaseOptions get android => throw UnsupportedError(
        'Configure Firebase with FlutterFire.',
      );

  static FirebaseOptions get ios => throw UnsupportedError(
        'Configure Firebase with FlutterFire.',
      );
}
