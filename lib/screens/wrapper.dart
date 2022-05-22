import 'package:flappy_bird_flutter/screens/auth/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game/game.dart';
import '../model/player.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Player?>(context);

    if(user == null){
      return const Authenticate();
    } else {
      return const Game();
    }
  }
}
