// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyBSumCPGUvr56iTOtfNK5ABK8b-mTQtR6Y',
    appId: '1:996710448532:web:f2a43be5c241d861b22381',
    messagingSenderId: '996710448532',
    projectId: 'yijueun-a1290',
    authDomain: 'yijueun-a1290.firebaseapp.com',
    storageBucket: 'yijueun-a1290.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAv3JDngYBonmrZexrUzteE3MhhkNzjbNI',
    appId: '1:996710448532:android:81f32f0b300a401eb22381',
    messagingSenderId: '996710448532',
    projectId: 'yijueun-a1290',
    storageBucket: 'yijueun-a1290.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCo9xnpd9Dl--8t-PaWjd9Zbda06yHYGTk',
    appId: '1:996710448532:ios:beb88db76bdc63e8b22381',
    messagingSenderId: '996710448532',
    projectId: 'yijueun-a1290',
    storageBucket: 'yijueun-a1290.appspot.com',
    iosClientId: '996710448532-06ltfe3km6dg3879jsds7e61likkr77a.apps.googleusercontent.com',
    iosBundleId: 'com.example.yijueunJueun',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCo9xnpd9Dl--8t-PaWjd9Zbda06yHYGTk',
    appId: '1:996710448532:ios:beb88db76bdc63e8b22381',
    messagingSenderId: '996710448532',
    projectId: 'yijueun-a1290',
    storageBucket: 'yijueun-a1290.appspot.com',
    iosClientId: '996710448532-06ltfe3km6dg3879jsds7e61likkr77a.apps.googleusercontent.com',
    iosBundleId: 'com.example.yijueunJueun',
  );
}