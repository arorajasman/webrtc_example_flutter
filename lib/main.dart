import 'package:flutter/material.dart';
import 'package:webrtc_example_flutter/pages/user_call_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: AudioCallPage(),
    );
  }
}
