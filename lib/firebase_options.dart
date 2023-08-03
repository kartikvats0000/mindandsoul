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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC95qzfqhGV8Ij2rD6E_hB_dOq4l36iWeI',
    appId: '1:1072346488267:android:959028c54cf346583a2a4e',
    messagingSenderId: '1072346488267',
    projectId: 'mind-and-soul-fe45b',
    storageBucket: 'mind-and-soul-fe45b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCNm4_JvNr6NSbxO6Q0Nm5gn2i8iixSIWA',
    appId: '1:1072346488267:ios:01d08ff67a6aefe43a2a4e',
    messagingSenderId: '1072346488267',
    projectId: 'mind-and-soul-fe45b',
    storageBucket: 'mind-and-soul-fe45b.appspot.com',
    iosClientId: '1072346488267-7nch4gm1t27s7578kp0lcoh3vua17lu9.apps.googleusercontent.com',
    iosBundleId: 'com.mindandsoul.mindandsoul',
  );
}
