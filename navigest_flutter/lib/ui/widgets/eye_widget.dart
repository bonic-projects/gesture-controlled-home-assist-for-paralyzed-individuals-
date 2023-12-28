import 'package:flutter/material.dart';
import 'dart:math' as math;

class EyeWidget extends StatelessWidget {
  final double eyeX;
  final double eyeY;

  const EyeWidget({super.key, required this.eyeX, required this.eyeY});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Positioned(
            right: MediaQuery.of(context).size.width / 2 + eyeX + 50,
            top: MediaQuery.of(context).size.height / 2 - 100 + eyeY,
            child: SingleEye(
              eyeX: eyeX,
              eyeY: eyeY,
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - eyeX + 50,
            top: MediaQuery.of(context).size.height / 2 - 100 + eyeY,
            child: SingleEye(
              eyeX: eyeX,
              eyeY: eyeY,
            ),
          ),
        ],
      ),
    );
  }
}

class SingleEye extends StatelessWidget {
  final double eyeX;
  final double eyeY;

  const SingleEye({super.key, required this.eyeX, required this.eyeY});

  @override
  Widget build(BuildContext context) {
    double eyeWidth = 200 + (2 * eyeX);
    double eyeHeight = 200 + (2 * eyeY);

    return Center(
      child: Container(
        width: eyeWidth,
        height: eyeHeight,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(eyeWidth / 2),
          border: Border.all(color: Color(0xFF096EB6), width: 30),
        ),
      ),
    );
  }
}
