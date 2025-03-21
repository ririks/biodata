import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyC5HlK5M0A79LR40puWM0W6B18p274pfPo", 
        appId: "1:787591260403:android:77207e8e3be8ba1e8e6f86", 
        messagingSenderId: "787591260403", 
        projectId: "biodata-ok-6be6f", 
        databaseURL: "https://console.firebase.google.com/project/biodata-ok-6be6f/", 
      ),
    );
  } catch (e) {
    print("Firebase initialization error: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}
