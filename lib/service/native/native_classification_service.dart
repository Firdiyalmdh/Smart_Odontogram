import 'package:flutter/services.dart';
import 'package:odontogram/models/tooth.dart';

class NativeClassificationService {
  static const nativeChannelName = 'com.example.smartodontogram';
  static const methodChannel = MethodChannel(nativeChannelName);

  static const navigateFunctionName = 'nativeClassification';

  Future<String> runNativeClassification(String userid, ToothQuadrant quadrant) async {
    try {
      var data = await methodChannel.invokeMethod(
        navigateFunctionName,
        {
          'userId': userid,
          'quadrant': quadrant.intRepresentative
        }
      );
      return data;
    } on PlatformException catch (e) {
      return 'Failed to invoke: ${e.message}';
    }
  }
}
