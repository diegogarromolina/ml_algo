// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'softmax_regressor_impl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SoftmaxRegressorImpl _$SoftmaxRegressorImplFromJson(Map<String, dynamic> json) {
  return $checkedNew('SoftmaxRegressorImpl', json, () {
    $checkKeys(json, allowedKeys: const [
      'OT',
      'IL',
      'ILR',
      'MCU',
      'L',
      'RT',
      'RS',
      'BS',
      'FDN',
      'LR',
      'ICT',
      'IC',
      'CN',
      'FI',
      'IS',
      'CBC',
      'DT',
      'LF',
      'PL',
      'NL',
      'CPI',
      r'$V'
    ]);
    final val = SoftmaxRegressorImpl(
      $checkedConvert(
          json,
          'OT',
          (v) =>
              const LinearOptimizerTypeJsonConverter().fromJson(v as String)),
      $checkedConvert(json, 'IL', (v) => v as int),
      $checkedConvert(json, 'ILR', (v) => (v as num)?.toDouble()),
      $checkedConvert(json, 'MCU', (v) => (v as num)?.toDouble()),
      $checkedConvert(json, 'L', (v) => (v as num)?.toDouble()),
      $checkedConvert(json, 'RT',
          (v) => const RegularizationTypeJsonConverter().fromJson(v as String)),
      $checkedConvert(json, 'RS', (v) => v as int),
      $checkedConvert(json, 'BS', (v) => v as int),
      $checkedConvert(json, 'FDN', (v) => v as bool),
      $checkedConvert(json, 'LR',
          (v) => const LearningRateTypeJsonConverter().fromJson(v as String)),
      $checkedConvert(
          json,
          'ICT',
          (v) => const InitialCoefficientsTypeJsonConverter()
              .fromJson(v as String)),
      $checkedConvert(
          json,
          'IC',
          (v) =>
              const MatrixJsonConverter().fromJson(v as Map<String, dynamic>)),
      $checkedConvert(
          json,
          'CBC',
          (v) =>
              const MatrixJsonConverter().fromJson(v as Map<String, dynamic>)),
      $checkedConvert(json, 'CN', (v) => (v as List)?.map((e) => e as String)),
      $checkedConvert(json, 'LF', (v) => fromLinkFunctionJson(v as String)),
      $checkedConvert(json, 'FI', (v) => v as bool),
      $checkedConvert(json, 'IS', (v) => v as num),
      $checkedConvert(json, 'PL', (v) => v as num),
      $checkedConvert(json, 'NL', (v) => v as num),
      $checkedConvert(
          json, 'CPI', (v) => (v as List)?.map((e) => e as num)?.toList()),
      $checkedConvert(
          json, 'DT', (v) => const DTypeJsonConverter().fromJson(v as String)),
      schemaVersion: $checkedConvert(json, r'$V', (v) => v as int),
    );
    return val;
  }, fieldKeyMap: const {
    'optimizerType': 'OT',
    'iterationsLimit': 'IL',
    'initialLearningRate': 'ILR',
    'minCoefficientsUpdate': 'MCU',
    'lambda': 'L',
    'regularizationType': 'RT',
    'randomSeed': 'RS',
    'batchSize': 'BS',
    'isFittingDataNormalized': 'FDN',
    'learningRateType': 'LR',
    'initialCoefficientsType': 'ICT',
    'initialCoefficients': 'IC',
    'coefficientsByClasses': 'CBC',
    'targetNames': 'CN',
    'linkFunction': 'LF',
    'fitIntercept': 'FI',
    'interceptScale': 'IS',
    'positiveLabel': 'PL',
    'negativeLabel': 'NL',
    'costPerIteration': 'CPI',
    'dtype': 'DT',
    'schemaVersion': r'$V'
  });
}

Map<String, dynamic> _$SoftmaxRegressorImplToJson(
    SoftmaxRegressorImpl instance) {
  final val = <String, dynamic>{
    'OT':
        const LinearOptimizerTypeJsonConverter().toJson(instance.optimizerType),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('IL', instance.iterationsLimit);
  val['ILR'] = instance.initialLearningRate;
  writeNotNull('MCU', instance.minCoefficientsUpdate);
  writeNotNull('L', instance.lambda);
  writeNotNull(
      'RT',
      const RegularizationTypeJsonConverter()
          .toJson(instance.regularizationType));
  writeNotNull('RS', instance.randomSeed);
  val['BS'] = instance.batchSize;
  val['FDN'] = instance.isFittingDataNormalized;
  val['LR'] =
      const LearningRateTypeJsonConverter().toJson(instance.learningRateType);
  writeNotNull(
      'ICT',
      const InitialCoefficientsTypeJsonConverter()
          .toJson(instance.initialCoefficientsType));
  writeNotNull(
      'IC', const MatrixJsonConverter().toJson(instance.initialCoefficients));
  val['CN'] = instance.targetNames?.toList();
  val['FI'] = instance.fitIntercept;
  val['IS'] = instance.interceptScale;
  val['CBC'] =
      const MatrixJsonConverter().toJson(instance.coefficientsByClasses);
  val['DT'] = const DTypeJsonConverter().toJson(instance.dtype);
  val['LF'] = linkFunctionToJson(instance.linkFunction);
  val['PL'] = instance.positiveLabel;
  val['NL'] = instance.negativeLabel;
  writeNotNull('CPI', instance.costPerIteration);
  val[r'$V'] = instance.schemaVersion;
  return val;
}
