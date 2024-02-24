import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:odontogram/models/recognition.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ObjectDetection {
  static const String _modelPath = 'assets/models/efficientdet.tflite';
  static const String _labelPath = 'assets/models/efficientdet.txt';
  static const int _mlModelInputSize = 320;
  static const double _confidence = 0.4;

  Interpreter? _interpreter;
  List<String>? _labels;

  ObjectDetection() {
    _loadModel();
    _loadLabels();
  }

  Future<void> _loadModel() async {
    final interpreterOptions = InterpreterOptions();

    if (Platform.isAndroid) {
      interpreterOptions.addDelegate(XNNPackDelegate());
    }

    if (Platform.isIOS) {
      interpreterOptions.addDelegate(GpuDelegate());
    }

    _interpreter =
        await Interpreter.fromAsset(_modelPath, options: interpreterOptions);
  }

  Future<void> _loadLabels() async {
    final labelsRaw = await rootBundle.loadString(_labelPath);
    _labels = labelsRaw.split('\n');
  }

  List<Recognition> analyseImage(String imagePath) {
    final imageData = File(imagePath).readAsBytesSync();
    final image = img.decodeImage(imageData);
    final imageInput = img.copyResize(
      image!,
      width: _mlModelInputSize,
      height: _mlModelInputSize,
    );
    final imageMatrix = List.generate(
      imageInput.height,
      (y) => List.generate(
        imageInput.width,
        (x) {
          final pixel = imageInput.getPixel(x, y);
          return [pixel.r, pixel.g, pixel.b];
        },
      ),
    );

    final output = _runInference(imageMatrix);

    final locationsRaw = output.elementAt(1).first as List<List<double>>;
    final List<Rect> locations = locationsRaw
        .map(
            (list) => list.map((value) => (value * _mlModelInputSize)).toList())
        .map((rect) => Rect.fromLTRB(rect[1], rect[0], rect[3], rect[2]))
        .toList();

    final classesRaw = output.last.first as List<double>;
    final classes = classesRaw.map((value) => value.toInt()).toList();

    final scores = output.first.first as List<double>;

    final numberOfDetectionsRaw = output.elementAt(2).first as double;
    final numberOfDetections = numberOfDetectionsRaw.toInt();

    final List<String> classification = [];
    for (var i = 0; i < numberOfDetections; i++) {
      classification.add(_labels![classes[i]]);
    }

    List<Recognition> recognitions = [];
    for (int i = 0; i < numberOfDetections; i++) {
      var score = scores[i];
      var label = classification[i];

      if (score > _confidence) {
        recognitions.add(
          Recognition(i, label, score, locations[i]),
        );
      }
    }
    return recognitions;
  }

  List<List<Object>> _runInference(
    List<List<List<num>>> imageMatrix,
  ) {
    // Set input tensor [1, 320, 320, 3]
    final input = [imageMatrix];

    // Set output tensor
    // Classes: [1, 25],
    // Locations: [1, 25, 4]
    // Number of detections: [1]
    // Scores: [1, 25],
    final output = {
      0: [List<num>.filled(25, 0)],
      1: [List<List<num>>.filled(25, List<num>.filled(4, 0))],
      2: [0.0],
      3: [List<num>.filled(25, 0)],
    };

    _interpreter!.runForMultipleInputs([input], output);
    return output.values.toList();
  }
}
