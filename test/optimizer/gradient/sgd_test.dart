import 'dart:typed_data';

import 'package:dart_ml/src/core/implementation.dart';
import 'package:dart_ml/src/core/interface.dart';
import 'package:dart_ml/src/di/injector.dart' show coreInjector;
import 'package:di/di.dart';
import 'package:mockito/mockito.dart';
import 'package:simd_vector/vector.dart';
import 'package:test/test.dart';

class SGDRandomizerMock extends Mock implements Randomizer {}
class InitialWeightsGeneratorMock extends Mock implements InitialWeightsGenerator {}
class LearningRateGeneratorMock extends Mock implements LearningRateGenerator {}
class GradientCalculatorMock extends Mock implements GradientCalculator {}
class LossFunctionMock extends Mock implements LossFunction {}
class ScoreFunctionMock extends Mock implements ScoreFunction {}

void main() {
  group('Mini batch gradient descent optimizer', () {
    const int iterationsNumber = 3;
    const lambda = .00001;
    const delta = .0001;

    LearningRateGenerator learningRateGeneratorMock;
    Randomizer randomizerMock;
    GradientCalculator gradientCalculator;
    LossFunctionMock lossFunctionMock;
    ScoreFunctionMock scoreFunctionMock;

    Optimizer optimizer;
    List<Float32x4Vector> data;
    Float32List labels;

    setUp(() {
      randomizerMock = new SGDRandomizerMock();
      learningRateGeneratorMock = new LearningRateGeneratorMock();
      gradientCalculator = new GradientCalculatorMock();

      coreInjector = new ModuleInjector([
        new Module()
          ..bind(Randomizer, toValue: randomizerMock)
          ..bind(InitialWeightsGenerator, toFactory: () => new InitialWeightsGeneratorMock())
          ..bind(LearningRateGenerator, toValue: learningRateGeneratorMock)
          ..bind(GradientCalculator, toValue: gradientCalculator)
          ..bind(LossFunction, toValue: lossFunctionMock)
          ..bind(ScoreFunction, toValue: scoreFunctionMock)
      ]);

      optimizer = GradientOptimizerFactory.createStochasticOptimizer(1e-5, null, iterationsNumber, null, lambda, delta);

      data = [
        new Float32x4Vector.from([230.1, 37.8, 69.2]),
        new Float32x4Vector.from([44.5, 39.3, 45.7]),
        new Float32x4Vector.from([54.5, 29.3, 25.1]),
        new Float32x4Vector.from([41.7, 34.1, 55.5])
      ];

      labels = new Float32List.fromList([22.1, 10.4, 20.0, 30.0]);

      when(learningRateGeneratorMock.getNextValue()).thenReturn(1.0);
      when(gradientCalculator.getGradient(any, any, [data[0]], [labels[0], lambda], 0.0001))
          .thenReturn(new Float32x4Vector.from([1.0, 1.0, 1.0]));
      when(gradientCalculator.getGradient(any, any, [data[1]], [labels[1], lambda], 0.0001))
          .thenReturn(new Float32x4Vector.from([0.0, 0.0, 0.0]));
      when(gradientCalculator.getGradient(any, any, [data[2]], [labels[2], lambda], 0.0001))
          .thenReturn(new Float32x4Vector.from([0.01, 0.01, 0.01]));
      when(gradientCalculator.getGradient(any, any, [data[3]], [labels[3], lambda], 0.0001))
          .thenReturn(new Float32x4Vector.from([100.0, 100.0, 0.00001]));

      when(randomizerMock.getIntegerFromInterval(0, 4)).thenReturn(0);
    });

    test('should find optimal weights for the given data', () {
      optimizer.findExtrema(data, labels, weights: new Float32x4Vector.from([0.0, 0.0, 0.0]));

      verify(randomizerMock.getIntegerFromInterval(0, 4)).called(iterationsNumber);
      verify(learningRateGeneratorMock.getNextValue()).called(iterationsNumber);

      verify(gradientCalculator.getGradient(any, any, [data[0]], [labels[0], lambda], 0.0001))
          .called(iterationsNumber);

      verifyNever(gradientCalculator.getGradient(any, any, [data[1]], [labels[1], lambda], 0.0001));
      verifyNever(gradientCalculator.getGradient(any, any, [data[2]], [labels[2], lambda], 0.0001));
      verifyNever(gradientCalculator.getGradient(any, any, [data[3]], [labels[3], lambda], 0.0001));
    });
  });
}
