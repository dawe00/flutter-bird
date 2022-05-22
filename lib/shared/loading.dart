import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.blue,
              child: const Center(
                child: SpinKitFadingCircle(
                color: Colors.yellow,
                size: 50.0,
              ),
            ),
          ),
        ),
        Container( // Grass
          height: 25,
          color: Colors.green,
        ),
        Expanded( // Ground
          child: Container(
          color: Colors.brown,
          ),
        ),
      ]
    );
  }
}
