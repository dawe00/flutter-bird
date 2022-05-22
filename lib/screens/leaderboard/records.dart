import 'package:flappy_bird_flutter/screens/leaderboard/recordtile.dart';
import 'package:flappy_bird_flutter/model/record.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Records extends StatefulWidget {
  const Records({Key? key}) : super(key: key);

  @override
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  @override
  Widget build(BuildContext context) {
    final records = Provider.of<List<Record>>(context);

    return ListView.builder(
      itemCount: records.length,
      itemBuilder: (context, index){
        return RecordTile(record: records[index]);
      },
    );
  }
}
