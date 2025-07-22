import 'package:flutter/material.dart';

class Skeleton extends StatelessWidget {
  final double? width, height;
  const Skeleton({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      ),
    );
  }
}
