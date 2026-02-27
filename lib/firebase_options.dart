// File generated from Firebase console config for project: kitahack-tehais
// App ID: 1:361731769370:web:69fda04c8994958e88fda3

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD9QPgF3q8H_lf-siMf5cxV4aA3ZHHF4r4',
    appId: '1:361731769370:web:69fda04c8994958e88fda3',
    messagingSenderId: '361731769370',
    projectId: 'kitahack-tehais',
    authDomain: 'kitahack-tehais.firebaseapp.com',
    storageBucket: 'kitahack-tehais.firebasestorage.app',
    measurementId: 'G-8712Q88S62',
  );

  // For Android — create google-services.json from Firebase Console
  // and place it in android/app/ to generate these values automatically.
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD9QPgF3q8H_lf-siMf5cxV4aA3ZHHF4r4',
    appId: '1:361731769370:android:placeholder',
    messagingSenderId: '361731769370',
    projectId: 'kitahack-tehais',
    storageBucket: 'kitahack-tehais.firebasestorage.app',
  );

  // For iOS — create GoogleService-Info.plist from Firebase Console.
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD9QPgF3q8H_lf-siMf5cxV4aA3ZHHF4r4',
    appId: '1:361731769370:ios:placeholder',
    messagingSenderId: '361731769370',
    projectId: 'kitahack-tehais',
    storageBucket: 'kitahack-tehais.firebasestorage.app',
    iosClientId: 'REPLACE_WITH_IOS_CLIENT_ID',
    iosBundleId: 'com.example.kitahack16',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD9QPgF3q8H_lf-siMf5cxV4aA3ZHHF4r4',
    appId: '1:361731769370:ios:placeholder',
    messagingSenderId: '361731769370',
    projectId: 'kitahack-tehais',
    storageBucket: 'kitahack-tehais.firebasestorage.app',
    iosClientId: 'REPLACE_WITH_IOS_CLIENT_ID',
    iosBundleId: 'com.example.kitahack16',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD9QPgF3q8H_lf-siMf5cxV4aA3ZHHF4r4',
    appId: '1:361731769370:web:69fda04c8994958e88fda3',
    messagingSenderId: '361731769370',
    projectId: 'kitahack-tehais',
    authDomain: 'kitahack-tehais.firebaseapp.com',
    storageBucket: 'kitahack-tehais.firebasestorage.app',
    measurementId: 'G-8712Q88S62',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyD9QPgF3q8H_lf-siMf5cxV4aA3ZHHF4r4',
    appId: '1:361731769370:web:69fda04c8994958e88fda3',
    messagingSenderId: '361731769370',
    projectId: 'kitahack-tehais',
    authDomain: 'kitahack-tehais.firebaseapp.com',
    storageBucket: 'kitahack-tehais.firebasestorage.app',
    measurementId: 'G-8712Q88S62',
  );
}
