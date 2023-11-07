#!/bin/bash

echo "Generating empty lib/firebase_options.dart..."
echo "import 'package:firebase_core/firebase_core.dart' show FirebaseOptions; class DefaultFirebaseOptions { static FirebaseOptions get currentPlatform { return const FirebaseOptions( apiKey: '', appId: '', messagingSenderId: '', projectId: ''); } }" > lib/firebase_options.dart