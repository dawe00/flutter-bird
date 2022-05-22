import 'dart:async';
import 'package:flappy_bird_flutter/screens/game/bird.dart';
import 'package:flappy_bird_flutter/screens/game/pipes.dart';
import 'package:flappy_bird_flutter/screens/leaderboard/leaderboard.dart';
import 'package:flappy_bird_flutter/services/auth.dart';
import 'package:flappy_bird_flutter/services/database.dart';
import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  final AuthService _auth = AuthService();

  // Bird settings
  static double birdY = 0;
  double birdWidth = 0.21;
  double birdHeight = 0.1;
  double startHeight = birdY;
  double height = 0;

  // Physics settings
  double velocity = 3;
  double gravity = -5;

  // Game settings
  double time = 0;
  bool gameRunning = false;
  bool countScore = false;
  int score = 0;
  int highscore = 0;
  int scoreCounter = 0;
  bool newHighscore = false;

  // Pipe settings
  static List<double> pipeX = [2, 2 + 1.5];
  static double pipeWidth = 0.3;
  List<List<double>> pipeHeight = [
    [0.6, 0.4],
    [0.4, 0.6],
  ];

  @override
  void initState () {
    super.initState();
    setState(()  {
      setScore();
    });
  }

  void setScore() async {
    highscore = await DatabaseService(uid: _auth.uid).score;
  }

  void jump(){
    setState(() {
      time = 0;
      startHeight = birdY;
    });
  }

  bool birdDied(){
    if(birdY <-1 || birdY > 1){
      return true;
    }
    for(int i = 0; i < pipeX.length; i++){
      if(pipeX[i] <= birdWidth &&
         pipeX[i] + pipeWidth >= -birdWidth &&
         (birdY <= -1 + pipeHeight[i][0] ||
          birdY + birdHeight >= 1- pipeHeight[i][1])){
        return true;
      }
    }
    return false;
  }

  void startGame(){
    gameRunning = true;
    Timer.periodic(const Duration(milliseconds: 60), (timer) {
      time += 0.05;
      scoreCounter++;
      height = gravity * time * time + velocity * time;
      setState(() {
        // Move bird
        birdY = startHeight - height;

        // Move pipes
        for(int i = 0; i < pipeX.length; i++){
          if(pipeX[i] < 0){
            countScore = true;
          }
          if(pipeX[i] < -2){
            pipeX[i] += 3.5;
          } else {
            pipeX[i] -= 0.05;
          }
        }

        // Count score
        if(scoreCounter % 30 == 0 && countScore){
          score++;
          if(score > highscore){
            highscore++;
            newHighscore = true;
          }
        }

      });
      if(birdDied()){
        timer.cancel();
        gameOver();
      }
    });
  }

  void resetGame(){
    Navigator.pop(context);
    setState(() {
      gameRunning = false;
      birdY = 0;
      time = 0;
      score = 0;
      scoreCounter = 0;
      startHeight = birdY;
      for(int i = 0; i < pipeX.length; i++){
        pipeX[i] = (i * 1.5 + 2);
      }
    });
  }

  void gameOver(){
    countScore = false;
    if(newHighscore){
      DatabaseService(uid: _auth.uid).updateScore(score);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          backgroundColor: Colors.deepOrange,
          title: Column(
            children: [
              const Text( "G A M E  O V E R",  style: TextStyle(color: Colors.white),
            ),
              newHighscore ? const Text("N E W  H I G H S C O R E!",style: TextStyle(color: Colors.white, fontSize: 13)) : const Text("")
            ]
          ),
          actions: [
            GestureDetector(
              onTap: resetGame,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  alignment: const Alignment(0,0),
                  padding: const EdgeInsets.all(7),
                  color: Colors.white,
                  child: const Text(
                      "PLAY AGAIN",
                      style: TextStyle(color: Colors.brown),
                  ),
                ),
              ),
            )
          ],
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    void _showLeaderboardPanel(){
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
          child: const Leaderboard()
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flappy Bird"),
        backgroundColor: Colors.blue[700],
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            icon: const Icon(Icons.person),
            label: const Text("Leaderboard"),
            onPressed: ()  {
              _showLeaderboardPanel();
            },
          ),
          FlatButton.icon(
            icon: const Icon(Icons.backup),
            label: const Text("Logout"),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ]
      ),
      body: Center(
        child:
          GestureDetector(
            onTap: gameRunning ? jump : startGame,
            child: Scaffold(
              body: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.blue,
                      child: Center(
                        child: Stack(
                          children: [
                          MyBird( // Bird
                            birdY: birdY,
                            birdWidth: birdWidth,
                            birdHeight: birdHeight,
                          ),
                          Container( // Title
                            alignment: const Alignment(0, -0.25),
                            child: gameRunning ?
                            const Text("") : const Text("T A P  T O  P L A Y", style: TextStyle(fontSize: 15))
                          ),
                          MyPipe( // First top
                            pipeX: pipeX[0],
                            pipeWidth: pipeWidth,
                            pipeHeight: pipeHeight[0][0],
                            isBottom: false,
                          ),
                          MyPipe( // First bottom
                           pipeX: pipeX[0],
                           pipeWidth: pipeWidth,
                           pipeHeight: pipeHeight[0][1],
                           isBottom: true,
                          ),
                          MyPipe( // Second top
                            pipeX: pipeX[1],
                            pipeWidth: pipeWidth,
                            pipeHeight: pipeHeight[1][0],
                            isBottom: false,
                          ),
                          MyPipe( // Second bottom
                            pipeX: pipeX[1],
                            pipeWidth: pipeWidth,
                            pipeHeight: pipeHeight[1][1],
                            isBottom: true,
                          ),
                        ]),
                      ),
                    )
                  ),
                  Container( // Grass
                    height: 25,
                    color: Colors.green,
                  ),
                  Expanded( // Ground
                    child: Container(
                      color: Colors.brown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        Column( // Current score
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("SCORE", style: TextStyle(color: Colors.white, fontSize: 20),),
                            const SizedBox( height: 20),
                            Text(score <= 0 ? 0.toString() : score.toString(), style: const TextStyle(color: Colors.white, fontSize: 40),)
                          ],
                        ),
                        Column( // High score
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("BEST", style: TextStyle(color: Colors.white, fontSize: 20),),
                            const SizedBox( height: 20),
                            Text(highscore.toString(), style: const TextStyle(color: Colors.white, fontSize: 40),),
                          ],
                        ),
                      ],),
                    ),
                  ),
                ],
              )
            ),
          ),
      )
    );
  }
}
