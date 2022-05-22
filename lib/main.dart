import 'package:firebase_core/firebase_core.dart';
import 'package:flappy_bird_flutter/services/auth.dart';
import 'package:flappy_bird_flutter/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        return StreamProvider<Player?>.value(
          value: AuthService().user,
          initialData: null,
          child: const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Wrapper(),
          ),
        );
      }
    );
  }
}
