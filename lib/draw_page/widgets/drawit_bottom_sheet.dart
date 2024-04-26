import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class DrawItBottomSheet extends StatefulWidget {
  const DrawItBottomSheet({
    super.key,
    required this.selectedColor,
    required this.currentWidth,
    required this.onColorChanged,
    required this.onSliderChanged
  });

  final Color selectedColor;
  final double currentWidth;
  final void Function(Color) onColorChanged;
  final void Function(double) onSliderChanged;

  @override
  State<DrawItBottomSheet> createState() => _DrawItBottomSheetState();
}

class _DrawItBottomSheetState extends State<DrawItBottomSheet> {

  late double width;
  late Color color;

  @override
  void initState() {
    width = widget.currentWidth;
    color = widget.selectedColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          ColorPicker(
            color: widget.selectedColor,
            pickersEnabled: const {
              ColorPickerType.wheel: true,
              ColorPickerType.accent: false,
              ColorPickerType.primary: false
            },
            onColorChanged: widget.onColorChanged,
            enableOpacity: true,
          ),
          Slider(
            value: width,
            label: width.toString(),
            max: 30,
            min: 1,
            onChanged: (width) {
              this.width = width;
              setState(() {
                widget.onSliderChanged(width);
              });
            }
          )
        ],
      ),
    );
  }
}