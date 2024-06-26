import '../../model/drawing_model.dart';
import 'package:flutter/material.dart';

class Sketcher extends CustomPainter {

  Sketcher(this.points);

  final List<DrawingModel> points;

  @override
  void paint(Canvas canvas, Size size) {

    for (var drawingSketch in points) {
      Paint paint = Paint()
        ..color = drawingSketch.color
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true
        ..strokeWidth = drawingSketch.width;
      
      for(int i = 0; i < drawingSketch.offsets.length; i++) {
        bool notLastOffset = i != drawingSketch.offsets.length - 1;

        if (notLastOffset) {
          final current = drawingSketch.offsets[i];
          final next = drawingSketch.offsets[i + 1];
          canvas.drawLine(current, next, paint);
        }
      }
    }

  }

  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    return true;
  }

}