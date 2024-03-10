import 'package:flutter/services.dart';
import 'package:odontogram/models/tooth.dart';

class NativeClassificationService {
  static const nativeChannelName = 'com.example.smartodontogram';
  static const navigateFunctionName = 'nativeClassification';
  static const methodChannel = MethodChannel(nativeChannelName);

  Future<String> runNativeClassification(String patientId, ToothQuadrant quadrant) async {
    try {
      var data = await methodChannel.invokeMethod(
        navigateFunctionName,
        {
          'patientId': patientId,
          'quadrant': quadrant.intRepresentative
        }
      );
      return data;
    } on PlatformException catch (e) {
      return 'Failed to invoke: ${e.message}';
    }
  }
}
