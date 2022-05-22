import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flappy_bird_flutter/model/record.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({ this.uid });

  final CollectionReference leaderboard = FirebaseFirestore.instance.collection("records");

  Future<int> get score async {
    var docSnapshot = await leaderboard.doc(uid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;
      var score = data?['score'];
      return await score;
    } else {
      return 0;
    }
  }

  Future updateScore(int score) async{
    return await leaderboard.doc(uid)
      .update({ 'score' : score });
  }

  Future setUserData(String? name, int score) async{
    return await leaderboard.doc(uid)
      .set({ 'name' : name,
             'score' : score
      });
  }

  List<Record> _recordListFromSnapshot(QuerySnapshot snapshot){
    List<Record> records = snapshot.docs.map((doc){
      return Record(
        name: doc.get('name') ?? "",
        score: doc.get('score') ?? 0
      );
    }).toList();
    sortRecords(records);
    return records;
  }

  void sortRecords(List<Record> records){
    records.sort((a, b) => b.score.compareTo(a.score));
  }

  Stream<List<Record>> get records {
    return leaderboard.snapshots()
    .map(_recordListFromSnapshot);
  }
}