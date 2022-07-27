import 'package:flutter/material.dart';


class Visualizer extends StatelessWidget {
  final List<Color> visualizerColor;
  const Visualizer({super.key, required this.visualizerColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: visualizerColor.map(
        (color) => Container(
                  margin: const EdgeInsets.only(right: 1),
                  width: 4,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: color
                  ),
      )).toList(),
    );
  }
}
