import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';

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

  final GlobalKey sketchKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.undo),
            onPressed: (){
              if (points.isNotEmpty && pointsHistory.isNotEmpty) {
                setState(() {
                  points.removeLast();
                });
              }
            }
          ),
          FloatingActionButton(
            child: const Icon(Icons.delete),
            onPressed: (){
              if (points.isNotEmpty && pointsHistory.isNotEmpty) {
                setState(() {
                  points.clear();
                });
              }
            }
          ),
          FloatingActionButton(
            child: const Icon(Icons.redo),
            onPressed: (){
              if (points.isNotEmpty && pointsHistory.isNotEmpty) {
                setState(() {
                  if(points.length < pointsHistory.length) {
                    final index = points.length;
                    points.add(pointsHistory[index]);
                  }
                });
              }
            }
          ),
          FloatingActionButton(
            child: const Icon(Icons.save),
            onPressed: () => saveSketch()
          ),
          FloatingActionButton(
            child: const Icon(Icons.menu),
            onPressed: (){
              
            }
          )
        ],
      ),
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
        child: RepaintBoundary(
          key: sketchKey,
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.height,
            child: CustomPaint(
              painter: Sketcher(points),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveSketch() async {
    RenderRepaintBoundary boundary
      = sketchKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 2.0);
    ByteData byteData
      = await image.toByteData(format: ui.ImageByteFormat.png) as ByteData;
    Uint8List pngBytes = byteData.buffer.asUint8List();
    DateTime date = DateTime.now();
    date.toString();
    await Gal.putImageBytes(pngBytes, name: 'draw-it-$date');
  }
}