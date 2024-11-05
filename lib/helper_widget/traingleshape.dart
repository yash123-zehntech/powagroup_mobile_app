import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// class TrianglePainter extends CustomPainter {
//   final Color strokeColor;
//   final PaintingStyle paintingStyle;
//   final double strokeWidth;

//   TrianglePainter(
//       {this.strokeColor = Colors.black,
//       this.strokeWidth = 3,
//       this.paintingStyle = PaintingStyle.stroke});

//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = strokeColor
//       ..strokeWidth = strokeWidth
//       ..style = paintingStyle;

//     canvas.drawPath(getTrianglePath(size.width, size.height), paint);
//   }

//   Path getTrianglePath(double x, double y) {
//     return Path()
//       ..moveTo(0, y)
//       ..lineTo(x / 2, 0)
//       ..lineTo(x, y)
//       ..lineTo(0, y);
//   }

//   @override
//   bool shouldRepaint(TrianglePainter oldDelegate) {
//     return oldDelegate.strokeColor != strokeColor ||
//         oldDelegate.paintingStyle != paintingStyle ||
//         oldDelegate.strokeWidth != strokeWidth;
//   }
// }

class PriceTagPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color =
          Color.fromARGB(23, 53, 236, 120) //Color.fromARGB(255, 233, 73, 73)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    Path path = Path();

    path
      ..lineTo(size.width * .85, 0) // .85 amount of right gap
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width * .85, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DrawClipper extends CustomPainter {
  var sized;
  final Color backgroundColor;
  final Color borderColor;
  final double borderThickness;
  DrawClipper(
      {this.sized,
      required this.backgroundColor,
      required this.borderColor,
      this.borderThickness = -1});
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    final paint = Paint()..color = backgroundColor;

    path.moveTo(0, 0);
    path.lineTo(sized.width * 3.5 / 4, 0.0);
    path.lineTo(sized.width, sized.height / 2);
    path.lineTo(sized.width * 3.5 / 4, sized.height);
    path.lineTo(0.0, sized.height);
    path.lineTo(sized.width * .5 / 4, sized.height / 2);
    path.close();
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderThickness;

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class DrawArrowClipper extends CustomPainter {
  final Color backgroundColor;
  final Color borderColor;
  var sized;
  final double borderThickness;
  DrawArrowClipper(
      {this.sized,
      required this.backgroundColor,
      required this.borderColor,
      this.borderThickness = -10});
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    final paint = Paint()..color = backgroundColor;
    path.moveTo(0, 0);
    path.lineTo(sized.width * 3.5 / 4, 0.0);
    path.lineTo(sized.width, sized.height / 2);
    path.lineTo(sized.width * 3.5 / 4, sized.height);
    path.lineTo(0.0, sized.height);
    path.close();

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderThickness;
    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
// class ChevronClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Canvas canvas, Size size) {
//     final Path path = Path();
//     path.moveTo(0, 0);
//     path.lineTo(size.width * 3.5 / 4, 0.0);
//     path.lineTo(size.width, size.height / 2);
//     path.lineTo(size.width * 3.5 / 4, size.height);
//     path.lineTo(0.0, size.height);
//     path.lineTo(size.width * .5 / 4, size.height / 2);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(ChevronClipper oldClipper) => this != oldClipper;
// }

class ArrowClippers extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 3.5 / 4, 0.0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width * 3.5 / 4, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(ArrowClippers oldClipper) => this != oldClipper;
}
