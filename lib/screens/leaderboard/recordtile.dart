import 'package:flappy_bird_flutter/model/record.dart';
import 'package:flutter/material.dart';

class RecordTile extends StatelessWidget {
  final Record record;

  const RecordTile({Key? key, required this. record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6, 20.0, 0),
        child: ListTile(
          leading: Image.asset('lib/images/bird.png'),
          title: Text(record.name),
          subtitle: Text(record.score.toString())
        ),
      ),
    );
  }
}
