// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
      // apiKey: 'AIzaSyC3090syEsOuEQzDOJEarQ0pvBCLkj9yPI',
      // appId: '1:401246625585:web:b102cda18c674d2b7c1a10',
      // messagingSenderId: '401246625585',
      // projectId: 'samay-mvp',
      // authDomain: 'samay-mvp.firebaseapp.com',
      // storageBucket: 'samay-mvp.appspot.com',
      // measurementId: 'G-41C7FEQ18V',
      apiKey: "AIzaSyC3090syEsOuEQzDOJEarQ0pvBCLkj9yPI",
      authDomain: "samay-mvp.firebaseapp.com",
      projectId: "samay-mvp",
      storageBucket: "samay-mvp.appspot.com",
      messagingSenderId: "401246625585",
      appId: "1:401246625585:web:cabd15c1d059d0e37c1a10",
      measurementId: "G-DF4H4LYRQT");
}