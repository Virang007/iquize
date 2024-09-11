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
    apiKey: 'AIzaSyBbOmtmfu8AALdTR-okcOvT5T3o3yfWKuA',
    appId: '1:579414065580:web:1e0296b975353516d1ba09',
    messagingSenderId: '579414065580',
    projectId: 'uize-7d907',
    authDomain: 'uize-7d907.firebaseapp.com',
    storageBucket: 'uize-7d907.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBr_dC_4DVLlnErEGqdsj1FNuKuzVPg9wA',
    appId: '1:579414065580:android:5d5e5210c6709584d1ba09',
    messagingSenderId: '579414065580',
    projectId: 'uize-7d907',
    storageBucket: 'uize-7d907.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAYynPfcoHKmMOPFMvMuUXjLTyKzQq4xzc',
    appId: '1:579414065580:ios:a686992b142fb336d1ba09',
    messagingSenderId: '579414065580',
    projectId: 'uize-7d907',
    storageBucket: 'uize-7d907.appspot.com',
    iosBundleId: 'com.example.quize',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAYynPfcoHKmMOPFMvMuUXjLTyKzQq4xzc',
    appId: '1:579414065580:ios:a686992b142fb336d1ba09',
    messagingSenderId: '579414065580',
    projectId: 'uize-7d907',
    storageBucket: 'uize-7d907.appspot.com',
    iosBundleId: 'com.example.quize',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBbOmtmfu8AALdTR-okcOvT5T3o3yfWKuA',
    appId: '1:579414065580:web:5817e59a59444150d1ba09',
    messagingSenderId: '579414065580',
    projectId: 'uize-7d907',
    authDomain: 'uize-7d907.firebaseapp.com',
    storageBucket: 'uize-7d907.appspot.com',
  );
}
