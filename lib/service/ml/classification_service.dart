import 'dart:io';
import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:odontogram/utils/image_utils.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as image_lib;

class ImageClassificationHelper {
  static const modelPath = 'assets/efficientnet.tflite';
  static const labelsPath = 'assets/efficientnet.txt';

  late final Interpreter interpreter;
  late final List<String> labels;
  late final _IsolateInference _isolateInference;
  late Tensor inputTensor;
  late Tensor outputTensor;

  Future<void> _loadModel() async {
    final options = InterpreterOptions();

    if (Platform.isAndroid) {
      options.addDelegate(XNNPackDelegate());
    }

    if (Platform.isIOS) {
      options.addDelegate(GpuDelegate());
    }

    interpreter = await Interpreter.fromAsset(modelPath, options: options);
    // Get tensor input shape [1, 224, 224, 3]
    inputTensor = interpreter.getInputTensors().first;
    // Get tensor output shape [1, 1001]
    outputTensor = interpreter.getOutputTensors().first;
    print("input & output tensor");
    print(inputTensor);
    print(outputTensor);
  }

  Future<void> _loadLabels() async {
    final labelTxt = await rootBundle.loadString(labelsPath);
    labels = labelTxt.split('\n');
  }

  Future<void> initHelper() async {
    _loadLabels();
    _loadModel();
    _isolateInference = _IsolateInference();
    await _isolateInference.start();
  }

  Future<Map<String, double>> _inference(_InferenceModel inferenceModel) async {
    ReceivePort responsePort = ReceivePort();
    _isolateInference.sendPort
        .send(inferenceModel..responsePort = responsePort.sendPort);
    var results = await responsePort.first;
    return results;
  }

  Future<Map<String, double>> inferenceCameraFrame(
      CameraImage cameraImage) async {
    var isolateModel = _InferenceModel(cameraImage, null, interpreter.address,
        labels, inputTensor.shape, outputTensor.shape);
    return _inference(isolateModel);
  }

  Future<Map<String, double>> inferenceImage(image_lib.Image image) async {
    var isolateModel = _InferenceModel(null, image, interpreter.address, labels,
        inputTensor.shape, outputTensor.shape);
    return _inference(isolateModel);
  }

  Future<void> close() async {
    _isolateInference.close();
  }
}

class _IsolateInference {
  static const String _debugName = "TFLITE_INFERENCE";
  final ReceivePort _receivePort = ReceivePort();
  late Isolate _isolate;
  late SendPort _sendPort;

  SendPort get sendPort => _sendPort;

  Future<void> start() async {
    _isolate = await Isolate.spawn<SendPort>(entryPoint, _receivePort.sendPort,
        debugName: _debugName);
    _sendPort = await _receivePort.first;
  }

  Future<void> close() async {
    _isolate.kill();
    _receivePort.close();
  }

  static void entryPoint(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (final _InferenceModel isolateModel in port) {
      image_lib.Image? img;
      if (isolateModel.isCameraFrame()) {
        img = convertYUV420ToImage(isolateModel.cameraImage!);
      } else {
        img = isolateModel.image;
      }

      // resize original image to match model shape.
      image_lib.Image imageInput = image_lib.copyResize(
        img!,
        width: isolateModel.inputShape[1],
        height: isolateModel.inputShape[2],
      );

      if (Platform.isAndroid && isolateModel.isCameraFrame()) {
        imageInput = image_lib.copyRotate(imageInput, angle: 90);
      }

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

      // Set tensor input [1, 224, 224, 3]
      final input = [imageMatrix];
      // Set tensor output [1, 1001]
      final output = [List<int>.filled(isolateModel.outputShape[1], 0)];
      // // Run inference

      Interpreter interpreter =
          Interpreter.fromAddress(isolateModel.interpreterAddress);
      interpreter.run(input, output);
      // Get first output tensor
      final result = output.first;
      int maxScore = result.reduce((a, b) => a + b);
      // Set classification map {label: points}
      var classification = <String, double>{};
      for (var i = 0; i < result.length; i++) {
        if (result[i] != 0) {
          // Set label: points
          classification[isolateModel.labels[i]] =
              result[i].toDouble() / maxScore.toDouble();
        }
      }
      isolateModel.responsePort.send(classification);
    }
  }
}

class _InferenceModel {
  CameraImage? cameraImage;
  image_lib.Image? image;
  int interpreterAddress;
  List<String> labels;
  List<int> inputShape;
  List<int> outputShape;
  late SendPort responsePort;

  _InferenceModel(this.cameraImage, this.image, this.interpreterAddress,
      this.labels, this.inputShape, this.outputShape);

  // check if it is camera frame or still image
  bool isCameraFrame() {
    return cameraImage != null;
  }
}
