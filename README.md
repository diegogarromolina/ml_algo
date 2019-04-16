[![Build Status](https://travis-ci.com/gyrdym/ml_algo.svg?branch=master)](https://travis-ci.com/gyrdym/ml_algo)
[![Coverage Status](https://coveralls.io/repos/github/gyrdym/ml_algo/badge.svg?branch=master)](https://coveralls.io/github/gyrdym/ml_algo?branch=master)
[![pub package](https://img.shields.io/pub/v/ml_algo.svg)](https://pub.dartlang.org/packages/ml_algo)
[![Gitter Chat](https://badges.gitter.im/gyrdym/gyrdym.svg)](https://gitter.im/gyrdym/)

# Machine learning algorithms with dart

**Table of contents**
- [What for is the library?](#what-is-the-ml_algo-for)
- [The library's structure](#the-librarys-structure)
- [Examples](#examples)
    - [Logistic regression](#logistic-regression)
    - [Softmax regression](#softmax-regression)

## What is the ml_algo for?

The main purpose of the library - to give developers, interested both in Dart language and data science, native Dart 
implementation of machine learning algorithms. This library targeted to dart vm, so, to get smoothest experience with 
the lib, please, do not use it in a browser.

**Following algorithms are implemented:**
- *Linear regression:*
    - Gradient descent algorithm (batch, mini-batch, stochastic) with ridge regularization
    - Lasso regression

- *Linear classifier:*
    - Logistic regression (with "one-vs-all" multiclass classification)
    - Softmax regression
    
- *Non-parametric regression:*
    - KNN regression
    
## The library's structure

To provide main purposes of machine learning, the library exposes the following classes:

- [CrossValidator](https://github.com/gyrdym/ml_algo/blob/master/lib/src/model_selection/cross_validator/cross_validator.dart). Factory, that creates 
instances of a cross validator. In a few words, this entity allows researchers to fit different [hyperparameters](https://en.wikipedia.org/wiki/Hyperparameter_(machine_learning)) of machine learning
algorithms, assessing prediction quality on different parts of a dataset. 

- [LinearClassifier.logisticRegressor](https://github.com/gyrdym/ml_algo/blob/master/lib/src/classifier/linear_classifier.dart). An algorithm,
that performs simplest linear classification. If you want to use this classifier for your data, please, make sure, that 
your data is [linearly separable](https://en.wikipedia.org/wiki/Linear_separability). Multiclass classification is also
supported (see [ovr classification](https://en.wikipedia.org/wiki/Multiclass_classification#One-vs.-rest))

- [LinearClassifier.softmaxRegressor](https://github.com/gyrdym/ml_algo/blob/master/lib/src/classifier/linear_classifier.dart). 
An algorithm, that performs simplest linear multiclass classification. As well as for logistic regression, if you want to use 
this classifier for your data, please, make sure, that your data is [linearly separable](https://en.wikipedia.org/wiki/Linear_separability).

- [LinearRegressor.gradient](https://github.com/gyrdym/ml_algo/blob/master/lib/src/regressor/linear_regressor.dart). A 
well-known algorithm, that performs linear regression using [gradient vector](https://en.wikipedia.org/wiki/Gradient) of a cost 
function.

- [LinearRegressor.lasso](https://github.com/gyrdym/ml_algo/blob/master/lib/src/regressor/linear_regressor.dart) An algorithm, 
that performs feature selection along with regression process. The heart of the algorithm - coordinate descent 
optimization. If you want to decide, which features are less important - go ahead and use this regressor. 

- [NoNParametricRegressor.nearestNeighbor](https://github.com/gyrdym/ml_algo/blob/master/lib/src/regressor/non_parametric_regressor.dart)
An algorithm, that makes prediction for each new observation based on first `k` closest observations from training data.
It has quite high computational complexity, but in the same time it may easily catch non-linear pattern of the data. 

## Examples

### Logistic regression

Let's classify records from well-known dataset - [Pima Indians Diabets Database](https://www.kaggle.com/uciml/pima-indians-diabetes-database)
via [Logistic regressor](https://github.com/gyrdym/ml_algo/blob/master/lib/src/classifier/linear_classifier.dart)

Import all necessary packages. First, it's needed to ensure, if you have `ml_preprocessing` package in your 
dependencies:

````
dependencies:
  ml_preprocessing: ^3.2.0
````

We need this repo to parse raw data in order to use it farther. For more details, please,
visit [ml_preprocessing](https://github.com/gyrdym/ml_preprocessing) repository page.

````dart  
import 'dart:async';

import 'package:ml_algo/ml_algo.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
````

Download dataset from [Pima Indians Diabets Database](https://www.kaggle.com/uciml/pima-indians-diabetes-database) and 
read it (of course, you should provide a proper path to your downloaded file): 

````dart
final data = DataFrame.fromCsv('datasets/pima_indians_diabetes_database.csv', 
  labelName: 'class variable (0 or 1)');
final features = await data.features;
final labels = await data.labels;
````

Data in this file is represented by 768 records and 8 features. 9th column is a label column, it contains either 0 or 1 
on each row. This column is our target - we should predict a class label for each observation. Therefore, we 
should point, where to get label values. Let's use `labelName` parameter for that (labels column name, 'class variable 
(0 or 1)' in our case).  
 
Processed features and labels are contained in data structures of `Matrix` type. To get more information about 
`Matrix` type, please, visit [ml_linal repo](https://github.com/gyrdym/ml_linalg)

Then, we should create an instance of `CrossValidator` class for fitting [hyperparameters](https://en.wikipedia.org/wiki/Hyperparameter_(machine_learning))
of our model
````dart
final validator = CrossValidator.KFold(numberOfFolds: 5);
````

All are set, so, we can do our classification.

Let's create a logistic regression classifier instance with full-batch gradient descent optimizer:
````dart
final model = LinearClassifier.logisticRegressor(
    initialLearningRate: .8,
    iterationsLimit: 500,
    gradientType: GradientType.batch,
    fitIntercept: true,
    interceptScale: 0.1,
    learningRateType: LearningRateType.constant);
````

Evaluate our model via accuracy metric:
````dart
final accuracy = validator.evaluate(model, featuresMatrix, labels, MetricType.accuracy);
````

Let's print score:
````dart
print('accuracy on classification: ${accuracy.toStringAsFixed(2)}');
````

We will see something like this:

````
acuracy on classification: 0.77
````

All the code above all together:
````dart
import 'dart:async';

import 'package:ml_algo/ml_algo.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';

Future main() async {
  final data = DataFrame.fromCsv('datasets/pima_indians_diabetes_database.csv', 
     labelName: 'class variable (0 or 1)');
  
  final features = await data.features;
  final labels = await data.labels;

  final validator = CrossValidator.kFold(numberOfFolds: 5);
  
  final model = LinearClassifier.logisticRegressor(
    initialLearningRate: .8,
    iterationsLimit: 500,
    gradientType: GradientType.batch,
    fitIntercept: true,
    interceptScale: .1,
    learningRateType: LearningRateType.constant);
  
  final accuracy = validator.evaluate(model, features, labels, MetricType.accuracy);

  print('accuracy on classification: ${accuracy.toStringFixed(2)}');
}
````

### Softmax regression
Let's classify another famous dataset - [Iris dataset](https://www.kaggle.com/uciml/iris). Data in this csv is separated into 3 classes - therefore we need
to use different approach to data classification - [Softmax regression](http://deeplearning.stanford.edu/tutorial/supervised/SoftmaxRegression/).

As usual, start with data preparation. Before we start, we should update our pubspec's dependencies with [xrange](https://github.com/gyrdym/xrange)` 
library: 

````
dependencies:
    ...
    xrange: ^0.0.5
    ...
````

Download the file and read it:

````Dart
final data = DataFrame.fromCsv('datasets/iris.csv',
    labelName: 'Species',
    columns: [ZRange.closed(1, 5)],
    categories: {
      'Species': CategoricalDataEncoderType.oneHot,
    },
);

final features = await data.features;
final labels = await data.labels;
````

The csv database has 6 columns, but we need to get rid of the first column, because it contains just ID of every 
observation - it's absolutely useless data. So, as you may notice, we provided a columns range to exclude ID-column:

````Dart
columns: [ZRange.closed(1, 5)]
````

Also, since the label column 'Species' has categorical data, we encoded it to numerical format:

````Dart
categories: {
  'Species': CategoricalDataEncoderType.oneHot,
},
````

Next step - create a cross validator instance:

````Dart
final validator = CrossValidator.kFold(numberOfFolds: 5);
````

And finally, create an instance of the classifier:

````Dart
final softmaxRegressor = LinearClassifier.softmaxRegressor(
      initialLearningRate: 0.03,
      iterationsLimit: null,
      minWeightsUpdate: 1e-6,
      randomSeed: 46,
      learningRateType: LearningRateType.constant);
````

Evaluate quality of prediction:

````Dart
final accuracy = validator.evaluate(softmaxRegressor, features, labels, MetricType.accuracy);

print('Iris dataset, softmax regression: accuracy is '
  '${accuracy.toStringAsFixed(2)}'); // It yields 0.93
````

Gather all the code above all together:

````Dart
import 'dart:async';

import 'package:ml_algo/ml_algo.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:xrange/zrange.dart';

Future main() async {
  final data = DataFrame.fromCsv('datasets/iris.csv',
    labelName: 'Species',
    columns: [ZRange.closed(1, 5)],
    categories: {
      'Species': CategoricalDataEncoderType.oneHot,
    },
  );

  final features = await data.features;
  final labels = await data.labels;

  final validator = CrossValidator.kFold(numberOfFolds: 5);

  final softmaxRegressor = LinearClassifier.softmaxRegressor(
      initialLearningRate: 0.03,
      iterationsLimit: null,
      minWeightsUpdate: 1e-6,
      randomSeed: 46,
      learningRateType: LearningRateType.constant);

  final accuracy = validator.evaluate(
      softmaxRegressor, features, labels, MetricType.accuracy);

  print('Iris dataset, softmax regression: accuracy is '
      '${accuracy.toStringAsFixed(2)}');
}
````

For more examples, please, visit [ml_algo_examples](https://github.com/gyrdym/ml_algo_examples) repository

### Contacts
If you have questions, feel free to write me on 
 - [Facebook](https://www.facebook.com/ilya.gyrdymov)
 - [Linkedin](https://www.linkedin.com/in/gyrdym/)
