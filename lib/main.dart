import 'draw_page/draw_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(const DrawIt());

class DrawIt extends StatelessWidget {
  const DrawIt({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Draw It',
      home: DrawPage(),
    );
  }
}