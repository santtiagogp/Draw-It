import 'package:flutter/material.dart';

class DrawingModel {
  List<Offset> offsets;
  Color color;
  double width;

  DrawingModel({
    this.offsets = const [],
    this.color = Colors.black,
    this.width = 3
  });

  DrawingModel copyWith({List<Offset>? offsets}) {
    return DrawingModel(
      color: color,
      width: width,
      offsets: offsets ?? this.offsets,
    );
  }

}