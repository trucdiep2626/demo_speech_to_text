import 'package:demo_speech_to_text/speech_to_text_demo.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice assistant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpeechToTextDemo(),
    );
  }
}


