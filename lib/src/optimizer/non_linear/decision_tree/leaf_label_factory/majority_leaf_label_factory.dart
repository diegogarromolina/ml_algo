import 'dart:collection';

import 'package:ml_algo/src/optimizer/non_linear/decision_tree/decision_tree_leaf_label.dart';
import 'package:ml_algo/src/optimizer/non_linear/decision_tree/leaf_label_factory/leaf_label_factory.dart';
import 'package:ml_algo/src/optimizer/non_linear/decision_tree/observations_distribution_counter/distribution_counter.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';
import 'package:quiver/iterables.dart' as quiver_iterables;
import 'package:tuple/tuple.dart';
import 'package:xrange/zrange.dart';

class MajorityLeafLabelFactory implements DecisionTreeLeafLabelFactory {
  MajorityLeafLabelFactory(this.distributionCounter);

  final ObservationsDistributionCounter distributionCounter;

  @override
  DecisionTreeLeafLabel create(Matrix observations, ZRange outcomesColumnRange,
      bool isClassLabelCategorical) {
    final outcomes = observations.submatrix(columns: outcomesColumnRange);
    final totalRecordsCount = outcomes.rowsNum;

    if (isClassLabelCategorical) {
      final labelData = _getLabelData<Vector>(outcomes.rows, totalRecordsCount);
      return DecisionTreeLeafLabel.categorical(labelData.item1,
          probability: labelData.item2);
    }

    final labelColumn = outcomes.toVector();
    final labelData = _getLabelData<double>(labelColumn, totalRecordsCount);
    return DecisionTreeLeafLabel.numerical(labelData.item1,
        probability: labelData.item2);
  }

  Tuple2<T, double> _getLabelData<T>(Iterable<T> values, int totalCount) {
    final distribution = distributionCounter.count<T>(values, totalCount);
    final targetLabelEntry = _findEntryWithMaxProbability(distribution);
    return Tuple2(targetLabelEntry.key, targetLabelEntry.value);
  }

  MapEntry<T, double> _findEntryWithMaxProbability<T>(
      HashMap<T, double> distribution) =>
    quiver_iterables.max<MapEntry<T, double>>(
      distribution.entries, (first, second) {
        final diff = first.value - second.value;
        if (diff < 0) return -1;
        if (diff > 0) return 1;
        return 0;
      },
    );
}
