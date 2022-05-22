import 'package:flappy_bird_flutter/screens/leaderboard/records.dart';
import 'package:flappy_bird_flutter/model/record.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flappy_bird_flutter/services/database.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Record>?>.value(
      value: DatabaseService().records,
      initialData: null,
      child: Scaffold(
        backgroundColor: Colors.brown,
        appBar: AppBar(
          title: const Text("Leaderboard"),
          backgroundColor: Colors.green,
          elevation: 0.0,
        ),
        body:  const Records()
      ),
    );
  }
}
