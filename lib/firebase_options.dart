
import 'package:firebase_core/firebase_core.dart'
    show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    throw UnsupportedError(
      'Firebase n’est pas encore configuré pour cette plateforme.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCW-f97jSpxlCwNHR0DFfbDqxW8CumqUy8',
    appId: '1:705221476360:web:c393d65f926db8cc9fd1bd',
    messagingSenderId: '705221476360',
    projectId: 'devmob-bookshare-28d06',
    authDomain: 'devmob-bookshare-28d06.firebaseapp.com',
    storageBucket: 'devmob-bookshare-28d06.firebasestorage.app',
    measurementId: 'G-BC2DCPPWW7',
  );
}
