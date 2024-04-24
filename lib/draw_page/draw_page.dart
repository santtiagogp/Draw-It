import 'package:flutter/material.dart';

import '../model/drawing_model.dart';
import 'sketcher/sketcher.dart';

class DrawPage extends StatefulWidget {
  const DrawPage({super.key});

  @override
  State<DrawPage> createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {

  List<DrawingModel> points = List.empty(growable: true);
  List<DrawingModel> pointsHistory = List.empty(growable: true);

  DrawingModel? currentSketch;

  Color currentColor = Colors.black;
  double currentWidth = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanStart: (details) {
          setState(() {
            RenderBox box = context.findRenderObject() as RenderBox;
            currentSketch = DrawingModel(
              offsets: [
                box.globalToLocal(details.globalPosition)
              ],
              color: currentColor,
              width: currentWidth,
            );

            if (currentSketch == null) return;
            points.add(currentSketch!);
            pointsHistory = List.of(points);
          });
        },
        onPanUpdate: (details) {
          setState(() {
            RenderBox box = context.findRenderObject() as RenderBox;
            if (currentSketch == null) return;

            currentSketch = currentSketch?.copyWith(
              offsets: currentSketch!.offsets
                ..add(box.globalToLocal(details.globalPosition)),
            );
            points.last = currentSketch!;
            pointsHistory = List.of(points);
          });
        },
        onPanEnd: (_) {
          currentSketch = null;
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.height,
          child: CustomPaint(
            painter: Sketcher(points),
          ),
        ),
      ),
    );
  }
}