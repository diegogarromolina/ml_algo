import 'dart:typed_data';

import 'package:linalg/linalg.dart';

class InterceptPreprocessor {
  final double _interceptScale;

  const InterceptPreprocessor({double interceptScale = 1.0}) : _interceptScale = interceptScale;

  Matrix<Float32x4, Vector<Float32x4>> addIntercept(Matrix<Float32x4, Vector<Float32x4>> points) {
    if (_interceptScale == 0.0) {
      return points;
    }

    final _points = List<List<double>>(points.rowsNum);
    for (int i = 0; i < points.rowsNum; i++) {
      _points[i] = points[i].toList()
          ..insert(0, 1.0 * _interceptScale);
    }
    return Float32x4MatrixFactory.from(_points);
  }
}