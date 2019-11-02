import 'package:ml_algo/src/decision_tree_solver/splitter/nominal_splitter/nominal_splitter.dart';
import 'package:ml_algo/src/decision_tree_solver/splitter/nominal_splitter/nominal_splitter_factory.dart';
import 'package:ml_algo/src/decision_tree_solver/splitter/nominal_splitter/nominal_splitter_impl.dart';

class NominalTreeSplitterFactoryImpl implements
    NominalTreeSplitterFactory {

  const NominalTreeSplitterFactoryImpl();

  @override
  NominalTreeSplitter create() =>
      const NominalTreeSplitterImpl();
}