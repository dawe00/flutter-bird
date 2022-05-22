import 'package:flutter/material.dart';

class MyPipe extends StatelessWidget {
  final double pipeX;
  final double pipeWidth;
  final double pipeHeight;
  final bool isBottom;

  const MyPipe({
    Key? key,
    required this.pipeX,
    required this.pipeHeight,
    required this.pipeWidth,
    required this.isBottom
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2 * pipeX + pipeWidth)/ (2 - pipeWidth),
          isBottom ? 1 : -1),
      child: Container(
        color: Colors.green,
        width: MediaQuery.of(context).size.width * pipeWidth / 2,
        height: MediaQuery.of(context).size.height * 3/4 * pipeHeight / 2,
      ),
    );
  }
}
