import 'package:ml_algo/src/decision_tree_solver/leaf_label/leaf_label.dart';
import 'package:ml_linalg/matrix.dart';

abstract class TreeLeafLabelFactory {
  TreeLeafLabel create(Matrix samples, int targetIdx);
}
