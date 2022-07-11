import 'package:flutter/material.dart';
import 'package:automated_chat_bot/home.dart';
import 'package:flutter/src/material/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Chat Bot',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: ChatWindow(),
        );
      }
    );
  }
}