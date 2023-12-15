import 'package:flutter/material.dart';

class SandClock extends CustomPainter {
  final double value;

  const SandClock({this.value = 0.0});
  @override
  void paint(Canvas canvas, Size size) {
    Paint stroke = Paint()
      ..color = const Color(0xFFfab96e)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    Paint fill = Paint()
      ..color = const Color(0xFFfab96e)
      ..style = PaintingStyle.fill;

    // Draw the flowing line..
    if (value > 0.0) {
      stroke.strokeWidth = 0.5;
      canvas.drawLine(
          Offset(size.width * 0.50, size.height * 0.5), Offset(size.width * 0.50, size.height * 0.68), stroke);
      stroke.strokeWidth = 3;
    }

    stroke.color = Colors.red;

    //Decreasing the upper-side color
    Path upperSide = Path();

    if (value * 1.6 < 0.08) {
      // top left
      upperSide.moveTo(size.width * (0.35), size.height * (0.32 + (value * 1.6)));
      // top right
      upperSide.lineTo(size.width * (0.65), size.height * (0.32 + (value * 1.6)));
      // middle right
      upperSide.lineTo(size.width * 0.65, size.height * 0.4);
      // bottom center
      upperSide.lineTo(size.width * (0.50), size.height * (0.5));
      // middle left
      upperSide.lineTo(size.width * 0.35, size.height * 0.4);
    } else {
      double percentDone = ((value - 0.05) * 20.0);
      // right corner
      upperSide.moveTo(size.width * (0.715 - ((value) * 1.6)) - percentDone * (value * 150),
          size.height * (0.32 + (value * 1.6) + percentDone * (value * 0.2)));
      // bottom
      upperSide.lineTo(size.width * (0.50), size.height * (0.5));
      // left corner
      upperSide.lineTo(size.width * (0.275 + ((value) * 1.6)) + percentDone * (value * 150),
          size.height * (0.32 + (value * 1.6) + percentDone * (value * 0.2)));
    }
    canvas.drawPath(upperSide, fill);

    //Increasing the lower-side color
    Path lowerSide = Path();
    if (value * 1.6 < 0.08) {
      // top left
      lowerSide.moveTo(size.width * (0.35), size.height * (0.68 - (value * 1.6)));
      // top right
      lowerSide.lineTo(size.width * (0.65), size.height * (0.68 - (value * 1.6)));
      // bottom right
      lowerSide.lineTo(size.width * 0.65, size.height * 0.68);
      // bottom left
      lowerSide.lineTo(size.width * 0.35, size.height * 0.68);
    } else {
      double percentDone = ((value - 0.05) * 20.0);
      double tempValue = percentDone / 10;

      // middle left
      lowerSide.moveTo(size.width * (0.35), size.height * (0.6));
      // top left
      lowerSide.lineTo(size.width * (0.34 + tempValue * 1.6), size.height * (0.6 - tempValue));
      // top right
      lowerSide.lineTo(size.width * (0.66 - tempValue * 1.6), size.height * (0.6 - tempValue));
      // middle right
      lowerSide.lineTo(size.width * (0.65), size.height * (0.6));
      // bottom right
      lowerSide.lineTo(size.width * 0.65, size.height * 0.68);
      // bottom left
      lowerSide.lineTo(size.width * 0.35, size.height * 0.68);
    }

    canvas.drawPath(lowerSide, fill);

    // Drawing the stroke line
    // lower side
    stroke.color = const Color.fromRGBO(255, 255, 255, 0.75);
    canvas.drawLine(
        Offset(size.width * 0.495, size.height * 0.5), Offset(size.width * 0.35, size.height * 0.6), stroke);
    // canvas.drawLine(Offset(size.width * 0.35, size.height * 0.6), Offset(size.width * 0.65, size.height * 0.6), stroke);
    canvas.drawLine(
        Offset(size.width * 0.65, size.height * 0.6), Offset(size.width * 0.505, size.height * 0.5), stroke);
    canvas.drawLine(
        Offset(size.width * 0.65, size.height * 0.68), Offset(size.width * 0.35, size.height * 0.68), stroke);
    canvas.drawLine(
        Offset(size.width * 0.35, size.height * 0.6), Offset(size.width * 0.35, size.height * 0.68), stroke);
    canvas.drawLine(
        Offset(size.width * 0.65, size.height * 0.6), Offset(size.width * 0.65, size.height * 0.68), stroke);

    //upper side
    canvas.drawLine(
        Offset(size.width * 0.505, size.height * 0.5), Offset(size.width * 0.65, size.height * 0.4), stroke);
    // canvas.drawLine(Offset(size.width * 0.65, size.height * 0.4), Offset(size.width * 0.35, size.height * 0.4), stroke);
    canvas.drawLine(
        Offset(size.width * 0.35, size.height * 0.4), Offset(size.width * 0.495, size.height * 0.5), stroke);
    canvas.drawLine(
        Offset(size.width * 0.35, size.height * 0.32), Offset(size.width * 0.65, size.height * 0.32), stroke);
    canvas.drawLine(
        Offset(size.width * 0.35, size.height * 0.32), Offset(size.width * 0.35, size.height * 0.4), stroke);
    canvas.drawLine(
        Offset(size.width * 0.65, size.height * 0.32), Offset(size.width * 0.65, size.height * 0.4), stroke);

    upperSide.close();
    lowerSide.close();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
