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
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyDv_lPSTlhTBOXh3gO22pmJgDbfnsdt7vk',
    appId: '1:1084003045571:web:1a0d4f5598376a340b9276',
    messagingSenderId: '1084003045571',
    projectId: 'gerenciadoreventos-bdf1c',
    authDomain: 'gerenciadoreventos-bdf1c.firebaseapp.com',
    storageBucket: 'gerenciadoreventos-bdf1c.appspot.com',
    measurementId: 'G-2XJYT4WLPN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC5Hr9t7R-7gaGxDwmxzjBcjmwYdyb2B3s',
    appId: '1:1084003045571:android:2a2576ecba2040c90b9276',
    messagingSenderId: '1084003045571',
    projectId: 'gerenciadoreventos-bdf1c',
    storageBucket: 'gerenciadoreventos-bdf1c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDlYfII7BX2ffby_2seTW70ljAwIH01QDQ',
    appId: '1:1084003045571:ios:658c3804c385d3a80b9276',
    messagingSenderId: '1084003045571',
    projectId: 'gerenciadoreventos-bdf1c',
    storageBucket: 'gerenciadoreventos-bdf1c.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDlYfII7BX2ffby_2seTW70ljAwIH01QDQ',
    appId: '1:1084003045571:ios:658c3804c385d3a80b9276',
    messagingSenderId: '1084003045571',
    projectId: 'gerenciadoreventos-bdf1c',
    storageBucket: 'gerenciadoreventos-bdf1c.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDv_lPSTlhTBOXh3gO22pmJgDbfnsdt7vk',
    appId: '1:1084003045571:web:97637b17e404b2ac0b9276',
    messagingSenderId: '1084003045571',
    projectId: 'gerenciadoreventos-bdf1c',
    authDomain: 'gerenciadoreventos-bdf1c.firebaseapp.com',
    storageBucket: 'gerenciadoreventos-bdf1c.appspot.com',
    measurementId: 'G-7XDSQV8C57',
  );
}